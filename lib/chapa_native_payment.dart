import 'package:chapasdk/constants/enums.dart';
import 'package:chapasdk/constants/extentions.dart';
import 'package:chapasdk/constants/requests.dart';
import 'package:chapasdk/custom_button.dart';
import 'package:chapasdk/data/model/network_response.dart';
import 'package:chapasdk/data/model/request/direct_charge_request.dart';
import 'package:chapasdk/data/services/payment_service.dart';
import 'package:chapasdk/domain/custom-widget/custom_textform.dart';
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

  const ChapaNativePayment({
    super.key,
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
  });

  @override
  State<ChapaNativePayment> createState() => _ChapaNativePaymentState();
}

class _ChapaNativePaymentState extends State<ChapaNativePayment> {
  PaymentService paymentService = PaymentService();
  LocalPaymentMethods selectedLocalPaymentMethods =
      LocalPaymentMethods.telebirr;
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    TextEditingController phoneNumberController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chapa Checkout",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: deviceSize.height * .02,
          horizontal: deviceSize.width * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Payment Options",
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
            ),
            SizedBox(
              height: deviceSize.height * 0.02,
            ),
            CustomTextForm(
              controller: phoneNumberController,
              hintText: "964001822",
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
              child: Text("Pay with webview"),
            ),
            Spacer(),
            CustomButton(
              onPressed: () async {
                DirectChargeRequest request = DirectChargeRequest(
                    amount: widget.amount,
                    mobile: phoneNumberController.text,
                    currency: widget.currency,
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    txRef: widget.txRef);
                NetworkResponse networkResponse =
                    await paymentService.initializeDirectPayment(
                        request: request,
                        publicKey: widget.publicKey,
                        localPaymentMethods: selectedLocalPaymentMethods);
              },
            ),
          ],
        ),
      ),
    );
  }
}
