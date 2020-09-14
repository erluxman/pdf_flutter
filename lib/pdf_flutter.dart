import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PDF extends StatefulWidget {
  const PDF._({
    this.file,
    this.networkURL,
    this.assetsPath,
    this.width = 150,
    this.height = 250,
    this.placeHolder,
    this.hitTestBehavior,
  });

  /// Load PDF from network
  /// url : the URL of pdf file
  /// placeholder : Widget to show when pdf is loading from network.
  factory PDF.network(String url, {
    double width = 150,
    double height = 250,
    Widget placeHolder,
    PlatformViewHitTestBehavior hitTestBehavior,
  }) {
    return PDF._(
      networkURL: url,
      width: width,
      height: height,
      placeHolder: placeHolder,
      hitTestBehavior: hitTestBehavior,
    );
  }

  /// Load PDF from network
  /// file : File object that represents the PDF file from device.
  /// placeholder : Widget to show when pdf is loading from network.
  factory PDF.file(
    File file, {
    double width = 150,
    double height = 250,
    Widget placeHolder,
    PlatformViewHitTestBehavior hitTestBehavior,
  }) {
    return PDF._(
      file: file,
      width: width,
      height: height,
      placeHolder: placeHolder,
      hitTestBehavior: hitTestBehavior,
    );
  }

  /// Load PDF from network
  /// assetPath : path like : assets/pdf/demo.pdf
  /// placeholder : Widget to show when pdf is loading from network.
  factory PDF.assets(
    String assetPath, {
    double width = 150,
    double height = 250,
    Widget placeHolder,
    PlatformViewHitTestBehavior hitTestBehavior,
  }) {
    return PDF._(
      assetsPath: assetPath,
      width: width,
      height: height,
      placeHolder: placeHolder,
      hitTestBehavior: hitTestBehavior,
    );
  }

  final String networkURL;
  final File file;
  final String assetsPath;
  final double height;
  final double width;
  final Widget placeHolder;
  final PlatformViewHitTestBehavior hitTestBehavior;

  @override
  _PDFState createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  String path;

  Future<File> get _localFile async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    String fileName = getFileName();
    return File('$path/$fileName.pdf');
  }

  String getFileName() {
    return getLetterAndDigits(widget.assetsPath ?? widget.networkURL);
  }

  String getLetterAndDigits(String input) {
    var selectedChars =
        input.runes.where((element) => isLetter(element) || isDigit(element));
    return String.fromCharCodes(selectedChars);
  }

  bool isLetter(int input) =>
      (input >= 65 && input <= 90) || (input >= 97 && input <= 122);

  bool isDigit(int input) => (input >= 48 && input <= 57);

  Future<File> writeCounter(Uint8List stream) async =>
      (await _localFile).writeAsBytes(stream);

  Future<bool> existsFile() async => (await _localFile).exists();

  Future<Uint8List> fetchPost() async =>
      (await http.get(widget.networkURL)).bodyBytes;

  void loadPdf() async {
    if (widget.networkURL != null) {
      await loadNetworkPDF();
    } else if (widget.file != null) {
      await loadFile();
    } else if (widget.assetsPath != null) {
      await loadAssetPDF();
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> loadAssetPDF() async {
    var asset = await PlatformAssetBundle().load(widget.assetsPath);
    await (writeCounter(asset.buffer.asUint8List()));
    path = (await _localFile).path;
  }

  Future<void> loadNetworkPDF() async {
    File fetchedFile =
        await DefaultCacheManager().getSingleFile(widget.networkURL);
    await (writeCounter(fetchedFile.readAsBytesSync()));
    path = (await _localFile).path;
  }

  Future<void> loadFile() async {
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
        duration: Duration(milliseconds: 200),
        child: (path != null)
            ? Container(
                height: widget.height,
                width: widget.width,
                child: PdfViewer(
                  filePath: path,
                  onPdfViewerCreated: () {
                    print("PDF view created");
                  },
                  hitTestBehavior: widget.hitTestBehavior,
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
    this.hitTestBehavior,
  }) : super(key: key);

  final String filePath;
  final PdfViewerCreatedCallback onPdfViewerCreated;
  final PlatformViewHitTestBehavior hitTestBehavior;

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
        hitTestBehavior: widget.hitTestBehavior,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'pdf_flutter_plugin',
        creationParams: <String, dynamic>{
          'filePath': widget.filePath,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        hitTestBehavior: widget.hitTestBehavior,
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
