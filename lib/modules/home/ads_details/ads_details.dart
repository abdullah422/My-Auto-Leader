import 'package:flutter/material.dart';
import 'package:mal/shared/components/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdsDetails extends StatefulWidget {
  final String url ,title;
  const AdsDetails({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  State<AdsDetails> createState() => _AdsDetailsState();
}

class _AdsDetailsState extends State<AdsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
