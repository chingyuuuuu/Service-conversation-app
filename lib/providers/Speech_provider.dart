import 'package:flutter/material.dart';
import 'package:jkmapp/services/QA/Speech_service.dart';

class SpeechProvider with ChangeNotifier {
  bool _isRecording = false;
  String _recognizedText = '按住錄音'; // 用於顯示提示的文字

  bool get isRecording => _isRecording;
  String get recognizedText => _recognizedText;

  //初始化錄音功能
  void initializeSpeech() {
    try {
      SpeechService.initialize();
      print('Speech recognition initialized.');
    } catch (e) {
      print('Error initializing SpeechRecognition: $e');
    }
  }
  //開始錄音
  Future<void> startRecording(
      BuildContext context,
      TextEditingController controller,
      Function sendMessage,
      ) async {
    _isRecording = true;
    _recognizedText = '錄音中...';
    notifyListeners(); // 通知 UI 更新
    //顯示對話框
    try {
      showDialog(
        context: context,
        barrierDismissible: false, // 禁止外框之後關閉
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _recognizedText,//即時更新錄音內容
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Icon(Icons.mic, size: 50, color: Colors.red), // 麦克风图标
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => stopRecording(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('停止錄音'),
                ),
              ],
            ),
          );
        },
      );
      //用於調用錄音功能並即時去更新語音識別，動態的顯示錄音的結果
      await SpeechService.startListening(
        onResult: (realTimeText) {//傳回結果
          _recognizedText = realTimeText ?? '聽取中...';
          print('Real-time recognition: $_recognizedText');
          notifyListeners(); // 更新 UI
        },
      ).then((finalText) async{
        _recognizedText = finalText ?? '';
        print('Final recognition: $_recognizedText');
        notifyListeners(); //更新
        await Future.delayed(const Duration(seconds: 10), () {
          controller.text = _recognizedText; // 將最終結果填入輸入框中
          sendMessage(); // 自動發送訊息
          stopRecording(context); // 停止錄音並關閉對話框
        });
      });
    } catch (e) {
      _recognizedText = '語音識別失敗: $e';
      notifyListeners();
    }
  }

  void stopRecording(BuildContext context) {
    _isRecording = false;
    _recognizedText = '';
    SpeechService.stopListening();
    notifyListeners();
    Navigator.pop(context); // 关闭对话框
  }
}
