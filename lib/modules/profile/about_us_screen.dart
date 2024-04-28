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

class AboutUsScreen extends StatelessWidget {
  final String htmlCode;
  final Map<String, dynamic> links;

  const AboutUsScreen({Key? key, required this.htmlCode, required this.links})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(links);
    return Scaffold(
      backgroundColor: kWhite,
      appBar: CustomAppBar(title: LocaleKeys.about_us.tr()),
      body: /*Html(data:htmlCode)*/
          SingleChildScrollView(
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  LocaleKeys.about_us.tr(),
                  style: titleBlackStyle,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Html(data: htmlCode),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 37.h,
              width: 323.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        _launchUrl(links['facebook']);
                      },
                      child: SvgPicture.asset('assets/svg/facebook.svg')),
                  InkWell(
                      onTap: () {
                        _launchUrl(links['Instagram']);
                      },
                      child: SvgPicture.asset('assets/svg/instgram.svg')),
                  InkWell(
                      onTap: () {
                        _launchUrl(links['linkedIn']);
                      },
                      child: SvgPicture.asset('assets/svg/linkedin.svg')),
                  InkWell(
                      onTap: () {
                        _launchUrl(links['tiktok']);
                      },
                      child: SvgPicture.asset('assets/svg/tiktok.svg')),
                  InkWell(
                      onTap: () {
                        _launchUrl(links['twitter']);
                      },
                      child: SvgPicture.asset('assets/svg/twit.svg')),
                  InkWell(
                      onTap: () {
                        _launchUrl(links['youtube']);
                      },
                      child: SvgPicture.asset('assets/svg/youtube.svg')),
                  /*SvgPicture.asset('assets/svg/tiktok.svg'),
                  ,
                  */
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch';
    }
  }
}
