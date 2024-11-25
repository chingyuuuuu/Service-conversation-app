import 'package:flutter/material.dart';
import 'dart:typed_data';//用於處理unit8list
import 'dart:io';//用於處理file
import 'package:flutter/foundation.dart' show kIsWeb;

//

class ImageDisplay extends StatelessWidget {
  final dynamic imageData; // 接收圖片data
  final double width;
  final double height;

  const ImageDisplay({
    Key? key,
    required this.imageData,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Web
    if (imageData == null) {
      return _buildPlaceholder(); // 如果 imageData 為 null，顯示佔位符
    }

    if (kIsWeb) {
      if (imageData is Uint8List) {
        return Image.memory(imageData, width: width, height: height, fit: BoxFit.cover);
      } else if (imageData is String) {
        return Image.network(imageData, width: width, height: height, fit: BoxFit.cover);
      } else {
        return _buildPlaceholder();
      }
    } else {
      // App
      if (imageData is Uint8List) {
        return Image.memory(imageData, width: width, height: height, fit: BoxFit.cover);
      } else if (imageData is String) {
        return Image.file(File(imageData), width: width, height: height, fit: BoxFit.cover);
      } else if (imageData is File) {
        return Image.file(imageData, width: width, height: height, fit: BoxFit.cover);
      } else {
        return _buildPlaceholder();
      }
    }
  }

  //如果沒有上傳圖片
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.image, size: 100, color: Colors.grey),
    );
  }
}
