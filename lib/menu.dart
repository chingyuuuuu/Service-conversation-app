import 'package:flutter/material.dart';
import 'package:jkmapp/UI/widgets/image_display.dart';
import 'package:jkmapp/services/products/loadingproducts.dart';
import 'package:jkmapp/routers/app_routes.dart';


class MenuPage extends StatefulWidget{
  @override
  MenuPageState createState()=>MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>>_addedProducts = [];//儲存多個商品訊息
  @override
  //登入後即加載商品
  void initState(){
    super.initState();
       _loadProducts();
  }

  //從ProductService加載商品數據
  void _loadProducts() async {
    final loadedProducts = await ProductService.loadProdcuts(context);
    setState(() {
      _addedProducts = loadedProducts;//加載商品列表(有包含productId)
    });
  }

  //problem
  Future<void> _navigateToCreateMerchandise() async {
    final result = await Navigator.pushNamed(context,Routers.createMerchandise);
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        //將新增商品資訊放入列表中
        _addedProducts.add(result);
      });
    }
    _loadProducts();//返回之後刷新商品頁面
  }

  //傳遞productId到商品資訊頁面
  void _navigateToProductDetail(Map<String, dynamic> product, int index) async {
    final result = await Navigator.pushNamed(
        context,Routers.productdetail,
        arguments:{
          'product_id':product['product_id'],
        });
    if (result != null && result == 'delete') {
      setState(() {
        _addedProducts.removeAt(index);  // 刪除商品
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //基礎的布局結構
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("菜單"),
        backgroundColor: Color(0x179E9E9E),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer(); //打開側邊欄
          },
        ),
      ),
      body: _addedProducts.isEmpty
          ? Center(child: Text("尚未加入商品"))
          : GridView.builder(//用來生成網格
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 每行顯示兩個商品
          crossAxisSpacing: 5.0, // 方框之間的水平間距
          mainAxisSpacing:5.0, // 方框之間的垂直間距
          childAspectRatio: 0.8, // 控制圖片與文字的比例
        ),
        itemCount: _addedProducts.length,//生成圖片顯示元素
        itemBuilder: (context, index) {
          final product = _addedProducts[index];
          return GestureDetector(
            onTap:(){
              _navigateToProductDetail(product,index);
            },
            child: Column(
              children: [
                 ImageDisplay(imageData: product['image']),
                SizedBox(height: 5),
                // 顯示名稱
                Text(
                  product['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // 當名稱過長時省略
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateMerchandise,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color:Colors.black,
        ),
      ),
    );
  }
}


