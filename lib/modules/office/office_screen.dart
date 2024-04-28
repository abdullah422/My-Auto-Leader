import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../shared/styles/colors.dart';

class OfficeScreen extends StatefulWidget {
  const OfficeScreen({Key? key}) : super(key: key);

  @override
  State<OfficeScreen> createState() => _OfficeScreenState();
}

class _OfficeScreenState extends State<OfficeScreen> {
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
             child: const WebView(
              initialUrl: "https://panel.simply37.com/backoffice/login",
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
