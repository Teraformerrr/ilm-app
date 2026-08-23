package com.example.ilm

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class IlmDailyWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { id ->
            val views =
                RemoteViews(
                    context.packageName,
                    R.layout.ilm_daily_widget,
                )

            val arabic =
                widgetData.getString(
                    "ilm_widget_ayah_arabic",
                    "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
                ) ?: ""

            val translation =
                widgetData.getString(
                    "ilm_widget_ayah_translation",
                    "Verily in the remembrance of Allah do hearts find rest.",
                ) ?: ""

            val ayahReference =
                widgetData.getString(
                    "ilm_widget_ayah_reference",
                    "Ar-Ra'd • 13:28",
                ) ?: ""

            val hadith =
                widgetData.getString(
                    "ilm_widget_hadith_text",
                    "The most beloved deeds to Allah are those that are most consistent, even if they are small.",
                ) ?: ""

            val hadithReference =
                widgetData.getString(
                    "ilm_widget_hadith_reference",
                    "Sahih al-Bukhari 6464",
                ) ?: ""

            views.setTextViewText(
                R.id.widget_arabic,
                arabic,
            )

            views.setTextViewText(
                R.id.widget_ayah_translation,
                translation,
            )

            views.setTextViewText(
                R.id.widget_ayah_reference,
                ayahReference,
            )

            views.setTextViewText(
                R.id.widget_hadith,
                hadith,
            )

            views.setTextViewText(
                R.id.widget_hadith_reference,
                hadithReference,
            )

            attachOpenAppAction(
                context,
                views,
                id,
            )

            appWidgetManager.updateAppWidget(
                id,
                views,
            )
        }
    }
}

fun attachOpenAppAction(
    context: Context,
    views: RemoteViews,
    appWidgetId: Int,
) {
    val intent =
        context.packageManager
            .getLaunchIntentForPackage(
                context.packageName,
            )
            ?.apply {
                flags =
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP
            }

    if (intent == null) {
        return
    }

    val pendingIntent =
        PendingIntent.getActivity(
            context,
            appWidgetId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or
                PendingIntent.FLAG_IMMUTABLE,
        )

    views.setOnClickPendingIntent(
        R.id.widget_root,
        pendingIntent,
    )
}