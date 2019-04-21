import 'package:flutter/material.dart';

class Base extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Base();
  }
}

class _Base extends State<Base> {
  @override
  void initState() {
    super.initState();
    print('基地');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/imgs/home-bg.gif'),
          fit: BoxFit.cover
        )
      )
    );
  }
}