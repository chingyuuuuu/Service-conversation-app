import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/QA/QA_provider.dart';
import 'package:jkmapp/widgets/image_display.dart'; // Import ImageDisplay widget
import 'package:jkmapp/utils/localStorage.dart';

  class Datadetail extends StatefulWidget {
  final String qaId;

  const Datadetail({
     Key? key,//可選的參數
     required this.qaId,//必須提供的參數
  }) : super(key: key);//將key傳遞給父類

  @override
  DatadetailState createState() => DatadetailState();
}

class DatadetailState extends State<Datadetail> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  String? selectedCategory;
  dynamic imageData;
  List<String> _typeOptions = [];

  @override
  void initState() {
    super.initState();
    _loadQAData();
    _loadSavedTypes();
  }

  Future<void> _loadSavedTypes() async {
    List<String> savedTypes = await StorageHelper.getDataTypes() ?? [];
    setState(() {
      _typeOptions = savedTypes;
    });
  }

  // 載入QA資料
  Future<void> _loadQAData() async {
    final qaProvider = Provider.of<QAprovider>(context, listen: false);
    final qa = await qaProvider.fetchQADataByQAid(widget.qaId);
    if (qa != null) {
      setState(() {
        _questionController.text = qa['question'];
        _answerController.text = qa['answer'];
        selectedCategory = qa['type'];
        imageData = qa['image'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final qaProvider = Provider.of<QAprovider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('編輯問答'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color:Colors.white,
              child: DropdownButton<String>(
                value: selectedCategory,//這裡顯示從後端載入的type
                items: _typeOptions.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;//更新選擇的type
                  });
                },
                dropdownColor: Colors.white,
                hint: const Text('選擇類別'),
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageDisplay(
                  imageData: imageData,
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _questionController,
                        decoration: const InputDecoration(labelText: '問題'),
                      ),
                      TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(labelText: '答案'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await qaProvider.deleteData(widget.qaId);
                    Navigator.pop(context, true); // 刪除後返回上一頁
                  },
                  child: const Text(
                      '刪除', style: TextStyle(color: Colors.red)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 25),
                ElevatedButton(
                  onPressed: () async {
                    await qaProvider.updateData(
                      qaId: widget.qaId.toString(),
                      question: _questionController.text,
                      answer: _answerController.text,
                      type: selectedCategory,
                      imageUrl: imageData, // 将当前图片数据传递回去
                    );
                    Navigator.pop(context); // 修改後返回上一頁
                  },
                  child: const Text(
                    '儲存',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {//釋放資源，防止memory洩漏
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }
}