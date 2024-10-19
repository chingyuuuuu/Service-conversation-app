import 'package:flutter/material.dart';
import 'package:jkmapp/services/products/loadingproducts.dart';




class ProductDetailPage extends StatefulWidget {
  final int productId;//接受從上個頁面傳來productId
  ProductDetailPage({required this.productId});//傳遞productId 來創建

  @override
  _productDetailPageState createState()=>_productDetailPageState();
}

class _productDetailPageState extends State<ProductDetailPage>{
   Map<String, dynamic>? productDetails;//保存加載到的商品資訊
   late TextEditingController _nameController;
   late TextEditingController _typeController;
   late TextEditingController _priceController;
   late TextEditingController _costController;
   late TextEditingController _quantityController;




   @override
  void initState(){
    super.initState();
    //一定要初始化，避免初始化錯誤
    _nameController = TextEditingController(text: '');
    _typeController = TextEditingController(text: '');
    _priceController = TextEditingController(text: '');
    _costController = TextEditingController(text: '');
    _quantityController = TextEditingController(text: '');
     //根據productid加載商品資訊
    _loadProductDetails(widget.productId);
  }

  Future<void> _loadProductDetails(int productId) async {
      final product = await ProductService.loadProductDetails(context,productId);
      if (product != null) {
        setState(() {
          productDetails = product;
          //初始化商品資訊
          // 初始化 TextEditingController，显示加载到的商品信息
          _nameController.text = product['name'];
          _typeController.text = product['type'];
          _priceController.text = product['price'].toString();
          _costController.text = product['cost'].toString();
          _quantityController.text = product['quantity'].toString();

        });
      }
  }
  Future<void> _updateProduct()async{
      await ProductService.updateProduct(//等待回應，更新產品資訊
          context,
          widget.productId,
          _nameController.text,
          _typeController.text,
          double.parse(_priceController.text),
          double.parse(_costController.text),
          int.parse(_quantityController.text),
      );
  }

  Future<void>_deleteProduct()async{
      bool isDeleted=await ProductService.deleteProduct(context, widget.productId);
      if(isDeleted) {
        //刪除成功後刷新
        Navigator.pop(context,'delete');
      }

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
                          onPressed: _updateProduct,//更新商品資訊
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