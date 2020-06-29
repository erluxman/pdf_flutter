import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          body: PDFListBody(),
        ));
  }
}

class PDFListBody extends StatefulWidget {
  const PDFListBody({
    Key key,
  }) : super(key: key);

  @override
  _PDFListBodyState createState() => _PDFListBodyState();
}

class _PDFListBodyState extends State<PDFListBody> {
  File localFile;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async{
    var file = await PlatformAssetBundle().load('assets/mySecertImage.png');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        PDF.network(
          'https://raw.githubusercontent.com/FlutterInThai/Dart-for-Flutter-Sheet-cheet/master/Dart-for-Flutter-Cheat-Sheet.pdf',
          height: 200,
          width: 100,
          placeHolder:
          Image.asset("assets/images/pdf.png", height: 200, width: 100),
        ),
        SizedBox(
          height: 10,
        ),
        PDF.assets(
          "assets/pdf/demo.pdf",
          height: 200,
          width: 100,
          placeHolder:
          Image.asset("assets/images/pdf.png", height: 200, width: 100),
        ),
        SizedBox(
          height: 10,
        ),
        localFile != null
            ? PDF.file(
          localFile,
          height: 200,
          width: 100,
          placeHolder: Image.asset("assets/images/pdf.png",
              height: 200, width: 100),
        )
            : InkWell(
          onTap: () async {
            File file = await FilePicker.getFile(
                allowedExtensions: ['pdf'],
                type: FileType.custom
            );
            setState(() {
              localFile = file;
            });
          },
          child: Container(
            height: 200,
            width: 100,
            child: Text("Select PDF from device"),
          ),
        )
      ],
    );
  }
}
