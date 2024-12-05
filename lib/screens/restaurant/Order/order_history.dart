import 'package:flutter/material.dart';
import 'package:jkmapp/providers/restaurant/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/screens/restaurant/Order/useroderdetail.dart';
import 'package:jkmapp/providers/restaurant/remark_provider.dart';


class orderHistory extends StatefulWidget{
  @override
  _orderHistoryState createState()=>_orderHistoryState();
}

class _orderHistoryState  extends State<orderHistory> {

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final remarkProvider = Provider.of<RemarkProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('歷史訂單'),
      ),
      body: orderProvider.isLoading
          ? Center(child: CircularProgressIndicator()) // 顯示加載指示器
          : orderProvider.allorders.isEmpty
          ? Center(child: Text('尚未加入訂單')) // 如果沒有訂單，顯示提示
          : ListView.builder(
        itemCount: orderProvider.allorders.length,
        itemBuilder: (context, index) {
          final order = orderProvider.allorders[index];
          final int orderId = int.parse(order['order_id'].toString());
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
                          if( remarkProvider.isRemarkEnabled&&order['remark']!=null&&order['remark'].isNotEmpty)
                            Text('備註:${order['remark']}'),
                          Text('結帳狀態: ${order['check'] == true ? '已結帳' : '未結帳'}',
                            style: TextStyle(
                              color: order['check'] == true
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                ],
             ),
           ]
          )
          ),
          );
        },
      ),
    );
  }
}