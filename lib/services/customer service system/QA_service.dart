import 'dart:convert';
import 'package:jkmapp/utils/localStorage.dart';
import'package:http/http.dart' as http;

class QAService{
      //儲存到資料庫
  Future<bool> saveQAData(String question, String answer, {String? type, String? imageUrl, required String userId}) async {
      try {
        // 构建 multipart/form-data 请求
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://127.0.0.1:5000/savedata'),
        );

        // 添加表单字段
        request.fields['question'] = question;
        request.fields['answer'] = answer;
        request.fields['user_id'] = userId;

        if (type != null) {
          request.fields['type'] = type;
        }

        // 如果有图片 URL，可以在这里传递
        if (imageUrl != null) {
          request.fields['image'] = imageUrl; // 直接传递 URL
        }

        // 发送请求并获取响应
        var response = await request.send();

        // 检查是否成功
        if (response.statusCode == 200) {
          print('Data saved successfully');
          return true;
        } else {
          print('Failed to save data');
          return false;
        }
      } catch (e) {
        print('Error occurred while saving data: $e');
        return false;
      }
   }

     //從資料庫中獲取已儲存的QA
     Future<List<Map<String, dynamic>>> fetchQA(String userId) async {
       final response =await http.get(
           Uri.parse('http://127.0.0.1:5000/getqa?user_id=$userId'),
           headers: {'Content-Type':'application/json'},
         );
         if(response.statusCode==200){
            List<Map<String,dynamic>>qalist = List<Map<String,dynamic>>.from(jsonDecode(response.body));
            return qalist;

         }else{
           throw Exception('Failed to load QA data');
         }
     }
     //載入商品資訊
     Future<List<Map<String, dynamic>>> fetchQAByqaid(String qaId) async {
       final response =await http.get(
         Uri.parse('http://127.0.0.1:5000/getqabyqaid/$qaId'),
         headers: {'Content-Type':'application/json'},
       );
       if(response.statusCode==200){
         List<Map<String,dynamic>>qalist = List<Map<String,dynamic>>.from(jsonDecode(response.body));
         return qalist;

       }else{
         throw Exception('Failed to load QA data');
       }
     }
     //更新data
     Future<void> updatedata({
       required String qaId,
       required String question,
       required String answer,
       String? type,
       String? image,
     }) async {
       final response = await http.post(
         Uri.parse('http://127.0.0.1:5000/updatedata/$qaId'),
         headers: {'Content-Type': 'application/json'},
         body: jsonEncode({
           'question': question,
           'answer': answer,
           'type': type,
           'image': image,
         }),
       );

       if (response.statusCode != 200) {
         throw Exception('Failed to update QA data');
       }
     }
      //從資料庫中刪除
     Future<bool>deleteData(String qaId)async{
       try{
            final response =await http.delete(
                 Uri.parse('http://127.0.0.1:5000/deletedata/$qaId'),
                 headers: {'Content-Type': 'application/json'},
            );
            return response.statusCode == 200;
       }catch(e){
          print('Error deleting QA data:$e');
          return false;
       }
     }

}