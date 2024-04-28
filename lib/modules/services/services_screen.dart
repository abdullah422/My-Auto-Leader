import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../shared/styles/colors.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen(this.url,{Key? key}) : super(key: key);
  final String url;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedDirectional(
            top: 24,
            start: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 24,
            child: WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
          PositionedDirectional(
            top: 24,
            start: 8,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.exit_to_app,
                size: 35.sp,
                color: Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
