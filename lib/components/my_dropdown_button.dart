import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;

  const MyDropdownButton({
    Key? key,
    required this.hintText,
    required this.items,
    this.selectedValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(10),
      itemHeight: 60,
      icon: Icon(Icons.arrow_drop_down_circle_sharp, color: Theme.of(context).colorScheme.primary),
      underline: Container(
        height: 2,
        color: Theme.of(context).colorScheme.primary,
      ),
      isExpanded: true,
      hint: Text(widget.hintText),
      value: widget.selectedValue,
      onChanged: widget.onChanged,
      items: widget.items.map((String valueItem) {
        return DropdownMenuItem<String>(
          value: valueItem,
          child: Text(valueItem),
        );
      }).toList(),
    );
  }
}
