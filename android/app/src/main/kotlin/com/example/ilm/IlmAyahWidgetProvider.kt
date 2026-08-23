package com.example.ilm

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class IlmAyahWidgetProvider : HomeWidgetProvider() {

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
                    R.layout.ilm_ayah_widget,
                )

            views.setTextViewText(
                R.id.widget_arabic,
                widgetData.getString(
                    "ilm_widget_ayah_arabic",
                    "أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
                ),
            )

            views.setTextViewText(
                R.id.widget_content,
                widgetData.getString(
                    "ilm_widget_ayah_translation",
                    "Verily in the remembrance of Allah do hearts find rest.",
                ),
            )

            views.setTextViewText(
                R.id.widget_reference,
                widgetData.getString(
                    "ilm_widget_ayah_reference",
                    "Ar-Ra'd • 13:28",
                ),
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