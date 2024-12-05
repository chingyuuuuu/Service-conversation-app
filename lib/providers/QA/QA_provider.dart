import 'package:flutter/material.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/services/QA/QA_service.dart';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';


class QAprovider with ChangeNotifier {
  String question = '';
  String answer = '';
  Uint8List? _selectedImageBytes;//儲存圖片二進位(web)
  io.File? _selectedImageFile;//用於儲存圖片文件(app)
  String? _imageFileName;
  Uint8List? get selectedImageBytes => _selectedImageBytes;
  String? get imageFileName => _imageFileName;
  List<Map<String,dynamic>>qaList=[];
  final QAService qaService = QAService();
  final List<Map<String,String>>_messages=[];//回答問題(message="sender":"","text":"")
  List<Map<String,String>>get messages=>_messages;

  //圖片選擇邏輯（ Web 和 App）-將圖片儲存再bytes/file
  Future<void> pickImage() async {
    if (kIsWeb) {
      // web 处理逻辑
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.first.bytes != null) {
        _selectedImageBytes = result.files.first.bytes;
        _imageFileName = result.files.first.name;
        notifyListeners(); // 更新状态，通知界面更新
      }
    } else {
      // app 处理逻辑
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _selectedImageFile = io.File(image.path);
        _selectedImageBytes = await image.readAsBytes(); // 读取图片字节
        _imageFileName = image.name;
        notifyListeners(); // 更新状态，通知界面更新
      }
    }
  }

  // 更新data狀態
  Future<bool> savedata({
    required String question,
    required String answer,
    String? type,

  }) async {
    if (question.isNotEmpty && answer.isNotEmpty) {
      try {
        String? userId = await StorageHelper.getUserId();

        bool success = await qaService.saveQAData(
          question,
          answer,
          type: type,
          selectedImageBytes: _selectedImageBytes,
          selectedImageFile: _selectedImageFile,
          imageFileName: _imageFileName,
          userId: userId ?? '',
        );

        if (success) {
          notifyListeners(); // 成功后更新状态
          return true;
        } else {
          throw Exception('Failed to save data');
        }
      } catch (e) {
        print('Error saving data: $e');
        throw Exception('An error occurred while saving data');
      }
    } else {
      throw Exception('Question and Answer cannot be empty');
    }
  }

  // 刪除數據
  Future<void> deleteData(String qaId) async {
    try {
      bool success = await qaService.deleteData(qaId);
      if (success) {
        qaList.removeWhere((qa) => qa['qaId'] == qaId);
        notifyListeners(); // 成功后更新状态
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      print('Error deleting data: $e');
      throw Exception('An error occurred while deleting data');
    }
  }
  //載入商品
  Future<void> fetchQAData() async {
    try {
      String? userId = await StorageHelper.getUserId();
      if (userId != null) {
        qaList = await qaService.fetchQA(userId); // 获取数据并赋值给 qaList
        notifyListeners();  // 通知 UI 更新
      }
    } catch (e) {
      print('Failed to fetch QA data: $e');
    }
  }

  //載入商品資訊
  Future<Map<String, dynamic>?> fetchQADataByQAid(String qaId) async {
    try {
      List<Map<String, dynamic>> qaList = await qaService.fetchQAByqaid(qaId);  // 获取指定 QA 数据
      if (qaList.isNotEmpty) {
        return qaList.first;  // 返回列表中的第一个 QA 条目
      }
      return null;  // 如果没有找到，返回 null
    } catch (e) {
      print('Failed to fetch QA data: $e');
    }
  }

  //updateData
  Future<void> updateData({
    required String qaId,
    required String question,
    required String answer,
    String? type,
    String? imageUrl}) async {
    try {
      await qaService.updatedata(
        qaId: qaId,
        question: question,
        answer: answer,
        type: type,
        image: imageUrl,
      );

      fetchQADataByQAid(qaId);  // 更新後重新載入 QA 資料
      notifyListeners();  // 通知 UI 更新
    } catch (e) {
      print('Failed to update QA data: $e');
    }
  }

  //用來判斷是否為keyword
  //將type也放入keyword的一種
  Future<bool> isKeyword(String userQuestion)async{
      List<String>keywords=['點餐','下訂單'];
      //獲取types
      List<String>storedTypes=await  StorageHelper.getDBtypes();
      //將types合併到keyword表中
      keywords.addAll(storedTypes);
      //判斷客人輸入使否包含關鍵字
      for(var keyword in keywords){
          if(userQuestion.contains(keyword)){
              return true;
          }
      }
      return false;
  }

  //回答問題
  Future<void>sendMessage(String userQuestion)async{
      //分辨user還是bot去回應
      //加入客人的資訊-user
      _messages.add({"sender":"user","text":userQuestion});
      notifyListeners();

      if(await isKeyword(userQuestion)){ //如果是keyword就調用任務處理
        String taskResponse = await handleTask(userQuestion);
         await Future.delayed(Duration(seconds:3));
         _messages.add({"sender":"bot","text":taskResponse});
         notifyListeners();
      }else{
        //獲得答案
        String answer=await qaService.fetchanswer(userQuestion);
        //加入機器人回應訊息-用delay去模擬思考
        await Future.delayed(Duration(seconds:3));
        _messages.add({"sender":"bot","text":answer});
        notifyListeners();
      }
    }

    //處理關鍵字任務
    Future<String>handleTask(String task)async {
      //獲取types
      List<String> foodTypes = await StorageHelper.getDBtypes();
      if (task.contains('點餐')) {
        //Step1.發送點餐請求到後端，獲得all types
        if (foodTypes.isNotEmpty) {
          return '請選擇商品類型: ${foodTypes.join(',')}'; //返回bot回應
        } else {
          return '目前無法提供商品類型，請稍後再試';
        }
      } else if (foodTypes.contains(task)) {
        //輸出該type的商品資訊
        Map<String, List<Map<String, dynamic>>> productsByType = await StorageHelper.getProductsByType();
         if(productsByType.containsKey(task)){
           List<Map<String, dynamic>> products = productsByType[task]!;
           if (products.isNotEmpty) {
             // 合併資訊
             String productList = products.map((p) => '${p['name']} (${p['price']}元)').join(', ');
             return '以下是 $task 的商品資訊: $productList ,請選擇你想要的商品?';
           } else {
             return '目前 $task 沒有可用商品';
           }
         } else {
           return '目前暫無 $task 類的商品資訊';
         }
      } else if (task.contains('下訂單')) {
        return '您的訂單已下定成功!';
      } else {
        return '無法識別任務';
      }
    }


}