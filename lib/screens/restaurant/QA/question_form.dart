import 'package:flutter/material.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:provider/provider.dart';
import 'package:jkmapp/providers/QA/QA_provider.dart';
import 'package:jkmapp/services/products/typedialog.dart';

class QuestionForm extends StatefulWidget {
  final List<String> categories;

  const QuestionForm({
    required this.categories,
    Key? key,
  }) : super(key: key);

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  String? selectedCategory;
  TextEditingController _typeController = TextEditingController();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  List<String> _typeOptions = [];


  @override
  void initState() {
    super.initState();
    _loadSavedTypes();
  }


  Future<void> _loadSavedTypes() async {
    List<String> savedTypes = await StorageHelper.getDataTypes() ?? [];
    setState(() {
      _typeOptions = savedTypes;
    });
  }

  // 暫存
  Future<void> _saveTypes() async {
    await StorageHelper.saveDataTypes(_typeOptions);
  }


  void _showAddTypeDialog() async {
    String? newType = await DialogService.showAddTypeDialog(
      context,
      _typeController,
      _typeOptions,
      selectedCategory,
    );

    if (newType != null && newType.isNotEmpty) {
      setState(() {
        if (!_typeOptions.contains(newType)) {
          _typeOptions.add(newType); // 加入新類型
          _saveTypes(); // 暫存
        }
      });
    }
  }
  //儲存問答數據
  void saveData()async{
    final qaProvider = Provider.of<QAprovider>(context, listen: false);
    bool isSaved = await qaProvider.savedata(
      question: _questionController.text,
      answer: _answerController.text,
      type: selectedCategory,
    );
    if (isSaved) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qaProvider = Provider.of<QAprovider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('問答表單'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _showAddTypeDialog(); // 對話
                  },
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text('請選擇類別'),
                    dropdownColor: Colors.white,
                    items: _typeOptions.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {//組件的值變更時觸發
                      selectedCategory = value;
                    }),
                  ),
                ),
              ],
            ),
            // 問題輸入框
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Q: 請輸入你的問題',
                labelStyle: TextStyle(color: Color(0xFF223888)),
              ),
            ),
            // 回答輸入框
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'A: 請輸入你的回答',
                labelStyle: TextStyle(color: Color(0xFF223888)),
              ),
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                qaProvider.pickImage(); // 調用選擇圖片的邏輯
              },
              child: Row(
                children: [
                  const Icon(Icons.photo),
                  const SizedBox(width: 10),
                  Text(qaProvider.selectedImageBytes != null ? '已選擇圖片' : '圖片'), // 使用 qaProvider 的图片状态
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: (){
                 saveData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF36FDE6),
              ),
              child: const Text(
                '儲存',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}