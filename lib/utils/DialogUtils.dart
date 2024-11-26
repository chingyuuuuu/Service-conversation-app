import 'package:flutter/material.dart';

class DialogUtils {
  static void showDialogWithMessage({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "確定",
    VoidCallback? onConfirm, // 確定按鈕回調
    String? cancelText,
    VoidCallback? onCancel, // 可選的取消按鈕回調
  }) {
    showDialog( //顯示對話框
      context: context,
      builder: (context) => AlertDialog(backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text( // 顯示 message
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (cancelText != null)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 關閉對話框
                if (onCancel != null) onCancel(); // 調用取消回調
              },
              child: Text(cancelText),
            ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // 關閉對話框
              if (onConfirm != null) onConfirm(); // 調用確認回調
            },
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.red), // 默認紅色文字
            ),
          ),
        ],
      ),
    );
  }
}
