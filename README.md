# pdf_flutter
[![pub package](https://img.shields.io/pub/v/pdf_flutter.svg)](https://pub.dartlang.org/packages/pdf_flutter)

Inspired by [Pdf_Viewer_Plugin](https://github.com/lubritto/Pdf_Viewer_Plugin) 😇
Wrapped around [AndroidPdfViewer](https://github.com/barteksc/AndroidPdfViewer) on Android. 🙏🏼

#### 1. Add `pdf_flutter`on `pubspec.yml` 

    dependencies:
      pdf_flutter: ^version

#### 2. On iOS enable PDF preview like this:

Add this on `ios/Runner/info.plist`:

        <key>io.flutter.embedded_views_preview</key>
        <true/>

#### 3. Start Using 

        //Load PDF from network
        PDF.network(
                'https://raw.githubusercontent.com/FlutterInThai/Dart-for-Flutter-Sheet-cheet/master/Dart-for-Flutter-Cheat-Sheet.pdf',
                height: 500,
                width: 300,
        )
              
        //Load PDF files
        File fileName;  
        PDF.file(
            fileName,
            height: 200,
            width: 100,
        )
        
        //Load PDF from assets
        PDF.assets(
            "assets/pdf/demo.pdf",
            height: 200,
            width: 100,
        )
## Demo
            
![demo](art/pdf_flutter.gif)
