import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../stores/user.dart';

final userData = UserBloc.getInstance();

class SplashWidget extends StatelessWidget {
  const SplashWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateBuilder(
        initState: (state) => userData.onAppInitCallBack(state, context),
        builder: (_) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
            image: AssetImage("assets/images/logo.jpg"),
          ),
        ),
      ),
      )
    );
  }
}
