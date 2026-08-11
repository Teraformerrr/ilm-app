package com.example.ilm

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class AdhanPlaybackService : Service() {

    companion object {
        private const val CHANNEL_ID = "ilm_adhan_playback"
        private const val NOTIFICATION_ID = 7001
        const val ACTION_STOP_ADHAN = "com.example.ilm.STOP_ADHAN"
    }

    private var mediaPlayer: MediaPlayer? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int,
    ): Int {
        if (intent?.action == ACTION_STOP_ADHAN) {
            stopAdhan()
            return START_NOT_STICKY
        }

        val prayerName =
            intent?.getStringExtra("prayer_name") ?: "Prayer"

        startForeground(
            NOTIFICATION_ID,
            buildNotification(prayerName),
        )

        playAdhan()

        return START_NOT_STICKY
    }

    private fun playAdhan() {
        if (mediaPlayer?.isPlaying == true) {
            return
        }

        mediaPlayer?.release()

        mediaPlayer = MediaPlayer.create(
            this,
            R.raw.adhan_default,
        ).apply {
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(
                        AudioAttributes.CONTENT_TYPE_MUSIC,
                    )
                    .build(),
            )

            isLooping = false

            setOnCompletionListener {
                stopAdhan()
            }

            setOnErrorListener { _, _, _ ->
                stopAdhan()
                true
            }

            start()
        }
    }

    private fun stopAdhan() {
        mediaPlayer?.let {
            if (it.isPlaying) {
                it.stop()
            }

            it.reset()
            it.release()
        }

        mediaPlayer = null

        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun buildNotification(
        prayerName: String,
    ): android.app.Notification {
        val openAppIntent = packageManager
            .getLaunchIntentForPackage(packageName)

        val openAppPendingIntent =
            PendingIntent.getActivity(
                this,
                0,
                openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or
                    PendingIntent.FLAG_IMMUTABLE,
            )

        val stopIntent =
            Intent(
                this,
                AdhanPlaybackService::class.java,
            ).apply {
                action = ACTION_STOP_ADHAN
            }

        val stopPendingIntent =
            PendingIntent.getService(
                this,
                1,
                stopIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or
                    PendingIntent.FLAG_IMMUTABLE,
            )

        return NotificationCompat.Builder(
            this,
            CHANNEL_ID,
        )
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("$prayerName Adhan")
            .setContentText(
                "It is time for $prayerName Salah.",
            )
            .setPriority(
                NotificationCompat.PRIORITY_HIGH,
            )
            .setCategory(
                NotificationCompat.CATEGORY_ALARM,
            )
            .setOngoing(true)
            .setContentIntent(openAppPendingIntent)
            .addAction(
                android.R.drawable.ic_media_pause,
                "Stop Adhan",
                stopPendingIntent,
            )
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT <
            Build.VERSION_CODES.O) {
            return
        }

        val channel = NotificationChannel(
            CHANNEL_ID,
            "Adhan Playback",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description =
                "Shows while ILM is playing the Adhan."
            setSound(null, null)
        }

        val notificationManager =
            getSystemService(
                NotificationManager::class.java,
            )

        notificationManager.createNotificationChannel(
            channel,
        )
    }

    override fun onDestroy() {
        mediaPlayer?.release()
        mediaPlayer = null

        super.onDestroy()
    }

    override fun onBind(
        intent: Intent?,
    ): IBinder? {
        return null
    }
}