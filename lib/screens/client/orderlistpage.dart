import 'package:flutter/material.dart';
import 'package:jkmapp/providers/restaurant/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/screens/client/orderdetailpage.dart';

//客人可以看到的訂單-依照今天日期去篩選，再依照桌號和未結帳狀態去篩選

class Orderlistpage extends StatefulWidget {
  final String tableNumber;
  Orderlistpage({required this.tableNumber});

  @override
  _OrderlistpageState createState() => _OrderlistpageState();
}

class _OrderlistpageState extends State<Orderlistpage> {
  @override
  void initState() {
    super.initState();
    // 頁面初始化
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final today = DateTime.now().toIso8601String().split('T')[0]; // 獲取今天日期
    orderProvider.fetchordersByDate(date: today); // 獲取今天訂單
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    // 篩選
    final filteredOrders = orderProvider.todayorders.where((order) => order['table'].toString() == widget.tableNumber && order['check'] == false).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('訂單列表'),
      ),
      body: orderProvider.isLoading
          ? Center(child: CircularProgressIndicator()) // 顯示加載指示器
          : filteredOrders.isEmpty
          ? Center(child: Text('尚未加入訂單'))
          : ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return ListTile(
            title: Text('訂單 : ${order['order_id']}'),
            subtitle: Text('總額: ${order['total_amount']}'),
            trailing: Text('創建時間: ${order['created_at']}'),
            onTap: () {
              final int? orderId = int.tryParse(order['order_id'].toString());
              if (orderId != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(orderId: orderId),
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
