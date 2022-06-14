import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final GestureTapCallback? onTap;

  const Label({
    required this.text,
    required this.color,
    this.size = 14,
    this.weight = FontWeight.normal,
    this.align,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        maxLines: maxLines,
        textAlign: align,
        overflow: overflow,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: weight,
          decoration: decoration,
        ),
      ),
    );
  }
}
