import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;//用於判斷是否為web環境
import 'package:jkmapp/UI/widgets/image_display.dart';


class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final int index;

  ProductDetailPage({required this.product, required this.index});

  @override
  _productDetailPageState createState()=>_productDetailPageState();
}

class _productDetailPageState extends State<ProductDetailPage>{
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _priceController;
  late TextEditingController _costController;
  late TextEditingController _quantityController;
  Uint8List? _selectedImageBytes;
  File? _selectedImageFile;




  @override
  void initState(){
    super.initState();
    //初始化:顯示商品創建時的資訊
    _nameController = TextEditingController(text: widget.product['name']);
    _typeController = TextEditingController(text: widget.product['type']);
    _priceController = TextEditingController(text: widget.product['price'].toString());
    _costController = TextEditingController(text: widget.product['cost'].toString());
    _quantityController = TextEditingController(text: widget.product['quantity'].toString());

    if (widget.product['image'] is Uint8List) {
      _selectedImageBytes = widget.product['image'];
    } else if (widget.product['image'] is String) {
      _selectedImageFile = File(widget.product['image']);
    }
  }


  void _saveChanged(){
     Navigator.pop(context,{
       'name': _nameController.text,
       'type': _typeController.text,
       'price': double.tryParse(_priceController.text),
       'cost': double.tryParse(_costController.text),
       'quantity': int.tryParse(_quantityController.text),
       'image': _selectedImageBytes ?? _selectedImageFile?.path,
     });
  }
  //刪除商品
  void _deleteProduct(){
     Navigator.pop(context,'delete');//返回delete
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('商品詳情'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              // 商品名稱
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '名稱'),
              ),
              // 類型
              TextField(
                controller: _typeController,
                decoration: InputDecoration(labelText: '類型'),
              ),
              // 價格
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: '價格'),
                keyboardType: TextInputType.number,
              ),
              // 成本
              TextField(
                controller: _costController,
                decoration: InputDecoration(labelText: '成本'),
                keyboardType: TextInputType.number,
              ),
              // 數量
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: '數量'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                      ElevatedButton(
                          onPressed: _saveChanged,
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          ),
                          child: Text(
                          '儲存',
                          style: TextStyle(color:Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _deleteProduct,
                        style:ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                      '刪除',
                      style: TextStyle(color:Colors.red),
                     ),
                    ),
                ],
              ),
            ],
          ),
        )
      );
    }
  }