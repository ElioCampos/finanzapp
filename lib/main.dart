// import 'package:finanzapp/utils/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:finanzapp/router.dart' as router;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DbHelper helper = DbHelper();
    // helper.testDB();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FinanzApp",
      initialRoute: 'login',
      onGenerateRoute: router.generateRoute,
    );
  }
}
