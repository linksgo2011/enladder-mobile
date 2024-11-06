package com.enladder.enladder_mobile
import android.os.Bundle
import android.webkit.WebView
import io.flutter.embedding.android.FlutterActivity
import com.enladder.enladder_mobile.BuildConfig

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 启用 WebView 调试
        if (BuildConfig.DEBUG) {
            WebView.setWebContentsDebuggingEnabled(true)
        }
    }
}