import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GuidelineScreen extends StatelessWidget {
  const GuidelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习攻略'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://enladder.com/guideline"), // Replace with the actual URL you want to embed
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          // You can perform additional setup here if needed
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
