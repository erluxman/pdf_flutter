import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class PDF extends StatefulWidget {
  const PDF._(
      {this.file,
      this.networkURL,
      this.width = 150,
      this.height = 250,
      this.placeHolder});

  factory PDF.network(
    String filePath, {
    double width = 150,
    double height = 250,
    Widget placeHolder,
  }) {
    return PDF._(
        networkURL: filePath,
        width: width,
        height: height,
        placeHolder: placeHolder);
  }

  factory PDF.file(
    File file, {
    double width = 150,
    double height = 250,
    Widget placeHolder,
  }) {
    return PDF._(
        file: file, width: width, height: height, placeHolder: placeHolder);
  }

  final String networkURL;
  final double height;
  final double width;
  final Widget placeHolder;
  final File file;

  @override
  _PDFState createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  String path;

  Future<File> get _localFile async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    return File('$path/${Uuid().toString()}.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async =>
      (await _localFile).writeAsBytes(stream);

  Future<bool> existsFile() async => (await _localFile).exists();

  Future<Uint8List> fetchPost() async =>
      (await http.get(widget.networkURL)).bodyBytes;

  void loadPdf() async {
    if(widget.networkURL!=null){
      await loadNetworkPDF();
    }

    if(widget.file!=null){
      await loadFile();
    }

    if (!mounted) return;
    setState(() {});
  }

  Future<void> loadNetworkPDF() async{
    await writeCounter(await fetchPost());
    await existsFile();
    path = (await _localFile).path;
  }

  Future<void> loadFile() async{
    path = widget.file.path;
  }

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: (path != null)
            ? Container(
                height: widget.height,
                width: widget.width,
                child: PdfViewer(
                  filePath: path,
                ),
              )
            : Container(
                height: widget.height,
                width: widget.width,
                child: widget.placeHolder ??
                    Center(
                      child: Container(
                        height: min(widget.height, widget.width),
                        width: min(widget.height, widget.width),
                        child: CircularProgressIndicator(),
                      ),
                    ),
              ));
  }
}

typedef void PdfViewerCreatedCallback();

class PdfViewer extends StatefulWidget {
  const PdfViewer({
    Key key,
    this.filePath,
    this.onPdfViewerCreated,
  }) : super(key: key);

  final String filePath;
  final PdfViewerCreatedCallback onPdfViewerCreated;

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'pdf_flutter_plugin',
        creationParams: <String, dynamic>{
          'filePath': widget.filePath,
        },
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'pdf_flutter_plugin',
        creationParams: <String, dynamic>{
          'filePath': widget.filePath,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }

    return Text('pdf_network not supported in $defaultTargetPlatform yet');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onPdfViewerCreated == null) {
      return;
    }
    widget.onPdfViewerCreated();
  }
}
