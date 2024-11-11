import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
  final double initialValue;
  final String title;
  final ValueChanged<double> onChanged;

  const MySlider({
    Key? key,
    required this.initialValue,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MySlider> createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  late double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '0',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Container(
                width: 280,
                child: Slider(
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(context).colorScheme.tertiary,
                  value: currentValue,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: currentValue.toStringAsFixed(0),
                  onChanged: (value) {
                    setState(() {
                      currentValue = value;
                    });
                    widget.onChanged(value);
                  },
                ),
              ),
              Text(
                '100',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

