import 'package:flutter/material.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/routers/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/QA_provider.dart';
import 'package:jkmapp/screens/customer service system/question_form.dart';
import 'package:jkmapp/screens/customer service system/datadetail.dart';

class CustomerData extends StatefulWidget {
  const CustomerData({super.key});

  @override
  CustomerDataState createState() => CustomerDataState();
}

class CustomerDataState extends State<CustomerData> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _loadDataTypes();
    final qaProvider = Provider.of<QAprovider>(context, listen: false);
    qaProvider.fetchQAData(); // 載入qa
  }

  // 載入types
  Future<void> _loadDataTypes() async {
    List<String>? savedCategories = await StorageHelper.getDataTypes();
    if (savedCategories != null) {
      setState(() {
        categories = savedCategories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final qaProvider = Provider.of<QAprovider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('客服資料庫', style: TextStyle(fontSize: 30)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, Routers.customer);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            qaProvider.qaList.isEmpty
                ? const Center(child: Text('沒有已建立的問答'))
                : Expanded(
              child: ListView.builder(
                itemCount: qaProvider.qaList.length,
                itemBuilder: (context, index) {
                  final qa = qaProvider.qaList[index];
                  final qaId = qa['qaId']; // 獲取qaid
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF223888)), // 藍色外框
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      title: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "Q: ",
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Color(0xFF223888),
                              ),
                            ),
                            TextSpan(
                              text: qa['question'],
                              style: const TextStyle(
                                  fontSize: 25.0,
                                  color:Color(0xFF223888),
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "A: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: qa['answer'],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Datadetail(
                                  qaId: qaId.toString(),
                                  categories: categories,
                                ),
                          ),
                        );
                        if (result == true) {
                          qaProvider.fetchQAData(); // 重新加载QA数据
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white, // 设置浮动按钮背景为白色
        child: const Icon(Icons.add, color: Colors.black), // 图标设置为黑色
        onPressed: () async {
          // 按下 + 导航到 QuestionForm 页面
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QuestionForm(
                    categories: categories,
                  ),
            ),
          );
          if (result) {
            final qaProvider = Provider.of<QAprovider>(context, listen: false);
            qaProvider.fetchQAData();
          }
        },
      ),
    );
  }
}