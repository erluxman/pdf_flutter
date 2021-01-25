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
            title: const Text("pdf_flutter demo"),
          ),
          body: PDFListBody(),
        ));
  }
}

class PDFListBody extends StatefulWidget {
  @override
  _PDFListBodyState createState() => _PDFListBodyState();
}

class _PDFListBodyState extends State<PDFListBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: const Text("Pdf from asset"),
            onPressed: () {
              _navigateToPage(
                title: "Pdf from asset",
                child: PDF.asset(
                  "assets/pdf/demo.pdf",
                  placeHolder: Image.asset("assets/images/pdf.png",
                      height: 200, width: 100),
                ),
              );
            },
          ),
          RaisedButton(
            child: const Text("Pdf from network"),
            onPressed: () {
              _navigateToPage(
                title: "Pdf from networkUrl",
                child: PDF.network(
                  'https://google-developer-training.github.io/android-developer-fundamentals-course-concepts/en/android-developer-fundamentals-course-concepts-en.pdf',
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              return RaisedButton(
                child: const Text("PDF from file"),
                onPressed: () async {
                  final file = await FilePicker.platform.pickFiles(
                      allowedExtensions: ['pdf'], type: FileType.custom);
                  if (file?.files[0]?.path != null) {
                    _navigateToPage(
                      title: "PDF from file",
                      child: PDF.file(
                        File(file.files[0].path),
                      ),
                    );
                  } else {
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to load Picked file"),
                      ),
                    );
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }

  void _navigateToPage({String title, Widget child}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(child: child),
        ),
      ),
    );
  }
}
