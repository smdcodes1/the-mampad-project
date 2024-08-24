import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({super.key, required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Color(0xFFFF151E3D),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide.none)),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white, 
              fontFamily: 'Poppins',),
          )),
    );
  }
}
