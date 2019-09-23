import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner();

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Container(
        child: AspectRatio(
          aspectRatio: 3 / 5,
          child: Image.asset(
            "assets/images/banner.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
