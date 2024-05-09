import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomTextForm extends StatefulWidget {
  CustomTextForm(
      {Key? key,
      required this.controller,
      this.enableBorder = true,
      this.hintText = "",
      this.lableText = "",
      this.cursorColor = Colors.green,
      this.filled = false,
      this.filledColor = Colors.transparent,
      this.hintTextStyle = const TextStyle(color: Colors.black),
      this.obscuringCharacter = "*",
      this.readOnly = false,
      this.obscureText = false,
      this.lableTextStyle = const TextStyle(color: Colors.black),
      this.prefix,
      this.suffix,
      this.textStyle = const TextStyle(color: Colors.black),
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onTap,
      this.onChanged,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.inputFormatter,
      this.maxLine = 2,
      this.minLine = 1})
      : super(key: key);
  final TextEditingController controller;
  TextInputType keyboardType;
  TextInputAction textInputAction;

  final bool enableBorder;
  final bool filled;
  final bool readOnly;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;

  final String hintText;
  final String lableText;
  final String obscuringCharacter;

  final TextStyle hintTextStyle;
  final TextStyle lableTextStyle;
  final TextStyle textStyle;

  final Color filledColor;
  final Color cursorColor;

  final Widget? suffix;
  final Widget? prefix;

  final Function? onTap;
  final String? Function(String?)? validator;
  Function(String)? onFieldSubmitted;
  Function(String)? onChanged;
  List<TextInputFormatter>? inputFormatter;
  final int maxLine;
  final int minLine;

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  bool makePasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return TextFormField(
      style: widget.textStyle,
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: widget.filled,
        fillColor: widget.filledColor,
        hintText: widget.hintText,
        hintStyle: widget.hintTextStyle,
        labelText: widget.lableText,
        labelStyle: widget.lableTextStyle,
        isDense: true,
        prefixIcon: widget.prefix,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: widget.enableBorder
              ? const BorderSide(
                  width: 0.5,
                  color: Colors.red,
                )
              : BorderSide.none,
          borderRadius: BorderRadius.circular(11),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: widget.enableBorder
              ? const BorderSide(width: 0.5, color: Colors.red)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(11),
        ),
        prefixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: widget.enableBorder
              ? BorderSide(
                  width: 0.1,
                  color: Theme.of(context).textTheme.bodyMedium!.color!)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(11),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: widget.enableBorder
              ? BorderSide(width: 0.5, color: Theme.of(context).primaryColor)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(11),
        ),
        suffixIcon: widget.suffix ?? _getSuffixWidget(),
      ),
      onFieldSubmitted: (data) {
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(data);
          FocusScope.of(context).unfocus();
        } else {
          // FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      textInputAction: widget.textInputAction,
      validator: (value) => widget.validator!(value),
      obscureText: widget.obscureText ? makePasswordVisible : false,
      obscuringCharacter: widget.obscuringCharacter,
      onTap: () => widget.onTap,
      readOnly: widget.readOnly,
      onChanged: (value) => widget.onChanged,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatter,
      autovalidateMode: widget.autovalidateMode,
      scrollPadding: EdgeInsets.symmetric(
        vertical: deviceSize.height * 0.2,
      ),
    );
  }

  Widget _getSuffixWidget() {
    if (widget.obscureText) {
      return TextButton(
        onPressed: () {
          setState(() {
            makePasswordVisible = !makePasswordVisible;
          });
        },
        child: Icon(
          (!makePasswordVisible) ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).primaryColor,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
