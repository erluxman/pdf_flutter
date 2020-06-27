#import "PdfView.h"

@implementation PdfViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  PdfViewController* webviewController = [[PdfViewController alloc] initWithFrame:frame
                                                                         viewIdentifier:viewId
                                                                              arguments:args
                                                                        binaryMessenger:_messenger];
  return webviewController;
}

@end

@implementation PdfViewController {
  WKWebView *_webView;
  int64_t _viewId;
  UIViewController *_viewController;
  FlutterMethodChannel* _channel;
  NSString* filePath;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    _viewId = viewId;
    
    NSString* channelName = [NSString stringWithFormat:@"pdf_viewer_plugin_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    
    _viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    filePath = args[@"filePath"];
    
    if (_webView == nil){
        WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        NSURL *targetURL = [NSURL fileURLWithPath:filePath];
        if (@available(iOS 9.0, *)) {
            [_webView loadFileURL:targetURL allowingReadAccessToURL:targetURL];
        } else {
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
            [_webView loadRequest:request];
        }
    }
    
  return self;
}

- (UIView*)view {
  return _webView;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([[call method] isEqualToString:@"updateSettings"]) {
    
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
