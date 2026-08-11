package com.example.ilm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.example.ilm/adhan_alarm"
    }

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine,
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "scheduleAdhanAlarm" -> {
                    val alarmId =
                        call.argument<Int>("alarmId")

                    val triggerAtMillis =
                        call.argument<Long>("triggerAtMillis")

                    val prayerName =
                        call.argument<String>("prayerName")
                            ?: "Prayer"

                    if (
                        alarmId == null ||
                        triggerAtMillis == null
                    ) {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "alarmId and triggerAtMillis are required.",
                            null,
                        )

                        return@setMethodCallHandler
                    }

                    try {
                        scheduleAdhanAlarm(
                            alarmId = alarmId,
                            triggerAtMillis = triggerAtMillis,
                            prayerName = prayerName,
                        )

                        result.success(true)
                    } catch (error: Exception) {
                        result.error(
                            "SCHEDULE_FAILED",
                            error.message,
                            null,
                        )
                    }
                }

                "cancelAdhanAlarm" -> {
                    val alarmId =
                        call.argument<Int>("alarmId")

                    if (alarmId == null) {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "alarmId is required.",
                            null,
                        )

                        return@setMethodCallHandler
                    }

                    try {
                        cancelAdhanAlarm(
                            alarmId = alarmId,
                        )

                        result.success(true)
                    } catch (error: Exception) {
                        result.error(
                            "CANCEL_FAILED",
                            error.message,
                            null,
                        )
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun scheduleAdhanAlarm(
        alarmId: Int,
        triggerAtMillis: Long,
        prayerName: String,
    ) {
        val alarmManager =
            getSystemService(
                Context.ALARM_SERVICE,
            ) as AlarmManager

        val intent =
            Intent(
                this,
                AdhanAlarmReceiver::class.java,
            ).apply {
                putExtra(
                    "prayer_name",
                    prayerName,
                )
            }

        val pendingIntent =
            PendingIntent.getBroadcast(
                this,
                alarmId,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or
                    PendingIntent.FLAG_IMMUTABLE,
            )

        if (
            Build.VERSION.SDK_INT >=
            Build.VERSION_CODES.S &&
            !alarmManager.canScheduleExactAlarms()
        ) {
            throw IllegalStateException(
                "Exact alarm permission is not enabled.",
            )
        }

        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            triggerAtMillis,
            pendingIntent,
        )
    }

    private fun cancelAdhanAlarm(
        alarmId: Int,
    ) {
        val alarmManager =
            getSystemService(
                Context.ALARM_SERVICE,
            ) as AlarmManager

        val intent =
            Intent(
                this,
                AdhanAlarmReceiver::class.java,
            )

        val pendingIntent =
            PendingIntent.getBroadcast(
                this,
                alarmId,
                intent,
                PendingIntent.FLAG_NO_CREATE or
                    PendingIntent.FLAG_IMMUTABLE,
            )

        if (pendingIntent != null) {
            alarmManager.cancel(
                pendingIntent,
            )

            pendingIntent.cancel()
        }
    }
}