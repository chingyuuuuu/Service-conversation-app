import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';//用於web
import 'package:image_picker/image_picker.dart';//用於app
import 'package:flutter/foundation.dart' show kIsWeb;//用於判斷是否為web環境
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:jkmapp/services/products/saveproduct_service.dart';
import 'package:jkmapp/services/products/typedialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jkmapp/routers/app_routes.dart';


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
  String? _imageFileName;

  @override
  void initState() {
    super.initState();
    _loadTypes(); //從資料庫中加載已有的type
  }
  //載入以儲存的type
  void _loadTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _typeOptions = prefs.getStringList('savedTypes') ?? [];
    });
  }
  //當新增類型時儲存到sharedPrferences
  void _saveTypes() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setStringList('savedTypes',_typeOptions);//將新增的type暫存

  }


  void _showAddTypeDialog() async {
    String? newType = await DialogService.showAddTypeDialog(//調用DialogService中的方法
        context, _typeController, _typeOptions, _selectedType);

    if (newType != null && newType.isNotEmpty) {
      setState(() {
        if (!_typeOptions.contains(newType)) {
          _typeOptions.add(newType); // 加入新類型
          _saveTypes();//暫存
        }
      });
    }
  }

  //處理團片上傳(web and app通用)
  Future<void> _pickImage() async {
    if(kIsWeb){
      //web
      FilePickerResult? result =await FilePicker.platform.pickFiles(type:FileType.image);
      if(result!=null&&result.files.first.bytes!=null){
        setState(() {
           _selectedImageBytes = result.files.first.bytes;
           _imageFileName = result.files.first.name;
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
          _imageFileName = image.name;

        });
      }
    }
  }

  final SaveProductService _saveProductService = SaveProductService();
  void _saveProduct() async {
    // 调用 saveProduct 来保存商品資訊
    await _saveProductService.saveProduct(
      context: context,
      nameController: _nameController,
      typeController: _typeController,
      priceController: _priceController,
      costController: _costController,
      quantityController: _quantityController,
      selectedImageBytes: _selectedImageBytes,
      selectedImageFile: _selectedImageFile,
       imageFileName:_imageFileName,
    );
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
                  _saveProduct();
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

