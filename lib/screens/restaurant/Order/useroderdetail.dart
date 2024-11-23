import 'package:flutter/material.dart';
import 'package:jkmapp/services/order/order_service.dart';


class Userorderdetail extends StatelessWidget {
  final int orderId;
  Userorderdetail({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('訂單詳情'),
      ),
      body: FutureBuilder(
        future: OrderService.fetchOrderDetails(orderId),  // 調用 OrderService 中的 fetchOrderDetails
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // 顯示加載中指示器
          } else if (snapshot.hasError) {
            return Center(child: Text('獲取訂單失敗'));  // 顯示錯誤信息
          } else {
            final orderDetails = snapshot.data as Map<String, dynamic>;
            final products = orderDetails['products'] as List<dynamic>;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product['product_name']),
                  subtitle: Text('數量: ${product['quantity']}'),
                  trailing: Text('價格: ${product['price']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}