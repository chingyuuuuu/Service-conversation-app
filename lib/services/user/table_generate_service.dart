import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:jkmapp/utils/DialogUtils.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;  // 適用於web
import 'package:flutter/rendering.dart';


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
      DialogUtils.showDialogWithMessage(context: context, title: "警告", message: "請輸入有效數字（1-50）",);
    }
  }

  static void showQRCode(BuildContext context, String tableNumber, String qrData) {
    if (qrData.isEmpty) {
      DialogUtils.showDialogWithMessage(context: context, title: "錯誤", message: "無效的 QR Code 數據",);
      return;
    }
    //藉由將repaintBoundary包裹在對話框中，並使用Globalkey去渲染qrcode視圖
    final GlobalKey repaintBoundaryKey = GlobalKey();

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
              RepaintBoundary(
                  key:repaintBoundaryKey,
                  child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 320.0,
                  ),
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
            onPressed: () => saveQRCodeToGallery(repaintBoundaryKey), // 保存二维码到相册
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

  static Future<void> saveQRCodeToGallery(GlobalKey key) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final context = key.currentContext;
      if (context == null) {
        print("QRView context is null");
        return;
      }
      try {
        final RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3.0);

        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) {
          print("Failed to convert image to byte data");
          return;
        }

        final buffer = byteData.buffer.asUint8List();

        final blob = html.Blob([buffer]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = 'QRCode.png';
        anchor.click();
        html.Url.revokeObjectUrl(url);
      } catch (e) {
        print("保存失败: $e");
      }
    });
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
