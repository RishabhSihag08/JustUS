package com.justus.justus

import android.app.Service
import android.content.Intent
import android.os.IBinder

/**
 * Service listening for when the app task is removed from Android recents.
 */
class AppLifecycleTaskService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_NOT_STICKY
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        MainActivity.deviceWasLocked = true
        MainActivity.notifyDeviceLocked()
        stopSelf()
    }
}
