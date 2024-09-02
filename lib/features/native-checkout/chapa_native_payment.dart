import 'dart:async';
import 'dart:ui';
import 'package:chapasdk/constants/enums.dart';
import 'package:chapasdk/constants/extentions.dart';
import 'package:chapasdk/constants/requests.dart';
import 'package:chapasdk/custom_button.dart';
import 'package:chapasdk/data/model/request/direct_charge_request.dart';
import 'package:chapasdk/data/services/payment_service.dart';
import 'package:chapasdk/domain/custom-widget/custom_textform.dart';
import 'package:chapasdk/features/native-checkout/bloc/chapa_native_checkout_bloc.dart';
import 'package:chapasdk/features/network/bloc/network_bloc.dart';
import 'package:flutter/material.dart';

class ChapaNativePayment extends StatefulWidget {
  final BuildContext context;
  final String publicKey;
  final String email;
  final String phone;
  final String amount;
  final String currency;
  final String firstName;
  final String lastName;
  final String txRef;
  final String title;
  final String desc;
  final String namedRouteFallBack;
  final bool defaultCheckout;
  final String encryptionKey;

  const ChapaNativePayment(
      {super.key,
      required this.context,
      required this.publicKey,
      required this.email,
      required this.phone,
      required this.amount,
      required this.firstName,
      required this.lastName,
      required this.txRef,
      required this.title,
      required this.desc,
      required this.namedRouteFallBack,
      required this.currency,
      this.defaultCheckout = false,
      required this.encryptionKey});

  @override
  State<ChapaNativePayment> createState() => _ChapaNativePaymentState();
}

class _ChapaNativePaymentState extends State<ChapaNativePayment> {
  PaymentService paymentService = PaymentService();
  LocalPaymentMethods selectedLocalPaymentMethods =
      LocalPaymentMethods.telebirr;

  late ChapaNativeCheckoutBloc _chapaNativeCheckoutBloc;
  late NetworkBloc _networkBloc;
  bool _isDialogShowing = false;
  int _start = 300;
  int _currentSeconds = 300;
  Timer? _timer;
  @override
  void initState() {
    _chapaNativeCheckoutBloc =
        ChapaNativeCheckoutBloc(paymentService: PaymentService());
    _networkBloc = NetworkBloc();
    super.initState();
  }

  @override
  void dispose() {
    _chapaNativeCheckoutBloc.close();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_currentSeconds < 5) {
            timer.cancel();
          } else {
            _currentSeconds = _start - timer.tick;
          }
        });
      },
    );
  }

  String get timerText {
    Duration duration = Duration(seconds: _currentSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<void> showCustomDialog() async {
    if (!_isDialogShowing) {
      setState(() {
        _isDialogShowing = true;
        _currentSeconds = _start;
      });
      startTimer();
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Processing Payment',
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Please wait while we process your payment.',
                    ),
                    CountDownTimer(
                      duration: Duration(seconds: _currentSeconds),
                      onFinish: () {
                        Navigator.pop(context); // Close dialog when timer ends
                      },
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      title: "Return",
                    )
                  ],
                ),
              ),
            );
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    TextEditingController phoneNumberController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Chapa Checkout",
          style: TextStyle(),
        ),
      ),
      body: StreamBuilder<ChapaNativeCheckoutState>(
          stream: _chapaNativeCheckoutBloc.stream,
          initialData: ChapaNativeCheckoutInitial(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final state = snapshot.data;
              if (state is ChapaNativeCheckoutInitial ||
                  state is ChapaNativeCheckoutValidationOngoingState) {
                if (state is ChapaNativeCheckoutValidationOngoingState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showCustomDialog();
                  });
                }
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: deviceSize.width * 0.04),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: state is ChapaNativeCheckoutValidationOngoingState
                          ? 5.0
                          : 0,
                      sigmaY: state is ChapaNativeCheckoutValidationOngoingState
                          ? 5.0
                          : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Payment Methods",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        DropdownButtonFormField(
                            value: selectedLocalPaymentMethods,
                            items: LocalPaymentMethods.values
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.displayName()),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  selectedLocalPaymentMethods = val;
                                });
                              }
                            }),
                        SizedBox(
                          height: deviceSize.height * 0.04,
                        ),
                        Text(
                          "Phone number",
                          style: TextStyle(),
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.02,
                        ),
                        CustomTextForm(
                          controller: phoneNumberController,
                          hintText: "964------",
                          hintTextStyle: TextStyle(color: Colors.grey),
                          lableText: "",
                          filled: false,
                          filledColor: Colors.transparent,
                          obscureText: false,
                          onTap: () {},
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Phone number can not be empty";
                            }
                            return null;
                          },
                          onChanged: (val) {},
                        ),
                        TextButton(
                          onPressed: () {
                            intilizeMyPayment(
                              widget.context,
                              widget.publicKey,
                              widget.email,
                              widget.phone,
                              widget.amount,
                              widget.currency,
                              widget.firstName,
                              widget.lastName,
                              widget.txRef,
                              widget.title,
                              widget.desc,
                              widget.namedRouteFallBack,
                            );
                          },
                          child: Text(
                            "Pay with webview",
                            style: TextStyle(),
                          ),
                        ),
                        Spacer(),
                        CustomButton(
                          title: "Pay",
                          onPressed: () async {
                            DirectChargeRequest request = DirectChargeRequest(
                                amount: widget.amount,
                                mobile: phoneNumberController.text,
                                currency: widget.currency,
                                firstName: widget.firstName,
                                lastName: widget.lastName,
                                email: widget.email,
                                txRef: widget.txRef);
                            _chapaNativeCheckoutBloc.add(InitiatePayment(
                                directChargeRequest: request,
                                publicKey: widget.publicKey,
                                selectedLocalPaymentMethods:
                                    selectedLocalPaymentMethods));
                          },
                        ),
                        SizedBox(
                          height: deviceSize.height * 0.04,
                        )
                      ],
                    ),
                  ),
                );
              } else if (state
                  is ChapaNativeCheckoutPaymentInitateSuccessState) {
                return const Center(
                  child: Text(
                    "Success State here",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                );
              } else if (state is ChapaNativeCheckoutLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ChapaNativeCheckoutApiError) {
                setState(() {
                  _isDialogShowing = true;
                });
                return Center(
                  child: Text(state.apiErrorResponse.message ?? ""),
                );
              } else {
                return Container(
                  child: Text(
                    "Something went wrong please contact us",
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class CountDownTimer extends StatefulWidget {
  final Duration duration;
  final Function onFinish;

  const CountDownTimer({
    Key? key,
    required this.duration,
    required this.onFinish,
  }) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  late Duration _currentTime;

  @override
  void initState() {
    _currentTime = widget.duration;
    startTimer();
    super.initState();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentTime.inSeconds <= 0) {
          timer.cancel();
          widget.onFinish();
        } else {
          _currentTime = _currentTime -
              Duration(
                seconds: 1,
              );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(_currentTime.inMinutes.remainder(60));
    String seconds = twoDigits(_currentTime.inSeconds.remainder(60));
    return Text(
      '$minutes:$seconds',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
