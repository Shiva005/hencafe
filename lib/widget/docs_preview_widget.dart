import 'package:flutter/material.dart';
import 'package:hencafe/utils/appbar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentPreviewScreen extends StatefulWidget {
  final String url;

  const DocumentPreviewScreen({super.key, required this.url});

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse("https://docs.google.com/gview?embedded=true&url=${widget.url}"),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Document Preview"),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          WebViewWidget(controller: _controller),
        ],
      ),
    );
  }
}
