import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldWidgetType1 extends StatefulWidget {
  String hintText;
  bool isEmail;
  bool isPassword;
  bool isPhone;

  String? Function(String?)? validator;

  String? Function(String?)? onChanged;

  TextFieldWidgetType1(
      {Key? key,
      required this.hintText,
      required this.validator,
      required this.onChanged,
      this.isEmail = false,
      this.isPassword = false,
      this.isPhone = false})
      : super(key: key);

  @override
  State<TextFieldWidgetType1> createState() => _TextFieldWidgetType1State();
}

class _TextFieldWidgetType1State extends State<TextFieldWidgetType1> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        validator: widget.validator,
        onChanged: widget.onChanged,
        keyboardType: widget.isEmail
            ? TextInputType.emailAddress
            : widget.isPhone
                ? TextInputType.phone
                : TextInputType.text,
        obscureText: widget.isPassword
            ? obscure
                ? true
                : false
            : false,
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.grey.withOpacity(.34),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    icon: obscure
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility))
                : null,
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
