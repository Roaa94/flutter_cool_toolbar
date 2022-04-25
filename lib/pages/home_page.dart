import 'package:flutter/material.dart';

import '../widgets/cool_toolbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CoolToolbar(),
        ),
      ),
    );
  }
}
