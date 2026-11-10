package com.justus.justus

import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

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
                else -> result.notImplemented()
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        methodChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
