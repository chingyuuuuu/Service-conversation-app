import 'package:flutter/material.dart';
import 'dart:convert'; //用於解析json數據
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/services/user/AuthenticationService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ForgetProvider with ChangeNotifier{
      final TextEditingController emailController = TextEditingController();
      final TextEditingController verifyController = TextEditingController();
      bool isSubmitting = false;
      bool isSending = false;
      String message = '';
      String? email;

      //加載email
      Future<void>loadEmail() async {
        final prefs = await SharedPreferences.getInstance();
        email = prefs.getString('user_email');
        notifyListeners();
      }

      //發送code到後端驗證
      Future<bool>verifyCode(BuildContext context, VoidCallback onSuccess) async {
        final String code = verifyController.text;

        if (code.isEmpty || email == null) {
          message = '需要輸入驗證碼和有效的 email';
          notifyListeners();
          return false;
        }

        isSubmitting = true;
        message = '';
        notifyListeners();

        try {
          final response = await http.post(
            Uri.parse('http://127.0.0.1:5000/verify'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'code': code}),
          );

          isSubmitting = false;
          if (response.statusCode == 200) {
            message = '驗證成功!';
            notifyListeners();
            onSuccess();
            return true;
          } else {
            final responseData = jsonDecode(response.body);
            message = '${responseData['message']}';
            notifyListeners();
            return false;
          }
        } catch (e) {
          isSubmitting = false;
          message = '驗證失敗，請稍後再試。';
          notifyListeners();
          return false;
        }
      }

      /// 保存 Email
      Future<void> storeEmail(String email) async {
        await StorageHelper.saveEmail(email);
      }

      //發送重置密碼code
      Future<bool> sendResetCode(BuildContext context, Function onSuccess) async {
        final email = emailController.text;

        if (email.isEmpty) {
          message = 'Email is required';
          notifyListeners();
          return false;
        }

        isSending = true;
        message = '';
        notifyListeners();

        final response = await AuthenticationService.sendResetCode(email);

        isSending = false;
        if (response.statusCode == 200) {
          message = 'Reset code sent successfully!';
          await storeEmail(email);
          notifyListeners();

          // 调用成功的回调函数
          onSuccess();
          return true;
        } else {
          final responseData = jsonDecode(response.body);
          message = 'Failed to send reset code: ${responseData['message']}';
          notifyListeners();
          return false;
        }
      }

      //清除狀態
      void reset() {
        emailController.clear();
        verifyController.clear();
        isSending = false;
        isSubmitting = false;
        message = '';
        email = null;
        notifyListeners();
      }


}