import 'dart:async';
import 'package:chapasdk/domain/constants/app_colors.dart';
import 'package:chapasdk/domain/constants/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:chapasdk/domain/constants/common.dart';

class ChapaWebView extends StatefulWidget {
  final String url;
  final String fallBackNamedUrl;
  final String transactionReference;
  final String amountPaid;

  //ttx
  //amount
  //description
  //

  // ignore: use_super_parameters
  const ChapaWebView(
      {Key? key,
      required this.url,
      required this.fallBackNamedUrl,
      required this.transactionReference,
      required this.amountPaid})
      : super(key: key);

  @override
  State<ChapaWebView> createState() => _ChapaWebViewState();
}

class _ChapaWebViewState extends State<ChapaWebView> {
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
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        setState(() {
          isOffline = true;
        });
        showErrorToast(ChapaStrings.connectionError);

        exitPaymentPage(ChapaStrings.connectionError);
      } else if (result.contains(ConnectivityResult.mobile)) {
        setState(() {
          isOffline = false;
        });
      } else if (result.contains(ConnectivityResult.wifi)) {
        setState(() {
          isOffline = false;
        });
      } else if (result.contains(ConnectivityResult.ethernet)) {
        setState(() {
          isOffline = false;
        });
      } else if (result.contains(ConnectivityResult.bluetooth)) {
        setState(() {
          isOffline = false;
        });
        exitPaymentPage(ChapaStrings.connectionError);
      }
    });
  }

  exitPaymentPage(String message) {
    Navigator.pushReplacementNamed(
      context,
      widget.fallBackNamedUrl,
      arguments: {
        'message': message,
        'transactionReference': widget.transactionReference,
        'paidAmount': widget.amountPaid
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.chapaSecondaryColor,
          title: Text(
            "Checkout",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                exitPaymentPage("paymentCancelled");
              },
              icon: Text(
                "Cancel",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.white),
              ),
              label: Icon(
                Icons.close,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(
                  (widget.url),
                ),
              ),
              onWebViewCreated: (controller) {
                setState(() {
                  webViewController = controller;
                });
                controller.addJavaScriptHandler(
                    handlerName: "buttonState",
                    callback: (args) async {
                      webViewController = controller;
                      if (args[2][1] == 'CancelbuttonClicked') {
                        exitPaymentPage('paymentCancelled');
                      }

                      return args.reduce((curr, next) => curr + next);
                    });
              },
              onUpdateVisitedHistory: (InAppWebViewController controller,
                  Uri? uri, androidIsReload) async {
                if (uri.toString() == 'https://chapa.co') {
                  exitPaymentPage('paymentSuccessful');
                }
                if (uri.toString().contains('checkout/payment-receipt/')) {
                  // await delay();
                  await Future.delayed(const Duration(seconds: 5));
                  exitPaymentPage('paymentSuccessful');
                }
                controller.addJavaScriptHandler(
                    handlerName: "handlerFooWithArgs",
                    callback: (args) async {
                      webViewController = controller;
                      if (args[2][1] == 'failed') {
                        await delay();

                        exitPaymentPage('paymentFailed');
                      }
                      if (args[2][1] == 'success') {
                        await delay();
                        exitPaymentPage('paymentSuccessful');
                      }
                      return args.reduce((curr, next) => curr + next);
                    });

                controller.addJavaScriptHandler(
                    handlerName: "buttonState",
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == 'CancelbuttonClicked') {
                        exitPaymentPage('paymentCancelled');
                      }

                      return args.reduce((curr, next) => curr + next);
                    });
              },
            ),
          ),
        ]),
      ),
    );
  }
}
