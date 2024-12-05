import 'package:flutter/material.dart';
import 'package:jkmapp/providers/restaurant/order_provider.dart';
import 'package:provider/provider.dart';

class RevenuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return FutureBuilder(
      future: orderProvider.fetchordersByDate(date: DateTime.now().toIso8601String().split('T')[0]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('今日收益')),
            body: const Center(child: Text('加載數據錯誤，請稍後再試')),
          );
        }

        final checkedOrders = orderProvider.todayorders.where((order) => order['check'] == true).toList();
        final totalRevenue = checkedOrders.fold<double>(0.0, (sum, order) {final amount = double.tryParse(order['total_amount']) ?? 0.0;
            return sum + amount;
          },
        );
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
                  style: const TextStyle(fontSize: 40, color: Colors.green),
                ),
                const SizedBox(height: 20),
                const Text('已結帳訂單列表:', style: TextStyle(fontSize: 16),
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
                        color:Colors.white,
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
      },
    );
  }
}
