import 'package:financial_literacy_game/config/color_palette.dart';
import 'package:flutter/material.dart';

import '../../config/text_styles.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorPalette().backgroundSectionCard,
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles().sectionCardStyle,
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }
}
