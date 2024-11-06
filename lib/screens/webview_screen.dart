import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final String title;

  WebViewScreen({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(url),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          // Additional setup if needed
        },
        onLoadStart: (InAppWebViewController controller, Uri? url) {
          // Handle actions when a page starts loading
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) async {
          // Handle actions when a page finishes loading
        },
        onLoadError: (InAppWebViewController controller, Uri? url, int code, String message) {
          // Handle errors during page load
        },
      ),
    );
  }
}