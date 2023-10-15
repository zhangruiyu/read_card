package com.mhz.read_card

import android.app.Activity
import android.content.Context
import com.mhz.read_card.func.ReadIDFunc
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.RuntimeException

/** ReadCardPlugin */
class ReadCardPlugin(var activity: Activity) : FlutterPlugin,
    MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context
    private var readIDFunc: ReadIDFunc? = null
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "read_card")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "initEid") {
            val appid = call.argument<String>("appId")!!
            val ip = call.argument<String>("ip")!!
            val port = call.argument<Int>("port")!!
            val envCode = call.argument<Int>("envCode")!!
            try {
                ReadCardManager.initEid(applicationContext, appid, ip, port, envCode)
                result.success(true)
            } catch (e: Exception) {
                e.printStackTrace()
                result.success(false)
            }

        } else if (call.method == "readId") {
            if (readIDFunc != null) {
                throw RuntimeException("使用完后请调用release方法")
            }
            this.readIDFunc = ReadIDFunc(activity, result,channel)
        } else if (call.method == "release") {
            this.readIDFunc = null
            ReadCardManager.eid.release()
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }
}
