import 'package:flutter/material.dart';

class MyToggleButton extends StatefulWidget {
  final String leftLabel;
  final String rightLabel;
  final bool isToggled;
  final ValueChanged<bool> onChanged;

  const MyToggleButton({
    Key? key,
    required this.leftLabel,
    required this.rightLabel,
    required this.isToggled,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MyToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<MyToggleButton> {
  late bool isToggled;

  @override
  void initState() {
    super.initState();
    isToggled = widget.isToggled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isToggled = false;
                    widget.onChanged(false);
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isToggled ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                    borderRadius: isToggled ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ) : BorderRadius.circular(30),
                    boxShadow: [
                      isToggled ? BoxShadow() : BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: Offset(0, 0),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings_power_sharp,
                          color: isToggled ? Theme.of(context).colorScheme.inverseSurface : Theme.of(context).colorScheme.inversePrimary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          widget.leftLabel,
                          style: TextStyle(
                            color: isToggled ? Theme.of(context).colorScheme.inverseSurface : Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isToggled = true;
                    widget.onChanged(true);
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isToggled ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
                    borderRadius: isToggled ? BorderRadius.circular(30) : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      isToggled ? BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: Offset(0, 0),
                        blurRadius: 5,
                      ) : BoxShadow(),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          color: isToggled ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.inverseSurface,
                        ),
                        SizedBox(width: 8),
                        Text(
                          widget.rightLabel,
                          style: TextStyle(
                            color: isToggled ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.inverseSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}