import 'dart:async';
import 'dart:convert';
import 'package:chapasdk/constants/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'constants/common.dart';

class ChapaBulkTransferWebView extends StatefulWidget {
  final String url;
  final String fallBackNamedUrl;
  final String bulkTransferTitle;

  const ChapaBulkTransferWebView({
    Key? key,
    required this.url,
    required this.fallBackNamedUrl,
    required this.bulkTransferTitle,
  }) : super(key: key);

  @override
  State<ChapaBulkTransferWebView> createState() =>
      _ChapaBulkTransferWebViewState();
}

class _ChapaBulkTransferWebViewState extends State<ChapaBulkTransferWebView> {
  late InAppWebViewController webViewController;
  String url = "";
  double progress = 0;
  StreamSubscription? connection;
  bool isOffline = false;

  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }

  void checkConnectivity() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
        showErrorToast(ChapaStrings.connectionError);
        exitTransferPage(ChapaStrings.connectionError);
      } else {
        setState(() {
          isOffline = false;
        });
      }
    });
  }

  void exitTransferPage(String message) {
    Navigator.pushNamed(
      context,
      widget.fallBackNamedUrl,
      arguments: {
        'message': message,
        'bulkTransferTitle': widget.bulkTransferTitle,
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Bulk Transfer Status')),
        body: Column(
          children: <Widget>[
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                onWebViewCreated: (controller) {
                  setState(() {
                    webViewController = controller;
                  });
                  controller.addJavaScriptHandler(
                    handlerName: "buttonState",
                    callback: (args) async {
                      if (args[2][1] == 'CancelbuttonClicked') {
                        exitTransferPage('transferCancelled');
                      }
                      return args.reduce((curr, next) => curr + next);
                    },
                  );
                },
                onLoadStop:
                    (InAppWebViewController controller, Uri? uri) async {
                  String? pageContent = await controller.getHtml();
                  if (pageContent != null && pageContent.contains('{')) {
                    var jsonResponse = json.decode(pageContent);

                    if (jsonResponse['status'] == 'success') {
                      exitTransferPage('Bulk transfer queued successfully');
                    } else if (jsonResponse['status'] == 'failed') {
                      String errorMessage =
                          extractErrorMessage(jsonResponse['message']);
                      exitTransferPage(errorMessage);
                    }
                  }
                },
              ),
            ),
            if (isOffline)
              const Text(
                'You are offline. Check your internet connection.',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  String extractErrorMessage(Map<String, dynamic> message) {
    if (message.isNotEmpty) {
      var firstKey = message.keys.first;
      var firstErrorList = message[firstKey];
      if (firstErrorList is List && firstErrorList.isNotEmpty) {
        return firstErrorList[0];
      }
    }
    return 'An error occurred. Please try again.';
  }

  Future<void> delay() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
