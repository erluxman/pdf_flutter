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
        body: const PDFListBody(
          maxAndroidZoom: 10,
          midAndroidZoom: 5,
          minAndroidZoom: 1,
        ),
      ),
    );
  }
}

class PDFListBody extends StatefulWidget {
  const PDFListBody({
    Key? key,
    this.minAndroidZoom,
    this.midAndroidZoom,
    this.maxAndroidZoom,
  }) : super(key: key);

  final double? minAndroidZoom;
  final double? midAndroidZoom;
  final double? maxAndroidZoom;

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
                  maxAndroidZoom: widget.maxAndroidZoom,
                  midAndroidZoom: widget.midAndroidZoom,
                  minAndroidZoom: widget.minAndroidZoom,
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
                  maxAndroidZoom: widget.maxAndroidZoom,
                  midAndroidZoom: widget.midAndroidZoom,
                  minAndroidZoom: widget.minAndroidZoom,
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
                        maxAndroidZoom: widget.maxAndroidZoom,
                        midAndroidZoom: widget.midAndroidZoom,
                        minAndroidZoom: widget.minAndroidZoom,
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
