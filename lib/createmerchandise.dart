import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class CreateMerchandise extends StatefulWidget {
  @override
  CreateMerchandiseState createState() => CreateMerchandiseState();
}

class CreateMerchandiseState extends State<CreateMerchandise> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  File? _selectedImage; // 用於儲存選擇的圖片
  final ImagePicker _picker = ImagePicker(); // 初始化 image picker

  Future<String?> _getUserId() async {//從暫存中獲取user_id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // 存储图片路径
      });
    }
  }

  void saveProduct() async {
    String? userId = await _getUserId();//獲取user_id

    // 儲存商品資訊
    String name = _nameController.text;
    String type = _typeController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("名稱未輸入！"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (_priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("價格未輸入！"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    double price;
    double cost;
    int quantity;

    try {
      price = double.parse(_priceController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("價格格式不正確！"),
          duration: Duration(seconds: 2),
        ),
      );
      return; //結束
    }

    try {
      cost = double.parse(_costController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("成本格式不正確！"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      quantity = int.parse(_quantityController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("庫存量格式不正確！"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try { //向server發送data
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/uploadproducts'),
      );

      request.fields['name'] = name;
      request.fields['type'] = type;
      request.fields['price'] = price.toString();
      request.fields['cost'] = cost.toString();
      request.fields['quantity'] = quantity.toString();
      request.fields['user_id'] = userId ?? '';

      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ));
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print('Success: ${responseData.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("儲存成功！"),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      } else {
        print("Failed to save product");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("儲存失敗！"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("發生錯誤!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }



  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Create merchandise"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // 返回上一頁
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '名稱',
                ),
              ),
              TextField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: '種類',
                ),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: '價格',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _costController,
                decoration: InputDecoration(
                  labelText: '成本',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: '庫存量',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _pickImage(); // 选择图片
                },
                child: Row(
                  children: [
                    Icon(Icons.photo),
                    SizedBox(width: 10),
                    Text(_selectedImage != null ? '已選擇圖片' : '圖片'),
                    // 显示是否选择了图片
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveProduct();
                },
                child: Text('儲存'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF36FDE6),
                  foregroundColor: Colors.black,
                  minimumSize: Size(150, 50),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

