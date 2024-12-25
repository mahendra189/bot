// custom app bar which will display a 3 line menu icon on left side & page name behind it then a notifications icon right side
import 'package:bot/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BAppBar(
      {super.key,
      required this.pageName,
      this.onIconPressed,
      this.icon = Iconsax.notification,
      this.color = Colors.white});

  final String pageName;
  final VoidCallback? onIconPressed;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      titleSpacing: 20,
      title: Text(
        pageName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(icon),
          onPressed: onIconPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
