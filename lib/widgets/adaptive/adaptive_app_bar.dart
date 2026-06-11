import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget adaptiveAppBar({
  required String title,
  List<Widget>? actions,
  Widget? leading,
  double leadingWidth = 56,
}) {
  if (Platform.isIOS) {
    Widget? trailing;
    if (actions != null && actions.isNotEmpty) {
      trailing = actions.length == 1
          ? actions.first
          : Row(mainAxisSize: MainAxisSize.min, children: actions);
    }
    return CupertinoNavigationBar(
      middle: Text(title),
      leading: leading,
      trailing: trailing,
      backgroundColor: const Color(0xFFF5F5F7),
      border: null,
    );
  }
  return AppBar(
    backgroundColor: const Color(0xFFF5F5F7),
    elevation: 0,
    title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
    actions: actions,
    leading: leading,
    leadingWidth: leadingWidth,
  );
}
