import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true; // For managing the loading state

  @override
  void dispose() {
    _controller.future.then((controller) {
      controller.clearCache();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebView(
            initialUrl: 'http://172.2.200.15/fos3/fostv/ftv_show/index.php',
            javascriptMode: JavascriptMode.unrestricted,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (String url) async {
              setState(() {
                isLoading = false;
              });
              final controller = await _controller.future;
              // Ensure video element exists before playing it
              controller.runJavascript("""
                var videoElement = document.querySelector('video');
                if (videoElement) {
                  videoElement.play();
                } else {
                  console.log('No video element found');
                }
              """);
            },
            onWebResourceError: (WebResourceError error) {
              setState(() {
                isLoading = false;
              });
              // Log error code and description for better debugging
              print('Error code: ${error.errorCode}');
              print('Description: ${error.description}');
            },
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
