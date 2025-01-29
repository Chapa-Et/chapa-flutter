import 'package:flutter/material.dart';

///
class NoConnection extends StatelessWidget {
  ///
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_outlined,
                size: deviceSize.width * 0.16,
                color: Colors.red,
              ),
              SizedBox(
                height: deviceSize.height * 0.02,
              ),
              Text(
                "Opps",
                style: TextStyle(
                    fontSize: deviceSize.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: deviceSize.width * 0.04,
                    right: deviceSize.width * 0.04,
                    top: 8),
                child: Text(
                  "There is no Internet Connection \n Please check your Internet Connection and Try it again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    fontSize: deviceSize.width * 0.024,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
