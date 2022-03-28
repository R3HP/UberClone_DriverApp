import 'package:flutter/material.dart';


class TripDetailDialogField extends StatelessWidget {
  final String label;
  final String value;
  const TripDetailDialogField({
    Key? key,
    required this.label,
    required this.value,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 7, left: 8, right: 8,bottom: 5),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value)
        ],
      ),
    );
  }
}
