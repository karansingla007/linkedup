package com.linkedUp

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import android.content.Intent

class MainActivity: FlutterActivity() {
    private val sharedData: HashMap<String, String> = HashMap()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        handleSendIntent(intent)
        MethodChannel(flutterView, "app.channel.shared.data").setMethodCallHandler { call, result ->
            try {
                if (call.method.contentEquals("getSharedData")) {
                    result.success(sharedData)
                    sharedData.clear()
                }
            } catch (e: Exception) {
                result.error("method channel failed", null, e)

            }
        }
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        // Handle intent when app is resumed
        if (intent != null) {
            handleSendIntent(intent)
        }
    }

    private fun handleSendIntent(intent: Intent) {
        val action = intent.action

        if (Intent.ACTION_VIEW == action) {
            if (intent.data?.host.equals("linkedUp.co.in", true)) {
                sharedData.put("shared_link_click", intent.data.toString())
            }
        }
    }
}
