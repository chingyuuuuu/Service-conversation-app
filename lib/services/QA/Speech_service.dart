import 'dart:html' as html;

//語音服務
class SpeechService {
  static html.SpeechRecognition? _speechRecognition;
  static bool _isListening = false;

  static void initialize() {
    print('Initializing Speech Recognition...');
    _speechRecognition = html.SpeechRecognition();
    _speechRecognition!.lang = 'zh-TW';
    _speechRecognition!.continuous = true;//繼續進行語音時別
    _speechRecognition!.interimResults = true;//獲取實際結果

    _speechRecognition!.onError.listen((event) {
      print('SpeechRecognition Error: ${event.error}');
    });

    _speechRecognition!.onEnd.listen((_) {
      print('SpeechRecognition Ended');
      _isListening = false;
    });
    print('Speech Recognition initialized successfully.');
  }

  static Future<String?> startListening({
    required Function(String?) onResult,
  }) async {
    if (_speechRecognition == null) {
      print('SpeechRecognition is not initialized.');
      return null;
    }
    if (_isListening) {
      print('SpeechRecognition is already in progress.');
      return null;
    }

    print('Starting speech recognition...');
    _isListening = true;

    _speechRecognition!.onResult.listen((event) {
      if (event.results != null && event.results!.isNotEmpty) {
        final result = event.results!.last;
        final transcript = result.item(0).transcript ?? ''; // 获取识别的文本
        print('Transcript: $transcript');
        onResult(transcript);  // 實時更新UI
        // 检查是否是最终结果
        if (result.isFinal ?? false) {
          print('Final recognition: $transcript');
          _isListening = false; // 標記結束
        }
      } else {
        print('No results detected or empty event.');

      }
    });
    _speechRecognition!.start();
  }

  static void stopListening() {
    if (_speechRecognition != null && _isListening) {
      print('Stopping speech recognition...');
      _speechRecognition!.stop();
      _isListening = false;
    } else {
      print('SpeechRecognition is not active.');
    }
  }
}
