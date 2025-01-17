import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onChanged;
  final bool isPassword;
  final bool isEmail;
  final bool isDigitsOnly;
  final Color textColorReceived;
  final Color hintColorReceived;
  final Color fillColorReceived;
  final Color borderColorReceived;
  final int maxLinesReceived;
  final int maxLengthReceived;
  final double borderRadiusReceived;
  final int minLinesReceived;
  final TextEditingController controller;
  final bool isFullCapsNeeded;

  CommonTextFormField(
      {this.hintText,
      this.validator,
      this.onChanged,
      this.isPassword = false,
      this.isEmail = false,
      this.isDigitsOnly = false,
      this.textColorReceived,
      this.hintColorReceived,
      this.fillColorReceived,
      this.borderColorReceived,
      this.maxLinesReceived = 1,
      this.maxLengthReceived,
      this.borderRadiusReceived = 10.0,
      this.minLinesReceived = 1,
      this.controller,
      this.isFullCapsNeeded = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword ? true : false,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : (isDigitsOnly ? TextInputType.number : TextInputType.text),
      maxLines: maxLinesReceived,
      maxLength: maxLengthReceived,
      minLines: minLinesReceived,
      textCapitalization: isPassword
          ? TextCapitalization.none
          : (isFullCapsNeeded
          ? TextCapitalization.characters
          : TextCapitalization.sentences),
      style: TextStyle(
          fontSize: 13.0,
          height: 1.8,
          color: textColorReceived,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        fillColor: fillColorReceived,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 11.0,
            color: hintColorReceived,
            fontWeight: FontWeight.normal),
        counterText: "",
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 12, 10.0, 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(color: borderColorReceived, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(color: borderColorReceived, width: 1.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(color: borderColorReceived, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(color: borderColorReceived, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(color: borderColorReceived, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusReceived),
          borderSide: BorderSide(color: borderColorReceived, width: 1.0),
        ),
      ),
    );
  }
}
