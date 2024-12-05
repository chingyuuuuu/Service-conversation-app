import 'package:flutter/material.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/QA/QA_provider.dart';
import 'package:jkmapp/screens/restaurant/QA/question_form.dart';
import 'package:jkmapp/screens/restaurant/QA/datadetail.dart';

class restaurantData extends StatefulWidget {
  const restaurantData({super.key});

  @override
  restaurantDataState createState() =>restaurantDataState();
}

class restaurantDataState extends State<restaurantData> {
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              '客服資料庫',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
              ),
            ),
            floating: true,
            pinned: true,
            //加入右邊按鈕
            actions: [
               IconButton(
                  icon:const Icon(Icons.question_mark_outlined,color:Colors.black),
                  tooltip: '未解答的問題',
                  onPressed: (){
                     Navigator.pushNamed(context,  '/UnansweredQuestions');
                  },
               )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (qaProvider.qaList.length < 10)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: const Text(
                        '請至少加入10筆資料才可以啟用問答系統',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
          qaProvider.qaList.isEmpty
              ? SliverToBoxAdapter(
            child: Center(child: Text('沒有已建立的問答')),
           )
            : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                  final qa = qaProvider.qaList[index];
                  final qaId = qa['qaId'];
                  return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF223888)),
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
                              color: Color(0xFF223888),
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
                          builder: (context) => Datadetail(
                            qaId: qaId.toString(),
                          ),
                        ),
                      );
                      if (result == true) {
                        qaProvider.fetchQAData();
                      }
                    },
                  ),
                );
              },
              childCount: qaProvider.qaList.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionForm(
                categories: categories,
              ),
            ),
          );
          if (result == true) {
            final qaProvider = Provider.of<QAprovider>(context, listen: false);
            qaProvider.fetchQAData();//載入數據
          }
        },
      ),
    );
  }
}