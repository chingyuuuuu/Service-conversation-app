import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selectedType == type
                  ? const Color(0xFF223888) // 选中时底部边框为蓝色
                  : Colors.transparent, // 未选中时没有底部边框
              width: 3.0, // 底部边框宽度
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Text(
            type,
            style: TextStyle(
              color: selectedType == type
                  ? const Color(0xFF223888) // 选中时文字为蓝色
                  : Colors.black, // 未选中时文字为黑色
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 设置为横向滑动
      child: Row(
        children: typeOptions.map((type) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TypeButton(
              type: type,
              selectedType: selectedType,
              onTypeSelected: onTypeSelected,
            ),
          );
        }).toList(),
      ),
    );
  }
}
