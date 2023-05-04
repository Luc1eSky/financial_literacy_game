import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';

import '../../config/color_palette.dart';

class MenuDialog extends StatelessWidget {
  const MenuDialog({
    required this.title,
    this.content,
    this.actions,
    this.showCloseButton = true,
    super.key,
  });

  final String title;
  final bool showCloseButton;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return DeferredPointerHandler(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom), // adjust
        // values
        child: AlertDialog(
          backgroundColor: ColorPalette().background,
          title: Stack(
            clipBehavior: Clip.none,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorPalette().darkText,
                ),
              ),
              if (showCloseButton)
                Positioned(
                  top: -30.0,
                  right: -30.0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorPalette().buttonBackground,
                    ),
                    child: DeferPointer(
                      child: IconButton(
                        iconSize: 100,
                        padding: const EdgeInsets.all(5.0),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Center(
                          child: FittedBox(
                            child: Icon(
                              Icons.close,
                              color: ColorPalette().lightText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          content: content,
          actions: actions,
        ),
      ),
    );
  }
}
