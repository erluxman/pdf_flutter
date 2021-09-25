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
          title: const Text('pdf_flutter demo'),
        ),
        body: PDFListBody(),
      ),
    );
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
          ElevatedButton(
            onPressed: () {
              _navigateToPage(
                title: 'Pdf from asset',
                child: PDF.asset(
                  'assets/pdf/demo.pdf',
                  placeHolder: Image.asset(
                    'assets/images/pdf.png',
                    height: 200,
                    width: 100,
                  ),
                ),
              );
            },
            child: const Text('Pdf from asset'),
          ),
          ElevatedButton(
            onPressed: () {
              _navigateToPage(
                title: 'Pdf from networkUrl',
                child: PDF.network(
                  'https://google-developer-training.github.io/android-developer-fundamentals-course-concepts/en/android-developer-fundamentals-course-concepts-en.pdf',
                ),
              );
            },
            child: const Text('Pdf from network'),
          ),
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  final file = await FilePicker.platform.pickFiles(
                      allowedExtensions: ['pdf'], type: FileType.custom);
                  if (file?.files[0].path != null) {
                    _navigateToPage(
                      title: 'PDF from file',
                      child: PDF.file(
                        File(file!.files[0].path!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to load Picked file'),
                      ),
                    );
                  }
                },
                child: const Text('PDF from file'),
              );
            },
          )
        ],
      ),
    );
  }

  void _navigateToPage({required String title, required Widget child}) {
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
