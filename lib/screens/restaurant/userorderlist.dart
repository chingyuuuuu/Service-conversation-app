import 'package:flutter/material.dart';
import 'package:jkmapp/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/screens/restaurant/useroderdetail.dart';

class Userorderlist extends StatefulWidget{
   @override
   _UserorderlistState createState()=>_UserorderlistState();
}

class _UserorderlistState  extends State<Userorderlist> {
  Map<int, bool> _completedOrders = {};



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
          final int orderId = int.parse(order['order_id'].toString());
          final bool isCompleted = _completedOrders[orderId] ?? false;

          return GestureDetector(
            behavior: HitTestBehavior.translucent,//讓外層點擊事件不會攔截內部的inkwell
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('訂單 : ${order['order_id']}'),
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
                      // 圓圈按鈕，點擊後切換訂單完成狀態
                     InkWell(
                        onTap: () {
                          setState(() {
                            if (_completedOrders[orderId] == null) {
                              _completedOrders[orderId] = false;
                            }
                            // 切換完成狀態
                            _completedOrders[orderId] = !_completedOrders[orderId]!;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right:16.0),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey, width: 2),
                          ),
                          child: _completedOrders[orderId] == true
                              ? Icon(
                                    Icons.check, // 顯示打勾
                                    color: Colors.green, // 打勾顏色為綠色
                                    size: 24, // 打勾的大小
                               )
                              : SizedBox.shrink(), // 未完成時顯示空
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 訂單已送出提示
                  if (isCompleted)
                    Text(
                      '訂單已送出',
                      style: TextStyle(
                          fontSize: 16, color: Colors.green),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}