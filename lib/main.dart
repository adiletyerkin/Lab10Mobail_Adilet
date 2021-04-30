import 'package:flutter/material.dart';

import 'pages/register_form_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ("Lab10 Register Form"),
      theme: ThemeData(
      ),
      home: RegisterFormPage(),

    );
  }
}









