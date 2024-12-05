import 'package:flutter/material.dart';
import 'package:jkmapp/providers/QA/QA_provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/QA/Speech_provider.dart';

//客服系統

class RestaurantQASystem extends StatefulWidget {
  const RestaurantQASystem({super.key});

  @override
  RestaurantQASystemState createState() => RestaurantQASystemState();
}

class RestaurantQASystemState extends State<RestaurantQASystem> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final speechProvider = Provider.of<SpeechProvider>(context, listen: false);
    speechProvider.initializeSpeech();
  }

  void _sendMessage() {
    //輸入問題
    if (_controller.text.isNotEmpty) { //要記得設置listen:false
      final qaProvider = Provider.of<QAprovider>(context, listen: false); // 將 listen 設為 false
      String userQuestion = _controller.text; //獲取問題
      qaProvider.sendMessage(userQuestion); //傳送問題
      _controller.clear(); //清空
    }
  }


  @override
  Widget build(BuildContext context) {
    final qaProvider = Provider.of<QAprovider>(context); // 管理问答
    final speechProvider = Provider.of<SpeechProvider>(context); // 管理录音状态
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar
          SliverAppBar(
            title: const Text(
              '歡迎使用客服系統',
              style: TextStyle(fontFamily: 'Cursive', fontSize: 30),
            ),
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
              ),
            ),
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // 聊天訊息
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: qaProvider.messages.length,
                itemBuilder: (context, index) {
                  final message = qaProvider.messages[index];
                  bool isUser = message['sender'] == "user";
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: isUser //bot or client
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Colors.black12
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['text'] ?? '',
                          style: TextStyle(
                            color: isUser ? Colors.black : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // 關鍵字任務
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(//當輸入keyword會傳送"點餐"給後端,調用task/api去處理
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () =>{
                          _controller.text = '點餐',
                          _sendMessage(),
                    },
                    child: Text('點餐', style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () =>{
                    _controller.text = '訂單狀態',
                    _sendMessage(),
                    },
                   child: Text('訂單狀態', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
          //輸入/語音
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '請輸入你的問題',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF223888)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF223888)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF223888)),
                    onPressed: () => _sendMessage(),
                  ),
                  GestureDetector(
                    onTap: () => speechProvider.startRecording(context, _controller, () => _sendMessage()),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.mic,
                        color: speechProvider.isRecording
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}