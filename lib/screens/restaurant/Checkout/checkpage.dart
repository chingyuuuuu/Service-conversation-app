import 'package:flutter/material.dart';
import 'package:jkmapp/providers/restaurant/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/screens/restaurant/Order/useroderdetail.dart';
import 'package:jkmapp/routers/app_routes.dart';

/*
結帳功能-如果點選結帳按鈕可以將check更改為true已經結帳
收益功能-統計今日所有結帳訂單的金額加總
 */
class Checkpage extends StatefulWidget {
  @override
  _CheckpageState createState() => _CheckpageState();
}

class _CheckpageState extends State<Checkpage> {
  @override
  void initState() {
    super.initState();
    _fetchTodayOrders();
  }

  void _fetchTodayOrders() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final today = DateTime.now().toIso8601String().split('T')[0]; // 格式化
    orderProvider.fetchordersByDate(date: today); //獲取今天訂單
  }

  void _markOrderAsChecked(BuildContext context, int orderId) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.markOrderAsChecked(orderId).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('訂單已結帳成功!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('結帳失敗，請稍後重試!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final todayOrders = orderProvider.todayorders; // 拿到今日的訂單
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日訂單'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, Routers.order_history);
            },
          ),
          IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: () {
              Navigator.pushNamed(context, Routers.RevenuePage);
            },
          )
        ],
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : todayOrders.isEmpty
          ? const Center(child: Text('今日無訂單'))
          : ListView.builder(
        itemCount: todayOrders.length,
        itemBuilder: (context, index) {
          final order = todayOrders[index];
          final int orderId = int.parse(order['order_id'].toString());
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Userorderdetail(orderId: orderId),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('訂單編號: ${order['order_id']}'),
                  Text('桌號: ${order['table']}'),
                  Text('總金額: NT\$ ${order['total_amount']}'),
                  Text('創建時間: ${order['created_at']}'),
                  Text(
                    '結帳狀態: ${order['check'] == true ? '已結帳' : '未結帳'}',
                    style: TextStyle(
                      color: order['check'] == true
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!order['check'])
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _markOrderAsChecked(context, orderId);
                      },
                      child: const Text(
                        '結帳',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
