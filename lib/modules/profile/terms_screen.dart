import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal/shared/components/app_bar.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../translations/locale_keys.g.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key, required this.htmlCode}) : super(key: key);
  final String htmlCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: CustomAppBar(title:LocaleKeys.terms.tr()),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100.h,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/images/SIMPLY.png',width: 200.w,height: 100.h,),
            ),
            SizedBox(height: 20.h,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
              child: Html(data:htmlCode,onLinkTap: (url, _, __, ___){
                _launchUrl(url.toString());
              },),
            )],
        ),
      ),
      /*Html(data:htmlCode) *//*SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 75.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 94.w),
              child: Image.asset('assets/images/SIMPLY.png'),
            ),
            SizedBox(
              height: 48.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.w),
                ),
                color: const Color(0xFFFCFCFC),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(margin: EdgeInsets.only(left: 16.w,right: 16.w,top: 16.h,bottom: 20.h),child: Text('Privacy policy',style: titleBlackStyle,),),
                  Container(
                    margin: EdgeInsets.only(left: 16.w),
                    child: Text('Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )*//*,*/
    );
  }
  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication)) {
      throw 'Could not launch';
    }
  }
}
