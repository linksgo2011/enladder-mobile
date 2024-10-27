package com.enladder.enladder_mobile
import android.os.Bundle
import android.webkit.WebView
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 启用 WebView 调试
        WebView.setWebContentsDebuggingEnabled(true)
    }
}