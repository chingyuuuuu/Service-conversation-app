import 'package:flutter/material.dart';
import 'package:jkmapp/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/screens/restaurant/useroderdetail.dart';
import 'package:jkmapp/providers/remark_provider.dart';
import 'package:jkmapp/routers/app_routes.dart';
import 'package:jkmapp/utils/diolog.dart';

class Userorderlist extends StatefulWidget{
   @override
   _UserorderlistState createState()=>_UserorderlistState();
}

class _UserorderlistState  extends State<Userorderlist> {
  Map<int, bool> _completedOrders = {};

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final remarkProvider = Provider.of<RemarkProvider>(context, listen: true);
    final activeOrders=orderProvider.orders.where((order)=>order['is_active']==true).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('店家訂單列表'),
        actions: [
           IconButton(
              icon:Icon(Icons.history),
              onPressed: (){
                  Navigator.pushNamed(context,Routers.order_history);
              },
           ),
          Padding(
            padding: const EdgeInsets.only(right:16.0),
            child:IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
                showConfirmationDialog(context);
            },
          ),
          ),
        ],
      ),
      body: orderProvider.isLoading
          ? Center(child: CircularProgressIndicator()) // 顯示加載指示器
          : activeOrders.isEmpty
          ? Center(child: Text('尚未加入訂單')) // 如果沒有訂單，顯示提示
          : ListView.builder(
        itemCount: activeOrders.length,
        itemBuilder: (context, index) {
          final order = activeOrders[index];
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
                          if( remarkProvider.isRemarkEnabled&&order['remark']!=null&&order['remark'].isNotEmpty)
                            Text('備註:${order['remark']}'),
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