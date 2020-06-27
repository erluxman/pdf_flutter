import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

void main() => runApp(PdfApp());

class PdfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("Network PDF"),
          ),
          body: Column(
            children: <Widget>[
              PDF.network(
                'https://raw.githubusercontent.com/FlutterInThai/Dart-for-Flutter-Sheet-cheet/master/Dart-for-Flutter-Cheat-Sheet.pdf',
                height: 350,
                width: 250,
                placeHolder: Image.asset("assets/images/pdf.png",
                    height: 400, width: 250),
              ),
              SizedBox(
                height: 30,
              ),
              Image.asset("assets/images/code.jpeg")
            ],
          ),
        ));
  }
}
