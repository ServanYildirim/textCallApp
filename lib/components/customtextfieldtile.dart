import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_rtc_template/constants/vars.dart';

class CustomTextFieldTile extends StatelessWidget {

  final TextEditingController textCtrl;
  final IconData icon;
  final String label;
  //final String hint;
  final FormFieldValidator<String> validatorFunc;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  final bool isPassword;
  final bool isPhone;

  const CustomTextFieldTile({
    Key? key,
    required this.textCtrl,
    required this.icon,
    //required this.hint,
    required this.label,
    required this.validatorFunc,
    required this.textCapitalization,
    required this.textInputType,
    this.isPassword = false,
    this.isPhone = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        controller: textCtrl,
        textCapitalization: textCapitalization,
        keyboardType: textInputType,
        decoration: InputDecoration(
          //icon: Icon(icon),
          //hintText: hint,
          //prefixText: isPhone ? "+90" : null,
          prefixIcon: Icon(icon),
          //suffixIcon: Icon(icon),
          labelText: label,
          //labelStyle: TextStyle(color: value ? ConstVars().activeColor : null),
        ),
        validator: validatorFunc,
        obscureText: isPassword,
        inputFormatters: isPhone ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)] : null,
      ),
    );
  }
}