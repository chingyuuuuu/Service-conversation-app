import 'package:flutter/material.dart';
import 'package:jkmapp/services/order/order_service.dart';

//客人可以看到的訂單細節

class OrderDetailPage extends StatelessWidget {
    final int orderId;
    OrderDetailPage({required this.orderId}){}

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('訂單詳情'),
        ),
        body: FutureBuilder(//異步處理資料
            future: OrderService.fetchOrderDetails(orderId),  //需要監聽的future: 調用 OrderService 中的 fetchOrderDetails
            builder: (context, snapshot) { //用於描述future的目前狀態
                if (snapshot.connectionState == ConnectionState.waiting) {//異步操作未完成，顯示加載中
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