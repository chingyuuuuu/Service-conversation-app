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
  List<Map<String,dynamic>> products = []; // 儲存all prodcuts
  Map<String, List<Map<String, dynamic>>> categorizedProducts = {};//按照types分類的商品
  List<Map<String, dynamic>> displayedProducts = [];//儲存介面上顯示的商品列表
  String selectedTypes = ''; //允許追蹤哪個按鈕被選中
  List<String>typeOptions = [];

  @override
  void initState() {
    super.initState();
    //確保UI完全加載後
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showPasswordNotification(context);
    });
    _loadProducts();
  }



  //加載商品，從商品中取得type(因為儲存在資料庫中當中，所以不會不見)
  void _loadProducts() async {
    //要使用await等待
    String? userId = await StorageHelper.getUserId();
    if (userId != null) {
      List<Map<String, dynamic>> loadproducts = await ProductService.loadProductForClient(userId);
      //按照商品分類
      Map<String,List<Map<String,dynamic>>>categorized={};//按照types對商品進行分類
      Set<String> types = loadproducts.map((product) => product['type'] as String).toSet();//儲存商品的types
      for(var type in types){//遍歷all商品提取type類型
        //根據每個type，將屬於該類型的產品放入
        categorized[type] = loadproducts.where((product) => product['type'] == type).toList();
      }


      setState(() {
        products = loadproducts; //將產品放入這個表
        typeOptions = types.toList();//將types保存到這個表
        categorizedProducts=categorized;
        displayedProducts = loadproducts;//預設顯示所有商品
      });
    } else {
      print('User ID not found');
    }
  }

  void _filterProductsByType(String type) {
    setState(() {
      selectedTypes = type;
      displayedProducts = categorizedProducts[type] ?? []; //更新為選中的商品類型
    });
  }


  // 購物車內容
  List<Map<String, dynamic>> cartItems = []; // 購物車內的商品列表
  int totalAmount = 0; // 總金額


  // 添加商品至購物車
  void addToCart(String item, int price) {
    setState(() {
      cartItems.add({'item': item, 'price': price});
      totalAmount += price; // 確保這裡的 totalAmount 是 int
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
                Scaffold.of(context).openDrawer(); // 打开 Drawer
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (BuildContext context,
                          StateSetter setModalState) {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              '購物車清單',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                        Text(
                                            'NT\$ ${cartItems[index]['price']}'),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              removeFromCart(
                                                  index); // 更新主界面购物车内容
                                            });
                                            setModalState(() {}); // 更新底部弹出框的内容
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
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  const Text('總共 NT\$',
                                      style: TextStyle(color: Colors.white)),
                                  Text(totalAmount.toString(),
                                      style: const TextStyle(
                                          color: Colors.white)),
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
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  print("點擊搜尋按鈕");
                }
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 35),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('通知'),
              onTap: () {
                // 可以添加通知的动作
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('設定'),
              onTap: () {
                // 点击 "设置" 时弹出密码对话框
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
                itemCount: displayedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 每行显示两个商品
                crossAxisSpacing: 10.0, // 方框之间水平距离
                mainAxisSpacing: 10.0, // 方框之间垂直距离
                childAspectRatio: 1.2, // 控制图片和文字的比例
              ),
              itemBuilder: (context, index) {
                var product = displayedProducts[index]; // 获取当前商品
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.white,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageDisplay(imageData: product['image']),
                        const SizedBox(height: 5),
                        Text(
                          product['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'NT\$ ${product['price']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addToCart(
                                product['name'], product['price']); // 添加到购物车
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0, // 按钮之间的水平间距
                runSpacing: 4.0, // 按钮之间的垂直间距
                children: typeOptions.map((type) {
                  return ElevatedButton(
                    onPressed: () {
                      _filterProductsByType(type);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTypes == type
                          ? Colors.yellow // 选中的按钮高亮显示
                          : Colors.white, // 未选中的按钮为蓝色
                      minimumSize: const Size(100, 40), // 按钮的最小尺寸
                    ),
                    child: Text(
                        type,
                     style: TextStyle(
                        color:Colors.black,
                        fontSize:16,
                     ),),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}