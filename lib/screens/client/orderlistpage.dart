import 'package:flutter/material.dart';
import 'package:jkmapp/providers/order_provider.dart';
import 'package:provider/provider.dart';
import'package:jkmapp/screens/client/orderdetailpage.dart';

class Orderlistpage extends StatelessWidget {
  String tableNumber='A1';
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('訂單列表'),
      ),
      body: orderProvider.isLoading
          ? Center(child: CircularProgressIndicator()) // 顯示加載指示器
          : orderProvider.orders.isEmpty
          ? Center(child: Text('尚未加入訂單')) // 如果沒有訂單，顯示提示
          : ListView.builder(
        itemCount: orderProvider.orders.length,
        itemBuilder: (context, index) {
          final order = orderProvider.orders[index];
           return ListTile(
            title: Text('訂單 : ${order['order_id']}'),
            subtitle: Text('總額: ${order['total_amount']}'),
            trailing: Text('創建時間: ${order['created_at']}'),
          onTap:(){
            final int? orderId = int.tryParse(order['order_id'].toString());
            if (orderId != null) {
                Navigator.push(context,MaterialPageRoute(builder: (context) => OrderDetailPage(orderId: orderId),  // 傳遞 orderId 到下一頁
                ),
               );
            } else {
                print('Error: Invalid orderId');
              }
            },

          );
        },
      ),
    );
  }
}