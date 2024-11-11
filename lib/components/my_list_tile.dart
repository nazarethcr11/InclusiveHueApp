import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon_leading;
  final String title;
  final void Function() onTap;
  final Color iconColor;

  const MyListTile({
    super.key,
    required this.icon_leading,
    required this.title,
    required this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Icon(icon_leading, color: iconColor),
            title: Text(title),
            trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.tertiary),
            onTap: onTap,
          ),
        ),
    );
  }
}
