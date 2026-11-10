package com.justus.justus

import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.MediaScannerConnection
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.PowerManager
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL_NAME = "com.justus.justus/device_lock"

        @Volatile
        var deviceWasLocked: Boolean = false

        private var methodChannel: MethodChannel? = null

        fun notifyDeviceLocked() {
            deviceWasLocked = true
            methodChannel?.invokeMethod("onDeviceLocked", null)
        }
    }

    private val screenReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == Intent.ACTION_SCREEN_OFF) {
                deviceWasLocked = true
                runOnUiThread {
                    try {
                        methodChannel?.invokeMethod("onDeviceLocked", null)
                    } catch (e: Exception) {
                        // Flutter engine might be suspended; handled on resume
                    }
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val filter = IntentFilter(Intent.ACTION_SCREEN_OFF)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            applicationContext.registerReceiver(screenReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            applicationContext.registerReceiver(screenReceiver, filter)
        }

        try {
            startService(Intent(this, AppLifecycleTaskService::class.java))
        } catch (e: Exception) {
            // Background service restrictions may apply if not foreground
        }
    }

    override fun onStop() {
        super.onStop()
        val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
        // If the screen is turning off or device is not interactive when stopped
        if (powerManager?.isInteractive == false) {
            deviceWasLocked = true
            runOnUiThread {
                try {
                    methodChannel?.invokeMethod("onDeviceLocked", null)
                } catch (e: Exception) {
                    // Ignored
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            applicationContext.unregisterReceiver(screenReceiver)
        } catch (e: Exception) {
            // Ignored
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel = channel

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkAndResetDeviceLocked" -> {
                    val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
                    val isKeyguardLocked = keyguardManager?.isKeyguardLocked ?: false
                    val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
                    val isNotInteractive = powerManager?.isInteractive == false

                    val wasLocked = deviceWasLocked || isKeyguardLocked || isNotInteractive
                    deviceWasLocked = false
                    result.success(wasLocked)
                }
                "moveTaskToBack" -> {
                    val moved = moveTaskToBack(true)
                    result.success(moved)
                }
                "saveImageToGallery" -> {
                    val filePath = call.argument<String>("filePath")
                    val mimeType = call.argument<String>("mimeType") ?: "image/jpeg"
                    if (filePath == null) {
                        result.error("INVALID_ARGUMENT", "filePath cannot be null", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val sourceFile = File(filePath)
                        if (!sourceFile.exists()) {
                            result.error("FILE_NOT_FOUND", "Source file does not exist", null)
                            return@setMethodCallHandler
                        }

                        val ext = when {
                            mimeType.contains("png") -> "png"
                            mimeType.contains("mp4") || mimeType.contains("video") -> "mp4"
                            else -> "jpg"
                        }
                        val isVideo = ext == "mp4"
                        val fileName = "JustUS_${System.currentTimeMillis()}.$ext"

                        val contentValues = ContentValues().apply {
                            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                            put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                val relDir = if (isVideo) Environment.DIRECTORY_MOVIES + "/JustUS" else Environment.DIRECTORY_PICTURES + "/JustUS"
                                put(MediaStore.MediaColumns.RELATIVE_PATH, relDir)
                                put(MediaStore.MediaColumns.IS_PENDING, 1)
                            }
                        }

                        val collectionUri = if (isVideo) {
                            MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                        } else {
                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                        }

                        val itemUri = contentResolver.insert(collectionUri, contentValues)
                        if (itemUri != null) {
                            contentResolver.openOutputStream(itemUri)?.use { output ->
                                FileInputStream(sourceFile).use { input ->
                                    input.copyTo(output)
                                }
                            }
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                contentValues.clear()
                                contentValues.put(MediaStore.MediaColumns.IS_PENDING, 0)
                                contentResolver.update(itemUri, contentValues, null, null)
                            } else {
                                MediaScannerConnection.scanFile(
                                    applicationContext,
                                    arrayOf(sourceFile.absolutePath),
                                    arrayOf(mimeType),
                                    null
                                )
                            }
                            result.success(true)
                        } else {
                            result.error("INSERT_FAILED", "Failed to create MediaStore entry", null)
                        }
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", e.localizedMessage, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        methodChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
