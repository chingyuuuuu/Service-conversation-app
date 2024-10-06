import 'package:flutter/material.dart';



class TypeButton extends StatelessWidget {
  final String type;
  final String selectedType;
  final Function(String) onTypeSelected;

  TypeButton(
      {required this.type, required this.selectedType, required this.onTypeSelected});

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTypeSelected(type);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedType == type
            ? const Color(0xFF223888)
            : Colors.white,
        minimumSize: const Size(100, 40),
        padding: EdgeInsets.zero,
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
