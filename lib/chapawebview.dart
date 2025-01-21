import 'dart:async';
import 'package:chapasdk/domain/constants/app_colors.dart';
import 'package:chapasdk/domain/constants/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:chapasdk/domain/constants/common.dart';

/// A widget for displaying the Chapa Web Checkout process in a web view.

// ignore: must_be_immutable
class ChapaWebView extends StatefulWidget {
  /// The Checkout URL to be loaded in the web view.
  final String url;

  /// The fallback route name to navigate to when exiting the payment page.
  final String fallBackNamedUrl;

  /// The reference ID for the current transaction.s
  final String transactionReference;

  /// The amount paid for the transaction.
  final String amountPaid;

  /// A callback triggered when the payment process is finished if the fallBackNamedUrl is Empty .
  ///
  /// The callback parameters are:
  /// - `String`: Payment status.
  /// - `String`: Transaction reference.
  /// - `String`: Amount paid.
  Function(String, String, String)? onPaymentFinished;

  // ignore: use_super_parameters
  ChapaWebView({
    Key? key,
    required this.url,
    required this.fallBackNamedUrl,
    required this.transactionReference,
    required this.amountPaid,
    this.onPaymentFinished,
  }) : super(key: key);

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

  void checkConnectivity() async {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      handleConnectivityChange(result);
    });
  }

  void handleConnectivityChange(List<ConnectivityResult> result) {
    if (result == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
      });
      showErrorToast(ChapaStrings.connectionError);
      exitPaymentPage(ChapaStrings.connectionError);
    } else if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn)) {
      setState(() {
        isOffline = false;
      });
    } else if (result.contains(ConnectivityResult.bluetooth)) {
      setState(() {
        isOffline = false;
      });
      exitPaymentPage(ChapaStrings.connectionError);
    }
  }

  /// Exits the payment page and triggers navigation or the callback.
  ///
  /// If [fallBackNamedUrl] is empty, the [onPaymentFinished] callback is called
  /// with the payment message, transaction reference, and amount paid.
  /// Otherwise, navigates to the fallback route.
  ///
  /// [message]: The message describing the payment status.
  exitPaymentPage(String message) {
    if (!mounted) return;
    if (widget.fallBackNamedUrl.isEmpty) {
      widget.onPaymentFinished!(
        message,
        widget.transactionReference,
        widget.amountPaid,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        widget.fallBackNamedUrl,
        (Route<dynamic> route) => false,
        arguments: {
          'message': message,
          'transactionReference': widget.transactionReference,
          'paidAmount': widget.amountPaid
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    connection!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: MaterialApp(
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
      ),
    );
  }
}
