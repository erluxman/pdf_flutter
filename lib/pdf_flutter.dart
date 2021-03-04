import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PDF extends StatefulWidget {
  const PDF._({
    this.file,
    this.networkURL,
    this.assetsPath,
    this.width = double.maxFinite,
    this.height = double.maxFinite,
    this.placeHolder,
  });

  /// Load PDF from network
  /// url : the URL of pdf file
  /// placeholder : Widget to show when pdf is loading from network.
  factory PDF.network(
    String url, {
    double width = double.maxFinite,
    double height = double.maxFinite,
    Widget? placeHolder,
  }) {
    return PDF._(
        networkURL: url,
        width: width,
        height: height,
        placeHolder: placeHolder);
  }

  /// Load PDF from network
  /// file : [File] object that represents the PDF file from device.
  /// placeholder : [Widget] to show when pdf is loading from network.
  factory PDF.file(
    File file, {
    double width = double.maxFinite,
    double height = double.maxFinite,
    Widget? placeHolder,
  }) {
    return PDF._(
      file: file,
      width: width,
      height: height,
      placeHolder: placeHolder,
    );
  }

  /// Load PDF from network
  /// assetPath : path like : `assets/pdf/demo.pdf`
  /// placeholder : Widget to show when pdf is loading from network.
  factory PDF.asset(
    String assetPath, {
    double width = double.maxFinite,
    double height = double.maxFinite,
    Widget? placeHolder,
  }) {
    return PDF._(
        assetsPath: assetPath,
        width: width,
        height: height,
        placeHolder: placeHolder);
  }

  final String? networkURL;
  final File? file;
  final String? assetsPath;
  final double height;
  final double width;
  final Widget? placeHolder;

  @override
  _PDFState createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  String? path;

  Future<File> get _localFile async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final fileName = getFileName();
    return File('$path/$fileName.pdf');
  }

  String getFileName() {
    var input;
    if (widget.assetsPath != null) {
      input = widget.assetsPath;
    } else {
      if (widget.networkURL != null) {
        final splitLength = widget.networkURL!.split('/').length;
        input = widget.networkURL!.split('/')[splitLength - 1];
      } else {
        debugPrint(
            'Cannot get filename because networkURL and assetsPath is null.');
      }
    }
    final result = input.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return result;
  }

  Future<File> writeCounter(Uint8List stream) async =>
      (await _localFile).writeAsBytes(stream);

  Future<bool> existsFile() async => (await _localFile).exists();

  Future<Uint8List?> fetchPost() async {
    if (widget.networkURL != null) {
      var uri = Uri.http(widget.networkURL!, '');
      return (await http.get(uri)).bodyBytes;
    } else {
      debugPrint('Cannot fetch post because networkURL is null.');
    }
  }

  void loadPdf() async {
    if (widget.networkURL != null) {
      await loadNetworkPDF();
    } else if (widget.file != null) {
      await loadFile();
    } else if (widget.assetsPath != null) {
      await loadAssetPDF();
    }
    setState(() {});
  }

  Future<void> loadAssetPDF() async {
    final asset = await PlatformAssetBundle().load(widget.assetsPath!);
    await (writeCounter(asset.buffer.asUint8List()));
    path = (await _localFile).path;
  }

  Future<void> loadNetworkPDF() async {
    final fetchedFile =
        await DefaultCacheManager().getSingleFile(widget.networkURL!);
    await (writeCounter(fetchedFile.readAsBytesSync()));
    path = (await _localFile).path;
  }

  Future<void> loadFile() async {
    path = widget.file!.path;
  }

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: (path != null)
          ? Container(
              height: widget.height,
              width: widget.width,
              child: PdfViewer(
                filePath: path!,
                onPdfViewerCreated: () {
                  debugPrint('PDF view created');
                },
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
            ),
    );
  }
}

// ignore: prefer_generic_function_type_aliases
typedef void PdfViewerCreatedCallback();

class PdfViewer extends StatefulWidget {
  const PdfViewer({
    required this.filePath,
    Key? key,
    this.onPdfViewerCreated,
  }) : super(key: key);

  final String filePath;
  final PdfViewerCreatedCallback? onPdfViewerCreated;

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
        creationParamsCodec: const StandardMessageCodec(),
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
    } else {
      widget.onPdfViewerCreated!();
    }
  }
}
