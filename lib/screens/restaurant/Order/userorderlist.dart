import 'package:flutter/material.dart';
import 'package:jkmapp/providers/restaurant/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/screens/restaurant/Order/useroderdetail.dart';
import 'package:jkmapp/providers/restaurant/remark_provider.dart';
import 'package:jkmapp/routers/app_routes.dart';

//店家可以看到今天的訂單
class UserOrderList extends StatefulWidget {
  @override
  _UserOrderListState createState() => _UserOrderListState();
}

class _UserOrderListState extends State<UserOrderList> {
  Map<int, bool> _completedOrders = {};

  @override
  void initState(){
     super.initState();
     _fetchTodayOrders();
  }

  void _fetchTodayOrders(){ //加載今日訂單
     final orderProvider = Provider.of<OrderProvider>(context, listen: false);
     final today = DateTime.now().toIso8601String().split('T')[0]; //格式化
     orderProvider.fetchordersByDate(date: today);
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final remarkProvider = Provider.of<RemarkProvider>(context, listen: true);
    final uncheckOrders=orderProvider.todayorders.where((order)=>order['check']==false).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日店家訂單列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, Routers.order_history);
            },
          ),
        ],
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : uncheckOrders.isEmpty
          ? const Center(child: Text('今日尚未加入訂單'))
          : ListView.builder(
        itemCount: uncheckOrders.length,
        itemBuilder: (context, index) {
          final order = uncheckOrders[index];
          final int orderId = int.parse(order['order_id'].toString());
          final bool isCompleted = _completedOrders[orderId] ?? false;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,//透明，將事件傳給子組件
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Userorderdetail(orderId: orderId),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 訂單信息
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('訂單: ${order['order_id']}'),
                            Text('桌號: ${order['table']}'),
                            Text('總額: NT\$ ${order['total_amount']}'),
                            Text('創建時間: ${order['created_at']}'),
                            if (remarkProvider.isRemarkEnabled &&
                                order['remark'] != null &&
                                order['remark'].isNotEmpty)
                              Text('備註: ${order['remark']}'),
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
                      ),
                      // 圓圈按鈕
                      InkWell(
                        onTap: () {
                          setState(() {
                            _completedOrders[orderId] =
                            !(_completedOrders[orderId] ?? false);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 16.0),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey, width: 2),
                          ),
                          child: _completedOrders[orderId] == true
                              ? const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 24,
                              )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 訂單已送出提示
                  if (isCompleted)
                    const Text(
                      '訂單已送出',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
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

