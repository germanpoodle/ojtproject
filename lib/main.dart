import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/Welcomescreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const iLeadDocumentViewer());
}

class iLeadDocumentViewer extends StatelessWidget {
  const iLeadDocumentViewer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home:const WelcomeScreen(),
    );
  }
}