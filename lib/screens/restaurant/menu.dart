import 'package:flutter/material.dart';
import 'package:jkmapp/widgets/image_display.dart';
import 'package:jkmapp/services/products/loadingproducts.dart';
import 'package:jkmapp/routers/app_routes.dart';


class MenuPage extends StatefulWidget{
  @override
  MenuPageState createState()=>MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>>_addedProducts = []; //儲存多個商品訊息
  @override
  //登入後即加載商品
  void initState() {
    super.initState();
    _loadProducts();
  }

  //從ProductService加載商品數據
  void _loadProducts() async {
    final loadedProducts = await ProductService.loadProdcuts(context);
    setState(() {
      _addedProducts = loadedProducts; //加載商品列表(有包含productId)
    });
  }


  Future<void> _navigateToCreateMerchandise() async {
    final result = await Navigator.pushNamed(
        context, Routers.createMerchandise);
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        //將新增商品資訊放入列表中
        _addedProducts.add(result);
      });
    }
    _loadProducts(); //返回之後刷新商品頁面
  }

  //傳遞productId到商品資訊頁面
  void _navigateToProductDetail(Map<String, dynamic> product, int index) async {
    final result = await Navigator.pushNamed(
        context, Routers.productdetail,
        arguments: {
          'product_id': product['product_id'],
        });
    if (result != null && result == 'delete') {
      setState(() {
        _addedProducts.removeAt(index); // 刪除商品
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("菜單",
            style:TextStyle(
               color:Colors.white,
              fontSize:18,
              fontWeight: FontWeight.bold,
            )),
            backgroundColor: Color(0xFF223888),
            floating: true,
            pinned: true,
            elevation: 10,
            shape:RoundedRectangleBorder(
               borderRadius:BorderRadius.vertical(
                 top:Radius.circular(10),
                 bottom: Radius.circular(10),//appbar底部圓角
               ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // 打开侧边栏
              },
            ),
          ),

          // 检查商品是否为空
          _addedProducts.isEmpty
              ? SliverFillRemaining(
            child: Center(child: Text("尚未加入商品")),
          )
              : SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 每行显示两个商品
                crossAxisSpacing: 5.0, // 方框之间的水平间距
                mainAxisSpacing: 1.0, // 方框之间的垂直间距
                childAspectRatio: 1.2, // 控制图片与文字的比例
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = _addedProducts[index];
                  return GestureDetector(
                    onTap: () {
                      _navigateToProductDetail(product, index);
                    },
                    child: Column(
                      children: [
                        ImageDisplay(imageData: product['image']),
                        SizedBox(height: 5),
                        // 显示商品名称
                        Text(
                          product['name'],
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis, // 当名称过长时省略
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
                childCount: _addedProducts.length, // 商品数量
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateMerchandise,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}