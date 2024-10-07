import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServiceScreen(),
    );
  }
}

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  File? _imageFile;  // 本地圖片文件
  String? _imageUrl; // 用戶輸入的圖片網址
  final TextEditingController _urlController = TextEditingController();

  // 從相冊選擇圖片
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);  // 將選擇的圖片存入 _imageFile
        _imageUrl = null;  // 清空 URL
      });
    }
  }

  // 顯示圖片縮圖
  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return Image.network(
        _imageUrl!,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error, color: Colors.red);  // 若網址無效則顯示錯誤圖標
        },
      );
    } else {
      return Text('尚未選擇圖片');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service',
          style: TextStyle(fontFamily: 'Cursive', fontSize: 30),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // 打開側邊欄或選單
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(width: 8),
                      Text('類別', style: TextStyle(fontSize: 16)),
                      Spacer(),
                      DropdownButton<String>(
                        items: <String>['選項 1', '選項 2', '選項 3'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                        hint: Text('請選擇'),
                      ),
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.black),
                        onPressed: () {
                          // 打開設置選單
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Q:', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '請輸入你的問題',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('A:', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '請輸入你的回答',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.image, color: Colors.black),
                      SizedBox(width: 8),
                      Text('圖片', style: TextStyle(fontSize: 16)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.add_photo_alternate, color: Colors.blue),
                        onPressed: _pickImageFromGallery,  // 打開相冊選擇圖片
                      ),
                      IconButton(
                        icon: Icon(Icons.link, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            _imageUrl = _urlController.text;  // 將 URL 轉為圖片
                            _imageFile = null;  // 清空本地圖片
                          });
                        },
                      ),
                    ],
                  ),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: '輸入圖片網址',
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildImagePreview(),  // 顯示圖片縮圖
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}