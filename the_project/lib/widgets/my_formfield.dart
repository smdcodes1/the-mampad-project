import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  MyFormField(
      {super.key,
      required this.validator,
      required this.editingcontroller,
      required this.leadingicon,
      required this.hinttext,
      required this.labeltext,
      required this.obscuretext,
      this.keyboardType,
      this.maxLength});
  final FormFieldValidator<String>? validator;
  final TextEditingController editingcontroller;
  final Icon leadingicon;
  final String hinttext;
  final bool obscuretext;
  final String labeltext;
  final TextInputType? keyboardType;
  int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: editingcontroller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: labeltext,
        hintText: hinttext,
        prefixIcon: leadingicon,
        labelStyle: TextStyle(fontFamily: 'Poppins'),
        hintStyle: TextStyle(fontFamily: 'Poppins'),
        fillColor: Colors.white,
        filled: true,
      ),
      style: TextStyle(
        fontSize: 15,
        fontFamily: 'Poppins',
      ),
      obscureText: obscuretext,
      keyboardType: keyboardType,
      maxLength: maxLength,
    );
  }
}
