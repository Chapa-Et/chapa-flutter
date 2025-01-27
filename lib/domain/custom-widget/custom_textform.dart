import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
/// A customizable text input field that supports various properties for
/// flexibility. This widget is designed for forms and provides features
/// such as custom borders, password visibility toggle, input validation,
/// and more.
// ignore: must_be_immutable
class CustomTextForm extends StatefulWidget {
  /// Constructor
  CustomTextForm(
      {super.key,
      required this.controller,
      this.enableBorder = true,
      this.hintText = "",
      this.labelText = "",
      this.cursorColor = Colors.green,
      this.filled = false,
      this.filledColor = Colors.transparent,
      this.hintTextStyle = const TextStyle(color: Colors.black),
      this.obscuringCharacter = "*",
      this.readOnly = false,
      this.obscureText = false,
      this.labelTextStyle = const TextStyle(color: Colors.black),
      this.prefix,
      this.suffix,
      this.textStyle,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onTap,
      this.onChanged,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.inputFormatter,
      this.maxLine = 2,
      this.minLine = 1});

  /// TextEditingController to manage the text field's content. It is used to read or modify the text inside the field.
  final TextEditingController controller;

  /// The type of input (e.g., text, number, email).
  ///
  /// Default is [TextInputType.text].
  TextInputType keyboardType;

  /// The action to be taken when the user submits the text.
  ///
  /// This controls the behavior of the keyboard when the user presses the "Done" button or similar.
  /// Default is [TextInputAction.done].
  TextInputAction textInputAction;

  /// Whether to enable borders for the text field.
  ///
  /// If set to true, the text field will display borders around it.
  /// Default is true.
  final bool enableBorder;

  /// Whether the text field should have a background color.
  ///
  /// If set to true, the field will be filled with the color specified in [filledColor].
  /// Default is false.
  final bool filled;

  /// Whether the text field is read-only.
  ///
  /// If set to true, the field will not allow the user to edit the text.
  /// Default is false.
  final bool readOnly;

  /// Whether to obscure the text (e.g., for password fields).
  ///
  /// If set to true, the text will be hidden and a password visibility icon will be shown.
  /// Default is false.
  final bool obscureText;

  /// The validation mode for the field.
  ///
  /// Defines when the input validation occurs. Default is [AutovalidateMode.onUserInteraction].
  final AutovalidateMode? autovalidateMode;

  /// The hint text displayed when the field is empty.
  ///
  /// This provides a description of the field's expected input.
  /// Default is an empty string.
  final String hintText;

  /// The label text displayed above the field.
  ///
  /// This provides a description for the field when it is focused.
  /// Default is an empty string.
  final String labelText;

  /// The character used for obscuring text (e.g., "*" for password fields).
  ///
  /// Default is "*".

  final String obscuringCharacter;

  /// The style of the hint text.
  ///
  /// This defines the font style, color, etc., for the hint text. Default is black text.
  final TextStyle? hintTextStyle;

  /// The style of the label text.
  ///
  /// This defines the font style, color, etc., for the label text. Default is black text.
  final TextStyle labelTextStyle;

  /// The style of the text input itself.
  ///
  /// This controls the appearance of the text entered by the user.
  final TextStyle? textStyle;

  /// The background color of the text field when [filled] is true.
  ///
  /// Default is [Colors.transparent].
  final Color filledColor;

  /// The cursor color inside the text field.
  ///
  /// This changes the color of the cursor when the user is typing.
  /// Default is green
  final Color cursorColor;

  /// A custom widget to be displayed as a suffix icon.
  ///
  /// If not provided, the widget will display a visibility toggle for password fields.

  final Widget? suffix;

  /// A custom widget to be displayed as a prefix icon.

  final Widget? prefix;

  /// A callback function triggered when the text field is tapped.
  final Function? onTap;

  /// A function that validates the text input.
  final String? Function(String?)? validator;

  /// A function triggered when the user submits the text input.
  Function(String)? onFieldSubmitted;

  /// A function triggered whenever the text in the field changes.
  Function(String)? onChanged;

  /// A list of input formatters to restrict or modify the input.
  ///
  /// This allows customizing the input, such as restricting to certain characters.

  List<TextInputFormatter>? inputFormatter;

  /// The maximum number of lines the text field can have.
  ///
  final int maxLine;

  /// The minimum number of lines the text field can have.
  ///
  /// This is useful for multi-line text inputs and can ensure the field is not too small.
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
        labelText: widget.labelText,
        labelStyle: widget.labelTextStyle,
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
