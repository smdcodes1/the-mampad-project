import 'package:flutter/material.dart';

class BloodRadioTileWidget extends StatelessWidget {
  BloodRadioTileWidget(
      {super.key,
      required this.value,
      required this.id,
      required this.onChanged,
      required this.title,
      required this.color,
      this.subtitle});

  final int value;
  final int? id;
  final ValueChanged<int?> onChanged;
  final Widget title;
  final Widget? subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 160,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(9)),
      child: Center(
        child: RadioListTile(
          value: value,
          groupValue: id,
          onChanged: onChanged,
          title: title,
          subtitle: subtitle,
          activeColor: color,
        ),
      ),
    );
  }
}
