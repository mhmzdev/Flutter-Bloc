import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final Function onPressed;
  const CustomButton(
      {Key key,
      this.height = 40.0,
      this.width = 220.0,
      this.child,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
