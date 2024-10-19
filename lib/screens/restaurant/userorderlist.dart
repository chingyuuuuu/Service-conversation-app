import 'package:flutter/material.dart';
import 'package:jkmapp/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/screens/restaurant/useroderdetail.dart';

class Userorderlist extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('店家訂單列表'),
      ),
      body: orderProvider.isLoading
          ? Center(child: CircularProgressIndicator()) // 顯示加載指示器
          : orderProvider.orders.isEmpty
          ? Center(child: Text('尚未加入訂單')) // 如果沒有訂單，顯示提示
          : ListView.builder(
        itemCount: orderProvider.orders.length,
        itemBuilder: (context, index) {
          final order = orderProvider.orders[index];
          return Container(
            margin: const EdgeInsets.symmetric(
                vertical: 8.0,horizontal: 16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(12),
              border:Border.all(color:Colors.grey,width:1),
            ),
            child: ListTile(
              title: Text('訂單 : ${order['order_id']}'),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Text('桌號 ${order['table']}'),
                        Text('總額: NT\$ ${order['total_amount']}'),
                        Text('創建時間: ${order['created_at']}'),
                        Text(
                      '結帳狀態: ${order['check'] == true ? '已結帳' : '未結帳'}',
                      style: TextStyle(
                        color: order['check'] == true
                            ? Colors.green
                            : Colors.red,
                       ),
                      ),
                  ],
              ),
              onTap:(){
                final int? orderId = int.tryParse(order['order_id'].toString());
                if (orderId != null) {
                  Navigator.push(context,MaterialPageRoute(builder: (context) =>Userorderdetail(orderId: orderId),  // 傳遞 orderId 到下一頁
                   ),
                  );
                } else {
                  print('Error: Invalid orderId');
                }
              },
            ),

          );
        },
      ),
    );
  }
}