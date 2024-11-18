// table_generator_service.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:jkmapp/utils/DialogUtils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';



class TableGeneratorService {
  static void generateTables(BuildContext context, TextEditingController tableCountController,
      Function(List<Map<String, String>>) onGenerate) {
    final int? count = int.tryParse(tableCountController.text);
    FocusScope.of(context).unfocus(); // 隐藏键盘
    if (count != null && count > 0 && count <= 50) {
      List<Map<String, String>> tableData = List.generate(count, (index) {
        final tableNumber = "table${index + 1}";
        final qrData = "http://127.0.0.1:5000/Client?table=$tableNumber";
        return {
          "tableNumber": tableNumber,
          "qrData": qrData,
        };
      });
      onGenerate(tableData);
      tableCountController.clear();
    } else {
      DialogUtils.showDialogWithMessage(
        context: context,
        title: "警告",
        message: "請輸入有效數字（1-50）",
      );
    }
  }

  static void showQRCode(BuildContext context, String tableNumber, String qrData) {
    if (qrData.isEmpty) {
      DialogUtils.showDialogWithMessage(
        context: context,
        title: "錯誤",
        message: "無效的 QR Code 數據",
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("$tableNumber 的 QR Code"),
        content: SizedBox(
          width: 320.0,
          height: 400.0,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 320.0,
                ),
                SizedBox(height: 10),
                Text(qrData, style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => saveQRCodeToGallery(qrData), // 保存二维码到相册
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
            child: Text("關閉", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  static Future<void> saveQRCodeToGallery(String qrData) async {
    if (qrData.isEmpty) return;

    try {
      final directory = await getExternalStorageDirectory();
      final path = directory?.path;
      final qrValidationImage = await QrPainter(
        data: qrData,
        version: QrVersions.auto,
      ).toImage(320.0);
      final bytes = await qrValidationImage.toByteData(format: ui.ImageByteFormat.png);
      final imageFile = File('$path/QRCode.png');
      await imageFile.writeAsBytes(bytes!.buffer.asUint8List());

      //保存到本地
      final result = await ImageGallerySaver.saveFile(imageFile.path);
      if (result != null) {
        print("QRcode已經保存");
      } else {
        print("保存失敗");
      }
    } catch (e) {
      print("保存QRcode失敗: $e");
    }
  }
  //加載已經保存的桌號
  static Future<List<Map<String, String>>> loadSavedTables() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedTableData = prefs.getStringList('generatedTables');
    if (savedTableData != null && savedTableData.isNotEmpty) {
      return savedTableData.map((item) {
        final parts = item.split(',');
        return {'tableNumber': parts[0], 'qrData': parts[1]};
      }).toList();
    }
    return []; // 如果沒有返回空的
  }
  //保存生成的桌號
  static Future<void> saveGeneratedTables(List<Map<String, String>> tableData) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tableDataToSave = tableData
        .map((table) => '${table['tableNumber']},${table['qrData']}')
        .toList();
    await prefs.setStringList('generatedTables', tableDataToSave);
  }



}
