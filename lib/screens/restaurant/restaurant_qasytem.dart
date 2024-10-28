import 'package:flutter/material.dart';
import 'package:jkmapp/routers/app_routes.dart';
import 'package:jkmapp/providers/QA_provider.dart';
import 'package:provider/provider.dart';

/*
1.讓用戶至少輸入10筆資料才可以使用這個系統
3.add未回答問題的router(不在資料庫中)-目的為了讓user可以看那些資料不在database
進而去新增這些資料到database中
4.處理基本問答
 */

class RestaurantQASystem extends StatefulWidget {
  const RestaurantQASystem({super.key});

  @override
  RestaurantQASystemState createState() => RestaurantQASystemState();
}

class RestaurantQASystemState extends State<RestaurantQASystem> {
  final TextEditingController _controller = TextEditingController();
  void _sendMessage() {
    //輸入問題
    if (_controller.text.isNotEmpty) {//要記得設置listen:false
      final qaProvider = Provider.of<QAprovider>(context, listen: false);  // 將 listen 設為 false
      String userQuestion = _controller.text;//獲取問題
      qaProvider.sendMessage(userQuestion);//傳送問題
      _controller.clear();//清空
    }
  }

  @override
  Widget build(BuildContext context) {
    final qaProvider = Provider.of<QAprovider>(context);  // 將 listen 設為 false
    return Scaffold(
      body:CustomScrollView(
          slivers: [
            SliverAppBar(
            title: const Text('歡迎使用客服系統',
            style: TextStyle(fontFamily: 'Cursive', fontSize: 30)),
            backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
              background: Container(
              color:Colors.white,
              ),
            ),
           floating:true,
            pinned:true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, Routers.Client);
          },
        ),
      ),
    SliverToBoxAdapter(
    child: Column(
        children: [
         SizedBox(
           height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              itemCount: qaProvider.messages.length,
              itemBuilder: (context, index) {//提供index從0開始遞增，取得第幾條訊息
                final message = qaProvider.messages[index]; // 每個訊息都是一個map，包含sender和text
                bool isUser = message['sender'] == "user"; // 檢查訊息是否來自客人
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.black12: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: TextStyle(
                            color: isUser ? Colors.black : Colors.black),
                      ),
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
                      border: OutlineInputBorder(
                         borderSide:BorderSide(color:Color(0xFF223888)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:BorderSide(color:Color(0xFF223888)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF223888)),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    ],
    ),
    );
  }
}