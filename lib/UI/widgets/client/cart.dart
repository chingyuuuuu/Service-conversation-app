import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/cart_provider.dart'; //





Widget buildCartBottomSheet(BuildContext context) {
  final cartProvider = Provider.of<CartProvider>(context); // 獲取購物車狀態
  return Container(
    color: Colors.white,
    child: Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          '購物車清單',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cartProvider.cartItems[index]['item']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('NT\$ ${cartProvider.cartItems[index]['price']}'),
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
          color: Colors.blueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('總共 NT\$',
                  style: TextStyle(color: Colors.white)),
              Text(
                cartProvider.totalAmount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height:10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
         children: [
           ElevatedButton(
          onPressed: () {
            // 此处实现下定逻辑
            print("下定成功");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(40,40),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
          child: const Text(
            '下單',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
           const SizedBox(height: 30),
         ],
    ),
    ],
    ),
  );
}
