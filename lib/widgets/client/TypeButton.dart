import 'package:flutter/material.dart';

/*
 客人page中顯示的分類餐點按鈕
 */

class TypeButton extends StatelessWidget {
  final String type;
  final String selectedType;
  final Function(String) onTypeSelected;

  TypeButton({
    required this.type,
    required this.selectedType,
    required this.onTypeSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration( //設置容器外觀
          border: Border(
            bottom: BorderSide(
              color: selectedType == type
                  ? const Color(0xFF223888) //選中底部加入藍色
                  : Colors.transparent,
              width: 3.0, // 底部顏色寬度
            ),
          ),
        ),
        child: TextButton(
          onPressed: () {
            onTypeSelected(type);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(100, 40),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder( //圓角矩形-定義按鈕的形狀
              borderRadius: BorderRadius.circular(0),//邊角半徑設為0=皆為直角
            ),
          ),
          child: Text(type, style: TextStyle(
              color: selectedType == type
                  ? const Color(0xFF223888) // 選中
                  : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class TypeButtonList extends StatelessWidget {
  final List<String> typeOptions;
  final String selectedType;
  final Function(String) onTypeSelected;

  TypeButtonList({
    required this.typeOptions,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( //滾動的表單
      scrollDirection: Axis.horizontal, //設置為橫向滑動
      child: Row( //水平方向排列
        children: typeOptions.map((type) {//將列表中每個元素轉換成flutter widget
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TypeButton(
              type: type,
              selectedType: selectedType,
              onTypeSelected: onTypeSelected,
            ),
          );
        }).toList(),  //將map的結果轉換成實際的列表
      ),
    );
  }
}
