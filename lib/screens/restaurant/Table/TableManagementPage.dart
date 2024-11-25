import 'package:flutter/material.dart';
import 'package:jkmapp/services/user/table_generate_service.dart';

class TableGeneratorPage extends StatefulWidget {
  @override
  _TableGeneratorPageState createState() => _TableGeneratorPageState();
}

class _TableGeneratorPageState extends State<TableGeneratorPage> {
  final TextEditingController _tableCountController = TextEditingController();
  List<Map<String, String>> tableData = [];
  @override
  void initState(){
    super.initState();
    _loadSavedTables();//加載已經保存的桌號
  }
  //加載
  void _loadSavedTables() async {
    List<Map<String, String>> savedTables = await TableGeneratorService.loadSavedTables();
    setState(() {
      tableData = savedTables;
    });
  }
  //保存
  void _saveGeneratedTables() {
    TableGeneratorService.saveGeneratedTables(tableData);
  }

  void _generateTables() {
    TableGeneratorService.generateTables(context, _tableCountController, (generatedTables) {
      setState(() {
        tableData = generatedTables;
      });
      _saveGeneratedTables();
    });
  }


  void _showQRCode(String tableNumber, String qrData) {
    TableGeneratorService.showQRCode(context, tableNumber, qrData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生成桌號'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tableCountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "請輸入桌號數量",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _generateTables,
                  child: Text("生成桌號", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: tableData.isEmpty
                  ? Center(child: Text("尚未生成任何桌號", style: TextStyle(color: Colors.black)))
                  : ListView.builder(
                itemCount: tableData.length,
                itemBuilder: (context, index) {
                  final table = tableData[index];
                  return ListTile(
                    title: Text(table["tableNumber"]!),
                    trailing: IconButton(
                      icon: Icon(Icons.qr_code),
                      onPressed: () => _showQRCode(table["tableNumber"]!, table["qrData"]!),
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
