import 'package:flutter/material.dart';
import 'package:jkmapp/providers/order_provider.dart';
import 'package:provider/provider.dart';

class RevenuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    final checkedOrders = orderProvider.todayorders.where((order) => order['check'] == true).toList();

    // 计算总收益
    final totalRevenue = checkedOrders.fold(0.0, (sum, order) => sum + (order['total_amount'] as double),);

    return Scaffold(
      appBar: AppBar(
        title: const Text('今日收益'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '今日收益總計: NT\$ ${totalRevenue.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              '已結帳訂單列表:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: checkedOrders.isEmpty
                  ? const Center(child: Text('今日無已結帳訂單'))
                  : ListView.builder(
                itemCount: checkedOrders.length,
                itemBuilder: (context, index) {
                  final order = checkedOrders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('訂單編號: ${order['order_id']}'),
                      subtitle: Text('桌號: ${order['table']}'),
                      trailing: Text('NT\$ ${order['total_amount']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
