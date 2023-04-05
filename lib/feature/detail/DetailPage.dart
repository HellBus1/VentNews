import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vent_news/widgets/CustomHeader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends HookWidget {
  final String url;

  const DetailPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final WebViewController _controller;

    useEffect(() {
      final controller = WebViewController();

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('''
                Page resource error:
                  code: ${error.errorCode}
                  description: ${error.description}
                  errorType: ${error.errorType}
                  isForMainFrame: ${error.isForMainFrame}
                          ''');
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                debugPrint('blocking navigation to ${request.url}');
                return NavigationDecision.prevent;
              }
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(url.replaceFirst("http://", "https://")));

      _controller = controller;
    }, const []);

    return CustomHeader(
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
