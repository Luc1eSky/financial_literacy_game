import 'package:flutter/material.dart';

class LandscapeLayout extends StatelessWidget {
  const LandscapeLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text('SMALL LANDSCAPE SCREEN'),
      ),
    );
  }
}
