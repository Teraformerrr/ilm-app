package com.example.ilm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class AdhanAlarmReceiver : BroadcastReceiver() {

    override fun onReceive(
        context: Context,
        intent: Intent,
    ) {
        val prayerName =
            intent.getStringExtra("prayer_name") ?: "Prayer"

        val serviceIntent =
            Intent(context, AdhanPlaybackService::class.java).apply {
                putExtra("prayer_name", prayerName)
            }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }
}