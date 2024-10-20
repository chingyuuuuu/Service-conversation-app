import 'package:flutter/material.dart';





// 密碼正確後的新頁面
class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<String> categories = ['類別1', '類別2'];
  List<QuestionForm> questionForms = [];

  void _addQuestionForm() {
    setState(() {
      questionForms.add(QuestionForm(
        categories: categories,
        onDelete: (index) {
          setState(() {
            questionForms.removeAt(index);
          });
        },
      ));
    });
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        String newCategory = '';
        return AlertDialog(
          title: const Text('新增類別'),
          content: TextField(
            onChanged: (value) {
              newCategory = value;
            },
            decoration: const InputDecoration(hintText: '請輸入類別名稱'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  categories.add(newCategory);
                });
                Navigator.of(context).pop();
              },
              child: const Text('加入'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service', style: TextStyle(fontSize: 30, fontFamily: 'Cursive')),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // 菜單按鈕操作
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questionForms.length,
                itemBuilder: (context, index) {
                  return questionForms[index];
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addQuestionForm, // 新增問題表單
            ),
          ],
        ),
      ),
    );
  }
}

// 表單元件
class QuestionForm extends StatefulWidget {
  final List<String> categories;
  final Function(int) onDelete;

  const QuestionForm({
    required this.categories,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  String? selectedCategory;
  String? imageUrl; // 用於存儲圖片 URL

  // 顯示輸入圖片連結的彈窗
  void _showImageDialog() {
    String tempUrl = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('輸入圖片連結'),
          content: TextField(
            onChanged: (value) {
              tempUrl = value;
            },
            decoration: const InputDecoration(hintText: '請輸入圖片的URL'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 取消操作
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  imageUrl = tempUrl; // 更新圖片URL
                });
                Navigator.of(context).pop(); // 確定操作並關閉彈窗
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // 新增類別的操作
                  },
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text('請選擇類別'),
                    items: widget.categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.onDelete(0); // 刪除該表單
                  },
                ),
              ],
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Q: 請輸入你的問題',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'A: 請輸入你的回答',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _showImageDialog, // 點擊圖片按鈕，顯示輸入圖片URL的彈窗
                ),
                const Text('圖片'),
              ],
            ),
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.network(imageUrl!), // 顯示輸入的圖片
              ),
          ],
        ),
      ),
    );
  }
}
