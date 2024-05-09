import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  Function onPressed;
  Color? backgroundColor;

  CustomButton({super.key, required this.onPressed, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      width: deviceSize.width,
      height: deviceSize.height * 0.048,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
          backgroundColor ?? Theme.of(context).primaryColor,
        )),
        onPressed: () {
          onPressed();
        },
        child: Text(
          "Pay",
        ),
      ),
    );
  }
}
