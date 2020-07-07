import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("PDF.network(url)"),
                PDF.network(
                  'https://raw.githubusercontent.com/aparneshgaurav/readArea/master/core%20java%20and%20peripheral/Head%20First%20Java%2C%202nd%20Edition.pdf',
                  height: 300,
                  width: 150,
                  placeHolder: Image.asset("assets/images/pdf.png",
                      height: 200, width: 100),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: <Widget>[
                Text("PDF.assets(assetname)"),
                PDF.assets(
                  "assets/pdf/demo.pdf",
                  height: 300,
                  width: 150,
                  placeHolder: Image.asset("assets/images/pdf.png",
                      height: 200, width: 100),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        localFile != null
            ? Column(
                children: <Widget>[
                  Text("PDF.file(fileName)"),
                  PDF.file(
                    localFile,
                    height: 300,
                    width: 200,
                    placeHolder: Image.asset("assets/images/pdf.png",
                        height: 200, width: 100),
                  ),
                ],
              )
            : InkWell(
                onTap: () async {
                  File file = await FilePicker.getFile(
                      allowedExtensions: ['pdf'], type: FileType.custom);
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
