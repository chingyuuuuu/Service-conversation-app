import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';//用於web
import 'package:image_picker/image_picker.dart';//用於app
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;//用於判斷是否為web環境
import 'dart:io' as io;
import 'dart:typed_data';



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

  List<String>_typeOptions = []; //儲存已有的類型
  String? _selectedType;
  Uint8List? _selectedImageBytes;//儲存圖片二進位(web)
  io.File? _selectedImageFile;//用於儲存圖片文件(app)


  @override
  void initState() {
    super.initState();
    _loadTypes(); //從資料庫中加載已有的type
  }

  void _loadTypes() {
    //從資料庫獲取type
    setState(() {
      _typeOptions = [];
    });
  }

  //顯示SnackBar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(message, style: TextStyle(color: color)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  //顯示加入類別的對話框-1.輸入 2.已經有的
  void _showAddTypeDialog() async {
    String? newType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( //對話框
          title: Text('加入類型'),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField( //輸入框
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: '輸入新類型',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF223888))
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<String>( //選擇框
                value: _selectedType,
                hint: Text('選擇已有類型'),
                isExpanded: true,
                dropdownColor: Colors.white,
                items: _typeOptions.map((String type) { //用以存在的類型列表生成一組選項
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) { //當user選擇後
                  setState(() {
                    _selectedType = value;
                  });
                  Navigator.of(context).pop(value); //關閉
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); //關閉對話框
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (_typeController.text.isNotEmpty) {
                  Navigator.pop(context, _typeController.text);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF36FDE6),
                foregroundColor: Colors.black,
              ),
              child: Text('儲存'),
            ),
          ],
        );
      },
    );

    //處理返回的新類型
    if (newType != null && newType.isNotEmpty) {
      setState(() {
        if (!_typeOptions.contains(newType)) {
          _typeOptions.add(newType); //將新類型將入選項列表
        }
      });
    }
  }


  Future<String?> _getUserId() async {
    //從暫存中獲取user_id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  //處理團片上傳(web and app通用)
  Future<void> _pickImage() async {
    if(kIsWeb){
      //web
      FilePickerResult? result =await FilePicker.platform.pickFiles(type:FileType.image);
      if(result!=null&&result.files.first.bytes!=null){
        setState(() {
           _selectedImageBytes = result.files.first.bytes;
        });
      }
    }else{
      //app-imgaepicker
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if(image!=null){
        final bytes =await image.readAsBytes();//先讀取文件數據
        setState(() {
          _selectedImageFile = io.File(image.path);
          _selectedImageBytes = bytes;
        });
      }
    }
  }

  bool _validateInput(String name, String priceStr) {
    if (name.isEmpty) {
      _showSnackBar("名稱未輸入", Colors.red);
      return false;
    }
    if (priceStr.isEmpty) {
      _showSnackBar("價格未輸入", Colors.red);
      return false;
    }
    return true;
  }

  //驗證數值是否正確
  T? _parseInput<T>(String input, T Function(String) parser,
      String errorMessage) {
    try {
      return parser(input);
    } catch (e) {
      _showSnackBar(errorMessage, Colors.red);
      return null;
    }
  }

  void saveProduct() async {
    String? userId = await _getUserId(); //獲取user_id

    // 儲存商品資訊
    String name = _nameController.text;
    String type = _typeController.text;
    String priceStr = _priceController.text;
    if (!_validateInput(name, priceStr)) return;

    double? price = _parseInput<double>(
        priceStr, double.parse, "價格格式不正確");
    double? cost = _parseInput<double>(
        _costController.text, double.parse, "成本格式不正確");
    int? quantity = _parseInput<int>(
        _quantityController.text, int.parse, "庫存量格式不正確");
    if (price == null || cost == null || quantity == null) return;

    //向server發送data
    try {
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


      //上傳圖片
      if (_selectedImageBytes != null || _selectedImageFile != null) {
        if (kIsWeb) {
          // 如果是 Web，使用二進制數據進行上傳
          request.files.add(http.MultipartFile.fromBytes(
            'image',
            _selectedImageBytes!,
            filename: 'upload_image.png',
          ));
        } else {
          var multipartFile = await http.MultipartFile.fromPath(
            'image',
            _selectedImageFile!.path,
          );
          request.files.add(multipartFile);
         }
       } else {
        _showSnackBar("未選擇圖片", Colors.red);
        return;
      }


      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        _showSnackBar("儲存成功", Colors.green);
        Navigator.pop(context, {
          'name': name,
          'type':type,
          'price':price,
          'cost':cost,
          'quantity':quantity,
          'image': kIsWeb ? _selectedImageBytes : _selectedImageFile?.path, // 根據環境回傳不同的數據
        });
      } else {
        _showSnackBar("儲存失敗", Colors.red);
       }
     } catch (e) {
      _showSnackBar("發生錯誤", Colors.red);
    }
  }


  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("創建商品"),
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
                controller: null,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: '種類',
                  suffixIcon: IconButton(
                      onPressed: _showAddTypeDialog,//點擊，彈出對話框
                      icon: Icon(Icons.add_circle_outline)
                  ),
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
                  _pickImage(); // 選擇圖片
                },
                child: Row(
                  children: [
                    Icon(Icons.photo),
                    SizedBox(width: 10),
                    Text(_selectedImageBytes != null ? '已選擇圖片' : '圖片'),
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
                //實際預覽選擇圖片
                _selectedImageBytes !=null
                    ? Image.memory(_selectedImageBytes!, width: 100, height: 100)
                    : _selectedImageFile != null
                    ? Image.file(_selectedImageFile!, width: 100, height: 100)
                    : Container(),
            ],
          ),
        ),
      );
    }
  }

