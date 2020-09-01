import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'dot_indicator.dart';

class ImageSliderWidget extends StatefulWidget {
  final List<String> imageUrls;
  final BorderRadius imageBorderRadius;
  final double imageHeight;

  ImageSliderWidget({
    Key key,
    @required this.imageUrls,
    @required this.imageBorderRadius,
    this.imageHeight = 350.0,
  }) : super(key: key);

  @override
  ImageSliderWidgetState createState() {
    return ImageSliderWidgetState();
  }
}

class ImageSliderWidgetState extends State<ImageSliderWidget> {
  List<Widget> _pages = [];

  int page = 0;

  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    _pages = widget.imageUrls.map((url) {
      return _buildImagePageItem(url);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildingImageSlider();
  }

  Widget _buildingImageSlider() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(0.0),
      child: Card(
        margin: EdgeInsets.all(0.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        //elevation: 4.0,
        child: Stack(
          children: [
            _buildPagerViewSlider(),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: 80.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                    tileMode: TileMode.clamp,
                    begin: Alignment(0.0, -1.0),
                    end: Alignment(0.0, 0.2),
                    colors: [
                      Color.fromARGB(0, 6, 6, 6),
                      Color.fromARGB(77, 6, 6, 6),
                    ],
                  ),
                ),
              ),
            ),
            widget.imageUrls.length > 1
                ? _buildDotsIndicatorOverlay()
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildPagerViewSlider() {
    return Positioned.fill(
      child: PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[index % _pages.length];
        },
        onPageChanged: (int p) {
          setState(() {
            page = p;
          });
        },
      ),
    );
  }

  Positioned _buildDotsIndicatorOverlay() {
    return Positioned(
      bottom: 10.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: DotsIndicator(
          chosenColor: colorMain,
          normalColor: Colors.white,
          controller: _controller,
          itemCount: _pages.length,
          onPageSelected: (int page) {
            _controller.animateToPage(
              page,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }

  Widget _buildImagePageItem(String imgUrl) {
    return ClipRRect(
      borderRadius: widget.imageBorderRadius,
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        placeholder: (context, url) => Center(
          child: Platform.isIOS
              ? CupertinoActivityIndicator()
              : CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
}