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

  List<String>_typeOptions=[];//儲存已有的類型
  String? _selectedType;
  File? _selectedImage; // 用於儲存選擇的圖片
  final ImagePicker _picker = ImagePicker(); // 初始化 image picker

  @override
  void initState(){
    super.initState();
    _loadTypes();//從資料庫中加載已有的type
  }
  void _loadTypes(){//從資料庫獲取type
    setState(() {
       _typeOptions=[];
    });
  }
  //顯示加入類別的對話框-1.輸入 2.已經有的
  void _showAddTypeDialog() async{
     String? newType = await showDialog<String>(
        context: context,
        builder:(BuildContext context){
          return AlertDialog(//對話框
            title: Text('加入類型'),
            backgroundColor: Colors.white,
            content: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 TextField(//輸入框
                   controller: _typeController,
                   decoration: InputDecoration(
                     labelText: '輸入新類型',
                     enabledBorder: UnderlineInputBorder(
                       borderSide: BorderSide( color: Color(0xFF223888))
                     ),
                     focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Colors.blue),
                     ),
                 ),
               ),
              SizedBox(height: 10),
              DropdownButton<String>(//選擇框
                value:_selectedType,
                hint:Text('選擇已有類型'),
                isExpanded: true,
                 dropdownColor: Colors.white,
                 items: _typeOptions.map((String type) {//用以存在的類型列表生成一組選項
                   return DropdownMenuItem<String>(
                       value: type,
                       child: Text(type),
                      );
                   }).toList(),
                    onChanged: (String? value){//當user選擇後
                     setState(() {
                         _selectedType = value;
                     });
                     Navigator.of(context).pop(value);//關閉
                 },
               ),
             ],
          ),
         actions: [
             TextButton(
              onPressed: (){
                 Navigator.pop(context);//關閉對話框
               },
               style: TextButton.styleFrom(
                   backgroundColor: Colors.white,
                   foregroundColor: Colors.black,
               ),
               child: Text('取消'),
               ),
              TextButton(
                 onPressed: (){
                    if(_typeController.text.isNotEmpty){
                       Navigator.pop(context,_typeController.text);
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
        if(newType!=null &&newType.isNotEmpty){
          setState(() {
              if(!_typeOptions.contains(newType)){
                _typeOptions.add(newType);//將新類型將入選項列表
             }
          });
        }
      }



  Future<String?> _getUserId() async {//從暫存中獲取user_id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // 存储圖片路径
      });
    }
  }

  void saveProduct() async {
    String? userId = await _getUserId();//獲取user_id

    // 儲存商品資訊
    String name = _nameController.text;
    String type = _typeController.text;
    //名稱和金額一定要輸入
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text("名稱未輸入！",
          style: TextStyle(color:Colors.black),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (_priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text("價格未輸入！",
            style: TextStyle(color:Colors.black),
          ),
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
          backgroundColor: Colors.white,
          content: Text("價格格式不正確！",
            style: TextStyle(color: Colors.black),
          ),
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
          backgroundColor: Colors.white,
          content: Text("成本格式不正確！",
            style: TextStyle(color: Colors.black),
          ),
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
          backgroundColor: Colors.white,
          content: Text("庫存量格式不正確！",
            style: TextStyle(color: Colors.black),
          ),
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
            backgroundColor: Colors.white,
            content: Text("儲存成功！",
            style: TextStyle(color:Colors.green),
            ),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context,{
          'name':name,
          'image':_selectedImage?.path,
        });
      } else {
        print("Failed to save product");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Text("儲存失敗！",
              style: TextStyle(color:Colors.red),
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text("發生錯誤!",
            style: TextStyle(color:Colors.red),
          ),
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

