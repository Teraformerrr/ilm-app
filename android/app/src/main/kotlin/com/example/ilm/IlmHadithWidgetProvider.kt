package com.example.ilm

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class IlmHadithWidgetProvider : HomeWidgetProvider() {

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
                    R.layout.ilm_hadith_widget,
                )

            views.setTextViewText(
                R.id.widget_content,
                widgetData.getString(
                    "ilm_widget_hadith_text",
                    "The most beloved deeds to Allah are those that are most consistent, even if they are small.",
                ),
            )

            views.setTextViewText(
                R.id.widget_reference,
                widgetData.getString(
                    "ilm_widget_hadith_reference",
                    "Sahih al-Bukhari 6464",
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