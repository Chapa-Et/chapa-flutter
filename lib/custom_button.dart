import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  Function onPressed;
  Color? backgroundColor;
  String title;

  CustomButton(
      {super.key,
      required this.onPressed,
      this.backgroundColor,
      required this.title});

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
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
