import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/restaurant/product_provider.dart';

//業者可以看到商品的資訊
class ProductDetailPage extends StatefulWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.loadProductDetails(context, widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('商品詳情'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: productProvider.productDetails == null
            ? Center(child: CircularProgressIndicator()) // 加載中
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: productProvider.nameController,
              decoration: InputDecoration(labelText: '名稱'),
            ),
            TextField(
              controller: productProvider.typeController,
              decoration: InputDecoration(labelText: '類型'),
            ),
            TextField(
              controller: productProvider.priceController,
              decoration: InputDecoration(labelText: '價格'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: productProvider.costController,
              decoration: InputDecoration(labelText: '成本'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: productProvider.quantityController,
              decoration: InputDecoration(labelText: '數量'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => productProvider.updateProduct(
                      context, widget.productId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    '儲存',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => productProvider.deleteProduct(
                      context, widget.productId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    '刪除',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
