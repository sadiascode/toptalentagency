import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {
  final Function(String)? onSearch;
  final String? hintText;

  const CustomSearch({
    super.key,
    this.onSearch,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Color(0xff212121),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText ?? "Search...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
              ),
              onChanged: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}