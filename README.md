# pdf_flutter

#### 1. Add `pdf_flutter`on `pubspec.yml` 

    dependencies:
      pdf_flutter: ^version

#### 2. On iOS enable PDF preview like this:

Add this on `ios/Runner/info.plist`:

        <key>io.flutter.embedded_views_preview</key>
        <true/>

#### 3. Start Using

        PDF.network(
                'https://raw.githubusercontent.com/FlutterInThai/Dart-for-Flutter-Sheet-cheet/master/Dart-for-Flutter-Cheat-Sheet.pdf',
                height: 500,
                width: 300,
                )
                
## Demo
            
![demo](art/pdf_flutter.gif)