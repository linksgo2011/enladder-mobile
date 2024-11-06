import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 点击蒙层不关闭
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // 背景透明
          elevation: 0,
          content: Center(
            child: CircularProgressIndicator(), // 居中加载指示器
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop(); // 关闭加载对话框
  }
}
