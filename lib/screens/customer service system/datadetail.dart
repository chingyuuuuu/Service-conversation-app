import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/QA_provider.dart';
import 'package:jkmapp/widgets/image_display.dart'; // Import ImageDisplay widget

class Datadetail extends StatefulWidget {
  final String qaId;
  final List<String> categories;

  const Datadetail({
    Key? key,
    required this.qaId,
    required this.categories,
  }) : super(key: key);

  @override
  DatadetailState createState() => DatadetailState();
}

class DatadetailState extends State<Datadetail> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  String? selectedCategory;
  dynamic imageData;

  @override
  void initState() {
    super.initState();
    _loadQAData();
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
        imageData = qa['image']; // 这可能是URL或图片字节
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
                value: selectedCategory,
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
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
                // 删除按钮放在左边
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
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }
}