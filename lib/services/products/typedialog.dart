import 'package:flutter/material.dart';

//業者上傳type的對話服務
class DialogService {
  static Future<String?> showAddTypeDialog(BuildContext context, TextEditingController typeController, List<String> typeOptions, String? selectedType) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('加入類型'),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration: InputDecoration(
                  labelText: '輸入新類型',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF223888))),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedType,
                hint: Text('選擇已有類型'),
                isExpanded: true,
                dropdownColor: Colors.white,
                items: typeOptions.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) {
                  Navigator.of(context).pop(value); // 返回選中的值
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 關閉對話框
              },
              child: Text('取消',style: TextStyle(color:Colors.black)),
            ),
            TextButton(
              onPressed: () {
                if (typeController.text.isNotEmpty) {
                  Navigator.pop(context, typeController.text); // 返回輸入的文本
                }
              },
              child: Text('儲存',style: TextStyle(color:Colors.black)),
            ),
          ],
        );
      },
    );
  }
}