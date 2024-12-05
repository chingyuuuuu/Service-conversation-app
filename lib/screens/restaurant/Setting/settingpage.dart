import 'package:flutter/material.dart';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/providers/restaurant/remark_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget{
  final VoidCallback onSave;//回調函數
  SettingsPage({required this.onSave});//接受回調函數

  @override
  SettingsPageState createState() =>SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  TextEditingController _storeNameController =TextEditingController();
  TextEditingController _passwordController =TextEditingController();

  String? storeName;
  String? password;

  @override
  void initState() {
    super.initState();
    _loadInitialValues();//加載保存的設置
  }

  //用於從sharedpreferences加載儲存的值
  void _loadInitialValues() async {
    String? storedName = await StorageHelper.getStoreName();
    String? storedPassword = await StorageHelper.getPassword();

    setState(() {
      _storeNameController.text = storedName ?? '店家';
      _passwordController.text = storedPassword ?? '123456';
    });
  }

  @override
  Widget build(BuildContext context) {
    final remarkProvider = Provider.of<RemarkProvider>(context);//有無開啟remark

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("設定"),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black), // 更改圖標顏色以適應白色背景
          onPressed: () {
            Navigator.pop(context); // 返回上一頁
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xFF223888),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 40),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _storeNameController, // 必須設置 controller
                      decoration: InputDecoration(
                        labelText: '店家名稱',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.password, size: 40),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: '後臺密碼',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height:10),
              Row(
                 children: [
                     Icon(Icons.note_alt,size:40),
                     SizedBox(width: 10),
                     Text(
                        "開啟備註",
                         style:TextStyle(fontSize: 18),
                     ),
                    Spacer(),
                    Switch(
                        value: remarkProvider.isRemarkEnabled,
                        onChanged: (value)async{
                           await remarkProvider.saveRemarkStatus(value);//儲存備註的狀態
                       },
                    )
                 ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {//保存更改的資料到本地
                  await  StorageHelper.saveStoreName(_storeNameController.text);//用await直到future完成並返回結果
                  await   StorageHelper.savePassword(_passwordController.text);
                  widget.onSave(); // 调用回调函数，通知已經保存完成
                  Navigator.pop(context,true);//使用這個來實現主頁和設定頁面同步
                },
                child: Text('儲存'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF36FDE6),
                  foregroundColor: Colors.black,
                  minimumSize: Size(150, 50),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}