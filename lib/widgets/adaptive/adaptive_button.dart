import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget adaptiveTextButton({
  required String text,
  required VoidCallback onPressed,
  Color color = Colors.blue,
}) {
  if (Platform.isIOS) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: color)),
    );
  }
  return TextButton(
    onPressed: onPressed,
    child: Text(text, style: TextStyle(color: color)),
  );
}
