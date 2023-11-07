import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ErrorText extends StatelessWidget {
  final String error;
  const ErrorText({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return error.text.white.make().centered();
  }
}
