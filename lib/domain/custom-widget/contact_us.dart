import 'package:flutter/material.dart';

/// A StatelessWidget that displays an error icon, a message, and a prompt
/// for the user to contact support when something goes wrong in the app.
///
/// It is typically used when a critical error occurs and the user needs guidance

class ContactUs extends StatelessWidget {
  ///Constructor for [ContactUs]
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: deviceSize.width * 0.2,
            color: Colors.red,
          ),
          SizedBox(
            height: deviceSize.height * 0.02,
          ),
          Text(
            "Oops",
            style: TextStyle(
                fontSize: deviceSize.width * 0.054,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: deviceSize.width * 0.04,
                right: deviceSize.width * 0.04,
                top: 8),
            child: Text(
              "Something went wrong Please contact us \n Thank you!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: deviceSize.width * 0.032,
                wordSpacing: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
