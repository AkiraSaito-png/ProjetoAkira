import 'dart:js';

import 'package:flutter/material.dart';
import 'layout.dart';

import 'models/item.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    PaginaInicial.tag: (context) => PaginaInicial(),
  };

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}
