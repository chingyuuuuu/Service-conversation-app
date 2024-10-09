import 'package:flutter/material.dart';
import 'package:jkmapp/UI/widgets/client/TypeButton.dart';
import 'package:jkmapp/utils/SnackBar.dart';
import 'package:jkmapp/utils/diolog.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/services/products/loadingproducts.dart';
import 'package:jkmapp/UI/widgets/client/cart.dart';
import 'package:jkmapp/UI/widgets/client/ProductCard.dart';
import 'package:jkmapp/providers/Notification_Provider.dart';
import 'package:provider/provider.dart';


class Client extends StatefulWidget {
  @override
  ClientState createState() => ClientState();
}

class ClientState extends State<Client> {
  TextEditingController passwordController = TextEditingController();
  List<Map<String, dynamic>> products = []; // 儲存all prodcuts
  Map<String, List<Map<String, dynamic>>> categorizedProducts = {
  }; //按照types分類的商品
  List<Map<String, dynamic>> displayedProducts = []; //儲存介面上顯示的商品列表
  String selectedTypes = ''; //允許追蹤哪個按鈕被選中
  List<String>typeOptions = [];
  bool isServiceBellTapped = false;

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
      Map<String, List<Map<String, dynamic>>>categorized = {}; //按照types對商品進行分類
      Set<String> types = loadproducts.map((product) => product['type'] as String).toSet(); //儲存商品的types

      for (var type in types) { //遍歷all商品提取type類型
        //根據每個type，將屬於該類型的產品放入
        categorized[type] =
            loadproducts.where((product) => product['type'] == type).toList();
      }


      setState(() {
        products = loadproducts; //將產品放入這個表
        typeOptions = ['全部', ...types.toList()]; //將types保存到這個表
        categorizedProducts = categorized;
        displayedProducts = loadproducts; //預設顯示所有商品
      });
    } else {
      print('User ID not found');
    }
  }

  void _filterProductsByType(String type) {
    setState(() {
      selectedTypes = type;
      if (type == '全部') {
        displayedProducts = products; // 如果选择 "全部"，显示所有商品
      } else {
        displayedProducts = categorizedProducts[type] ?? []; // 否则显示对应类型的商品
      }
    });
  }


  void _resetServiceBell() {
    //設置1分鐘後恢復
    Future.delayed(Duration(minutes: 1), () {
      setState(() {
        isServiceBellTapped = false;
      });
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
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: IconButton(
              icon: const Icon(
                  Icons.shopping_cart,
                  color:Colors.black,
                  size: 30.0,
                ),
               onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return buildCartBottomSheet(context);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: IconButton(
              icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 30.0,
               ),
              onPressed: () {
                print("點擊搜尋按鈕");
              },
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
              leading: const Icon(Icons.receipt),
              title: const Text('訂單'),
              onTap: () {

              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.notifications,
                  color: isServiceBellTapped
                      ? Colors.yellow
                      : Colors.black), // 根据状态动态设置颜色),
              title: Text('服務鈴'),
              onTap: () {
                setState(() {
                  isServiceBellTapped = true;
                });
                _resetServiceBell();
                //通知dining
                Provider.of<NotificationProvider>(context, listen: false).pressServiceBell();
               //提示消息
                SnackBarutils.showSnackBar(context, '按下服務鈴', Colors.red);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('設定'),
              onTap: () {
                showPasswordDialog(context, passwordController);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TypeButtonList(
              typeOptions: typeOptions,
              selectedType: selectedTypes,
              onTypeSelected: _filterProductsByType,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: displayedProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 每行显示两个商品
                crossAxisSpacing: 10.0, // 方框之间水平距离
                mainAxisSpacing: 10.0, // 方框之间垂直距离
                childAspectRatio: 0.9, // 控制图片和文字的比例
              ),
              itemBuilder: (context, index) {
                return  ProudctCard(product: displayedProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}