package com.pranrfl.express_erp
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
class MainActivity: FlutterActivity(){

    private val CHANNEL = "com.expressErp.appInfo"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "getAppInfo") {
                val variable_name = getAppInfo()
                result.success(variable_name) 
                // if (batteryLevel != -1) {
                //     result.success(batteryLevel)
                // } else {
                //     result.error("UNAVAILABLE", "Battery level not available.", null)
                // }
            } else {
                result.notImplemented()
            }
        }
    }


   private fun getAppInfo(): String {
    val packageManager = packageManager // Retrieve PackageManager from Context
    val packageInfo = packageManager.getPackageInfo(packageName, 0) // Get PackageInfo
    return packageInfo.versionName ?: "Unknown" // Return versionName or fallback
}

}
