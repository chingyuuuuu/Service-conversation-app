import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/restaurant/product_provider.dart';

class CreateMerchandise extends StatefulWidget {
  @override
  CreateMerchandiseState createState() => CreateMerchandiseState();
}

class CreateMerchandiseState extends State<CreateMerchandise> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {//確保加載完畢
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.loadTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("創建商品"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: productProvider.nameController,
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
                  onPressed: () => productProvider.showAddTypeDialog(context),
                  icon: Icon(Icons.add_circle_outline),
                ),
              ),
            ),
            TextField(
              controller: productProvider.priceController,
              decoration: InputDecoration(
                labelText: '價格',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: productProvider.costController,
              decoration: InputDecoration(
                labelText: '成本',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: productProvider.quantityController,
              decoration: InputDecoration(
                labelText: '庫存量',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => productProvider.pickImage(),
              child: Row(
                children: [
                  Icon(Icons.photo),
                  SizedBox(width: 10),
                  Text(productProvider.selectedImageBytes != null
                      ? '已選擇圖片'
                      : '圖片'),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => productProvider.saveProduct(context),
              child: Text('儲存'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF36FDE6),
                foregroundColor: Colors.black,
                minimumSize: Size(150, 50),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            productProvider.selectedImageBytes != null
                ? Image.memory(productProvider.selectedImageBytes!, width: 100, height: 100)
                : productProvider.selectedImageFile != null
                ? Image.file(productProvider.selectedImageFile!, width: 100, height: 100)
                : Container(),
          ],
        ),
      ),
    );
  }
}
