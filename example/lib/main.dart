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
            title: Text("pdf_flutter demo"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              PDF.network(
                'https://raw.githubusercontent.com/FlutterInThai/Dart-for-Flutter-Sheet-cheet/master/Dart-for-Flutter-Cheat-Sheet.pdf',
                height: 400,
                width: 350,
                placeHolder: Image.asset("assets/images/pdf.png",
                    height: 400, width: 250),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Image.asset("assets/images/code.jpeg",
                height: 300,),
              )
            ],
          ),
        ));
  }
}
