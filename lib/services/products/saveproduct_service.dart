import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:jkmapp/utils/SnackBar.dart';
import 'dart:convert';
import 'package:jkmapp/utils/localStorage.dart';

class SaveProductService{
  //防呆機制
  bool _validateInput(BuildContext context,String name, String priceStr,String type) {
    if (name.isEmpty) {
      SnackBarutils.showSnackBar(context,"名稱未輸入", Colors.red);
      return false;
    }
    if (priceStr.isEmpty) {
      SnackBarutils.showSnackBar(context,"價格未輸入", Colors.red);
      return false;
    }
    if (type.isEmpty) {
      SnackBarutils.showSnackBar(context,"類型未選擇", Colors.red);
      return false;
    }
    return true;
  }

  //驗證數值是否正確
  T? _parseInput<T>(BuildContext context,String input, T Function(String) parser, String errorMessage) {
    try {
      return parser(input);
    } catch (e) {
      SnackBarutils.showSnackBar(context,"數值錯誤" ,Colors.red);
      return null;
    }
  }

  //業者儲存商品
  Future<void> saveProduct({
      required BuildContext context,
      required TextEditingController nameController,
      required TextEditingController typeController,
      required TextEditingController priceController,
      required TextEditingController costController,
      required TextEditingController quantityController,
      Uint8List? selectedImageBytes,
      File? selectedImageFile,
      String? imageFileName,

  })async{
       String? userId = await StorageHelper.getUserId();
       String name = nameController.text;
       String type = typeController.text;
       String priceStr = priceController.text;
       if (!_validateInput(context,name, priceStr,type)) return;

       double? price = _parseInput<double>(context, priceStr, double.parse, "價格格式不正確");
       double? cost = _parseInput<double>(context, costController.text, double.parse, "成本格式不正確");
       int? quantity = _parseInput<int>(context, quantityController.text, int.parse, "庫存量格式不正確");
       if (price == null || cost == null || quantity == null) return;

       //向server發送data
       try{
         var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:5000/uploadproducts'));
         request.fields['name'] = name;
         request.fields['type'] = type;
         request.fields['price'] = price.toString();
         request.fields['cost'] = cost.toString();
         request.fields['quantity'] = quantity.toString();
         request.fields['user_id'] = userId ?? '';

         //上傳圖片
         if (selectedImageBytes != null || selectedImageFile != null) {
           if (kIsWeb) {
             request.files.add(http.MultipartFile.fromBytes(
               'image',
               selectedImageBytes!,
               filename: imageFileName ?? 'default_image.png',
             ));
           } else {
             var multipartFile = await http.MultipartFile.fromPath(
               'image',
               selectedImageFile!.path,
               filename: imageFileName ?? selectedImageFile!.path.split('/').last, // 使用原始文件名
             );
             request.files.add(multipartFile);
           }
         } else {
           SnackBarutils.showSnackBar(context, "未選擇圖片，將顯示預設圖片", Colors.grey);
         }

         final response = await request.send();
         final responseData = await http.Response.fromStream(response);
         final responseBody = json.decode(responseData.body);

         if (response.statusCode == 200) {
           final productId = responseBody['productId'];//獲得產品id
           SnackBarutils.showSnackBar(context, "儲存成功", Colors.green);
           Navigator.pop(context,true);//傳遞true表示需要刷新menu
         } else {
           SnackBarutils.showSnackBar(context, "儲存失敗", Colors.red);
         }
       } catch (e) {
         print('Error occured: $e');
         SnackBarutils.showSnackBar(context, "發生錯誤", Colors.red);

    }
  }
}