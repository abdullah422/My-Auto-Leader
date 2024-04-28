import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/model/ads_model.dart';
import 'package:mal/modules/home/ads_details/ads_details.dart';
import 'package:mal/shared/network/remote/end_points.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/transparent_image.dart';

class Carousel extends StatefulWidget {
  final List<Ads> ? ads;

  const Carousel({Key? key, this.ads}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          items: widget.ads
          !.map((e) =>
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) =>
                      AdsDetails(
                          url: e.link.toString(), title: e.title.toString())));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Stack(
                    children: [
                      Center(
                        child:
                        CircularProgressIndicator(
                          color: kYellow,
                        ),
                      ),
                      FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: EndPoints.baseUrlForImage+e.image.toString(),
                        fit: BoxFit.fill,
                        height: 165.h,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                      )
                    ],
                  ),
                ),
              ))
              .toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            viewportFraction: 1.0,
            height: 165.h,
            autoPlay: true,
            initialPage: 0,

            enableInfiniteScroll: true,
            reverse: false,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayCurve: Curves.easeInBack,
            scrollDirection: Axis.horizontal,
          ),
        ),
        SizedBox(
          height: 15.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.ads!.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 11.r,
                  height: 11.r,
                  margin: EdgeInsets.only(
                      left: 6.w, right: 6.w, top: 5.h, bottom: 0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
