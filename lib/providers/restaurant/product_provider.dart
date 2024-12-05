import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';//用於web
import 'package:image_picker/image_picker.dart';//用於app
import 'package:flutter/foundation.dart' show kIsWeb;//用於判斷是否為web環境
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/services/products/saveproduct_service.dart';
import 'package:jkmapp/services/products/typedialog.dart';
import 'package:jkmapp/services/products/loadingproducts.dart';

class ProductProvider with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  Map<String, dynamic>? _productDetails;//保存加載到的商品資訊
  List<String> _typeOptions = [];//儲存已有的類型
  String? selectedType;
  Uint8List? selectedImageBytes;//儲存圖片二進位(web)
  io.File? selectedImageFile;//用於儲存圖片文件(app)
  String? imageFileName;

  final SaveProductService _saveProductService = SaveProductService();

  Map<String, dynamic>? get productDetails => _productDetails;
  List<String> get typeOptions => _typeOptions;
  //載入商品詳情
  Future<void> loadProductDetails(BuildContext context, int productId) async {
    final product = await ProductService.loadProductDetails(context, productId);
    if (product != null) {
      _productDetails = product;

      // 初始化 TextEditingController
      nameController.text = product['name'];
      typeController.text = product['type'];
      priceController.text = product['price'].toString();
      costController.text = product['cost'].toString();
      quantityController.text = product['quantity'].toString();

      notifyListeners();
    }
  }

  //更新商品
  Future<void> updateProduct(BuildContext context, int productId) async {
    await ProductService.updateProduct(
      context,
      productId,
      nameController.text,
      typeController.text,
      double.parse(priceController.text),
      double.parse(costController.text),
      int.parse(quantityController.text),
    );
    notifyListeners();
  }
  //刪除商品
  Future<void> deleteProduct(BuildContext context, int productId) async {
    bool isDeleted = await ProductService.deleteProduct(context, productId);
    if (isDeleted) {
      _productDetails = null; // 清除已刪除的產品數據
      notifyListeners();
      Navigator.pop(context, 'delete'); // 返回上一頁並標記刪除成功
    }
  }


  //載入以儲存的type
  void loadTypes() async {
    List<String> types = await StorageHelper.getTypes();
    _typeOptions = types;
    notifyListeners();
  }
  //當新增類型時儲存到sharedPrferences
  void saveTypes() async {
    await StorageHelper.saveTypes(_typeOptions);
  }

  Future<void> showAddTypeDialog(BuildContext context) async {
    String? newType = await DialogService.showAddTypeDialog(
      context,
      typeController,
      _typeOptions,
      selectedType,
    );

    if (newType != null && newType.isNotEmpty) {
      if (!_typeOptions.contains(newType)) {
        _typeOptions.add(newType);
        saveTypes();
        notifyListeners();
      }
    }
  }

  //處理團片上傳(web and app通用)
  Future<void> pickImage() async {
    if (kIsWeb) {
      // Web 圖片選擇
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.first.bytes != null) {
        selectedImageBytes = result.files.first.bytes;
        imageFileName = result.files.first.name;
        notifyListeners();
      }
    } else {
      // App 圖片選擇
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        selectedImageFile = io.File(image.path);
        selectedImageBytes = bytes;
        imageFileName = image.name;
        notifyListeners();
      }
    }
  }

  Future<void> saveProduct(BuildContext context) async {
    await _saveProductService.saveProduct(
      context: context,
      nameController: nameController,
      typeController: typeController,
      priceController: priceController,
      costController: costController,
      quantityController: quantityController,
      selectedImageBytes: selectedImageBytes,
      selectedImageFile: selectedImageFile,
      imageFileName: imageFileName,
    );
  }

  //重置狀態
  void reset() {
    nameController.clear();
    typeController.clear();
    priceController.clear();
    costController.clear();
    quantityController.clear();
    selectedImageBytes = null;
    selectedImageFile = null;
    imageFileName = null;
    notifyListeners();
  }



}
