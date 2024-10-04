import 'package:flutter/material.dart';
import 'package:jkmapp/utils/diolog.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/services/products/loadingproducts.dart';
import 'package:jkmapp/UI/widgets/image_display.dart';



class Client extends StatefulWidget {
  @override
  ClientState createState() => ClientState();
}

class ClientState extends State<Client> {
  TextEditingController passwordController = TextEditingController();
  List<String>typeOptions=[];
  Map<String, List<Map<String, dynamic>>> categorizedProducts = {};
  String selectedCategory='';//當前選中的分類

   @override
   void initState(){
     super.initState();
     //確保UI完全加載後
     WidgetsBinding.instance.addPostFrameCallback((_) {
       showPasswordNotification(context);
     });
     _loadTypes();
     _loadProducts();
   }
   //加載typeslist
   void _loadTypes() async{
      List<String> types=await StorageHelper.getTypes();
      setState(() {
         typeOptions=types;
      });
   }
   //加載商品
  void _loadProducts()async{
      //要使用await等待
      String? userId = await StorageHelper.getUserId();
      if (userId != null) {
        Map<String, List<Map<String, dynamic>>> products = await ProductService.loadProductForClient(userId);
        setState(() {
          categorizedProducts = products;
        });

      } else {
        print('User ID not found');
      }
  }
   //根據選擇的types更新顯示fooditem列表
   void updateFoodItems(String catecgory){
      setState(() {
         selectedCategory=catecgory;

      });
   }





  // 購物車內容
  List<Map<String, dynamic>> cartItems = []; // 購物車內的商品列表
  int totalAmount = 0; // 總金額



  // 添加商品至購物車
  void addToCart(String item, int price) {
    setState(() {
      cartItems.add({'item': item, 'price': price});
      totalAmount += price;  // 確保這裡的 totalAmount 是 int
    });
  }

  // 從購物車中移除商品
  void removeFromCart(int index) {
    setState(() {
      totalAmount -= cartItems[index]['price'] as int; // 使用 as 將值強制轉換為 int
      cartItems.removeAt(index); // 移除該商品
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // 打開 Drawer
              },
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: typeOptions.map((type){
            return Padding(
                  padding:const EdgeInsets.symmetric(horizontal:4.0),
                   child:ElevatedButton(
                        onPressed:(){
                          updateFoodItems(type);//根據選中的types更新
                   },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCategory ==type ?Colors.yellow :Colors.white,
                  minimumSize: const Size(100, 50),
                  ),
                 child: Text(type),
                 ),
               );
            }).toList(),
        ),
        actions: const [SizedBox(width: 48)], // 用來確保標題在中間
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text('選單', style: TextStyle(fontSize: 24)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('購物車'),
              onTap: () {
                // 點擊後跳轉到購物車
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setModalState) {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              '購物車內容',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(cartItems[index]['item']),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('NT\$ ${cartItems[index]['price']}'),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              removeFromCart(index);  // 在主畫面狀態中更新購物車內容
                                            });
                                            setModalState(() {});  // 在底部彈出框中立即更新畫面
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              color: Colors.blueAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('總共 NT\$', style: TextStyle(color: Colors.white)),
                                  Text(totalAmount.toString(), style: const TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('通知'),
              onTap: () {
                // 可以添加通知的動作
              },
            ),
            SizedBox(height: 80),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('設定'),
              onTap: () {
                // 點擊 "設定" 時彈出密碼對話框
                showPasswordDialog(context, passwordController);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: categorizedProducts[selectedCategory]?.length ?? 0, // 显示当前分类的商品
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //每行顯示三個商品
                crossAxisSpacing: 5.0, // 方框之間水平距離
                mainAxisSpacing: 1.0, // 垂直距離
                childAspectRatio: 0.8, // 控制圖片和文字的比例
              ),
              itemBuilder: (context, index) {
                var product = categorizedProducts[selectedCategory]?[index]; // 獲取當前商品
                return Container(
                  width: 100,
                  height:100,
                  color: Colors.white,
                  child:Card(
                    color:Colors.white,
                    elevation: 4,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageDisplay(imageData: product?['image']),
                      SizedBox(height: 5),
                      Text(
                          product?['name'] ?? '',
                          style: TextStyle(
                             fontSize: 18,
                          ),),
                      const SizedBox(height: 8),
                      Text(
                          'NT\$ ${product?['price']}',
                         style:TextStyle(
                            fontSize: 12,
                           fontWeight: FontWeight.normal,
                         ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addToCart(product?['name'], product?['price']); // 添加到購物車
                        },
                        child: const Text('訂購'),
                      ),
                    ],
                  ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(150, 50)),
                  child: const Text('桌號',
                   style: TextStyle(color:Colors.white),),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(150, 50)),
                  child: const Text(
                      '訂購',
                      style: TextStyle(color:Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
