import 'package:flutter/material.dart';
import 'package:jkmapp/utils/diolog.dart';
import 'package:jkmapp/routers/app_routes.dart';


class  Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  _CustomerState createState() =>_CustomerState();
}

class _CustomerState extends State<Customer> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(_controller.text);
        _controller.clear();
      });
    }
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
               onPressed: () {
                 showPasswordDialog(context, passwordController, () { // 傳遞回調函數
                   Navigator.pushNamed(
                       context, Routers.customer_data); // 密碼正確後導航到 dining
                 });
               },
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
