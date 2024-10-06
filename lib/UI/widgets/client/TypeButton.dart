import 'package:flutter/material.dart';



class TypeButton extends StatelessWidget {
  final String type;
  final String selectedType;
  final Function(String) onTypeSelected;

  TypeButton({required this.type, required this.selectedType, required this.onTypeSelected});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTypeSelected(type);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedType == type
            ? const Color(0xFF223888) // 选中的按钮高亮显示
            : Colors.white, // 未选中的按钮为白色
        minimumSize: const Size(100, 40), // 按钮的最小尺寸
      ),
      child: Text(
        type,
        style: TextStyle(
          color: selectedType == type
              ? Colors.white
              : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
