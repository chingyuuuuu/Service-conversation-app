import 'package:flutter/material.dart';
import 'package:jkmapp/services/order/order_service.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/cart_provider.dart';
import'package:jkmapp/utils/SnackBar.dart';



Widget buildCartBottomSheet(BuildContext context) {
  final cartProvider = Provider.of<CartProvider>(context); // 獲取購物車狀態
  final String tableNumber='A1';
  //打包成products傳遞給後端
  final List<Map<String, dynamic>> products = cartProvider.cartItems.map((item) {
    return {
      'product_id': item['product_id'],
      'quantity': item['quantity']
    };
  }).toList();  // 提取每個商品的 product_id 和 quantity
  final double totalAmount=cartProvider.totalAmount;

  return Container(
    color: Colors.white,
    child: Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft, // 將A1對齊到左邊
              child: Padding(
                padding: const EdgeInsets.only(left:16.0),
                child: Text(
                  tableNumber,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded( // 讓購物車清單在中間位置
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '購物車清單',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
           const SizedBox(height: 10),
           Expanded(
           child: ListView.builder(
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  cartProvider.cartItems[index]['item'],
                  style: const TextStyle(fontSize:16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //減少數量按鈕
                    IconButton(
                      icon:const Icon(Icons.remove),
                      onPressed: (){
                         cartProvider.decreaseQuantiy(index);
                      },
                    ),
                    //顯示數量
                    Text(
                      '${cartProvider.cartItems[index]['quantity']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    //增加數量按鈕
                    IconButton(
                      icon:const Icon(Icons.add),
                      onPressed: (){
                        cartProvider.increaseQuantity(index);
                      },
                    ),
                    //顯示價格
                    Text(
                        'NT\$ ${cartProvider.cartItems[index]['price']}',
                         style: const TextStyle(fontSize:16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        cartProvider.removeFromCart(index); // 移除购物车中的商品
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10), // 添加间距
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                  )),
              Text(
                'NT\$ ${cartProvider.totalAmount.toString()}',
                 style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height:10),
        Center(
           child:ElevatedButton(
          onPressed: () async{
           bool success =await OrderService.saveOrder(tableNumber,products, totalAmount);
            if(success){
              cartProvider.clearCart();
              Navigator.pop(context);
              SnackBarutils.showSnackBar(context, "下單成功", Colors.green);
            }else{
              SnackBarutils.showSnackBar(context, "下單失敗", Colors.red);

            }


          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(200,40),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
          child: const Text(
            '下單',
            style: TextStyle(color: Colors.white, fontSize: 18),
             ),
           ),
       ),
       const  SizedBox(height: 20),
     ],
    ),
  );
}
