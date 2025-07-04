import 'dart:core';

import 'package:flutter/material.dart';

import '../helpers/navigation_helper.dart';
import '../values/app_colors.dart';
import '../values/app_theme.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextStyle? titleStyle;
  final List<Widget>? actions;
  final bool? centerTitle;
  final String? title;

  const MyAppBar(
      {Key? key,
      this.title = '',
      this.centerTitle = false,
      this.titleStyle,
      this.actions})
      : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  var availPoints;
  var prfs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: AppColors.primaryColor,
      elevation: 1.0,
      leading: IconButton(
        onPressed: () {
          NavigationHelper.pop();
        },
        icon: const Icon(
          Icons.keyboard_backspace,
          color: Colors.white,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      centerTitle: widget.centerTitle,
      title: widget.centerTitle == false
          ? Align(
              alignment: Localizations.localeOf(context) == const Locale('ar')
                  ? const Alignment(1.5, 0)
                  : const Alignment(-1.1, 0),
              child: Text(
                widget.title.toString(),
                style: AppTheme.textFormFieldTitle,
                maxLines: 1,
              ))
          : Text(
              widget.title.toString(),
              style: AppTheme.textFormFieldTitle,
              maxLines: 1,
            ),
    );
  }
}
