import 'package:flutter/material.dart';
import 'customer_data.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  // 顯示輸入密碼的彈窗
  void _showPasswordDialog() {
    String enteredPassword = '';
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('輸入後台密碼', style: TextStyle(color: Colors.red)),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'password',
            ),
            onChanged: (value) {
              enteredPassword = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 關閉彈窗
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                if (enteredPassword == '123') {
                  Navigator.of(context).pop(); // 密碼正確，關閉彈窗
                  _navigateToNextScreen(); // 跳轉到新畫面
                } else {
                  // 密碼錯誤，提示錯誤訊息
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('密碼錯誤'),
                    ),
                  );
                }
              },
              child: const Text('輸入'),
            ),
          ],
        );
      },
    );
  }

  // 密碼正確後跳轉到新的畫面
  void _navigateToNextScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ServiceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service', style: TextStyle(fontFamily: 'Cursive', fontSize: 30)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: _showPasswordDialog, // 點擊齒輪按鈕時顯示密碼輸入視窗
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(messages[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '請輸入你的問題',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.grey),
                  onPressed: () {
                    // 語音輸入操作
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
