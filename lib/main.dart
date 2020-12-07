import 'package:flutter/material.dart';
import 'package:truth_or_dare/pages/entry_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truth or Dare',
      home: EntryPage(),
      theme: ThemeData.dark(),
    );
  }
}
