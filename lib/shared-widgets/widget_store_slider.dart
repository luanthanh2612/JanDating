import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';

import 'package:provider/provider.dart';
import 'package:jan_app_flutter/constants//styles.dart';

const String _kConsumableId = 'demo1';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  'upgrade',
  'subscription'
];

class StoreSlider extends StatefulWidget {
  @override
  _StoreSliderState createState() => _StoreSliderState();
}

class _StoreSliderState extends State<StoreSlider> {
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  int _currentIndex = 0;
  int _selected = 2;
  UserModel _user;
  String _gender;
  List cardList;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthProvider>().currentUser;
    setState(() {
      _gender = _user.gender;
      if (_gender == 'female') {
        cardList = [
          Item2(),
          Item3(),
        ];
      } else {
        cardList = [
          Item1(),
          Item2(),
          Item3(),
        ];
      }
    });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
          child: Text(translate('shop-modal.title'),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold)),
        ),
        CarouselSlider(
          height: 240.0,
          autoPlay: true,
          viewportFraction: 1.0,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: Duration(seconds: 10),
          aspectRatio: 2.0,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: cardList.map((card) {
            return Builder(builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                child: card,
              );
            });
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(cardList, (index, url) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? colorMain : colorGrey,
              ),
            );
          }),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            height: 65,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _selected = 1;
                });
              },
              disabledColor: Colors.white,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: (_selected == 1)
                      ? BorderSide(color: colorMain, width: 1.5)
                      : BorderSide.none),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                              translate('shop-modal.plans.seven-days')
                                  .substring(0, 1),
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              textAlign: TextAlign.center),
                          Text(
                              translate('shop-modal.plans.seven-days')
                                  .substring(2),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 0.8),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      width: 60,
                    ),
                    VerticalDivider(
                        color: Colors.black, indent: 5, endIndent: 5),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('490 ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                    ),
                    Text(translate('currencies.rub'),
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            height: 65,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _selected = 2;
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: (_selected == 2)
                      ? BorderSide(color: colorMain, width: 1.5)
                      : BorderSide.none),
              disabledColor: Colors.white,
              color: Colors.white,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                              translate('shop-modal.plans.one-month')
                                  .substring(0, 1),
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              textAlign: TextAlign.center),
                          Text(
                              translate('shop-modal.plans.one-month')
                                  .substring(2),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 0.8),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      width: 60,
                    ),
                    VerticalDivider(
                        color: Colors.black, indent: 5, endIndent: 5),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 0, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('990 ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black)),
                              Text(translate('currencies.rub'),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('~',
                                  style: TextStyle(
                                      color: colorGrey, fontSize: 12)),
                              Text('247',
                                  style: TextStyle(
                                      color: colorGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              Text(' руб/ 7 дней',
                                  style: TextStyle(
                                      color: colorGrey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        child: Column(
                          children: [
                            Text(translate('50%'),
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: colorMain),
                                textAlign: TextAlign.center),
                            Text(translate('shop-modal.plans.discount'),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: colorMain,
                                    height: 0.9),
                                textAlign: TextAlign.center),
                          ],
                        ),
                        width: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            height: 65,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: (_selected == 3)
                      ? BorderSide(color: colorMain, width: 1.5)
                      : BorderSide.none),
              onPressed: () {
                setState(() {
                  _selected = 3;
                });
              },
              disabledColor: Colors.white,
              color: Colors.white,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                              translate('shop-modal.plans.three-month')
                                  .substring(0, 1),
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              textAlign: TextAlign.center),
                          Text(
                              translate('shop-modal.plans.three-month')
                                  .substring(2),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 0.8),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      width: 60,
                    ),
                    VerticalDivider(
                        color: Colors.black, indent: 5, endIndent: 5),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 0, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('1990 ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black)),
                              Text(translate('currencies.rub'),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('~',
                                  style: TextStyle(
                                      color: colorGrey, fontSize: 12)),
                              Text('165',
                                  style: TextStyle(
                                      color: colorGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              Text(' руб/ 7 дней',
                                  style: TextStyle(
                                      color: colorGrey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        child: Column(
                          children: [
                            Text(translate('66%'),
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: colorMain),
                                textAlign: TextAlign.center),
                            Text(translate('shop-modal.plans.discount'),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: colorMain,
                                    height: 0.9),
                                textAlign: TextAlign.center),
                          ],
                        ),
                        width: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  disabledColor: Colors.white,
                  child: Text(translate('shop-modal.buttons.not-now'),
                      style: TextStyle(
                          color: colorGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
                MaterialButton(
                  height: 38.0,
                  minWidth: 162.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  color: Color(0xff00E291),
                  child: Text(translate('shop-modal.buttons.buy'),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    print('onPressed');
                    final bool isAvailable = await _connection.isAvailable();
                    ProductDetailsResponse productDetailResponse =
                        await _connection
                            .queryProductDetails(_kProductIds.toSet());
                    print(productDetailResponse.notFoundIDs);
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.0,
      width: 120.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/infinity-profiles.png'),
        ),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(40, 200, 40, 0),
            child: Text(
              translate('shop-modal.slides.labels.infinity-profiles'),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.0,
      width: 120.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/infinity-profiles.png'),
        ),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
            child: Text(
              translate('shop-modal.slides.labels.previous-profile'),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.0,
      width: 100.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/who-did-you-like.png'),
        ),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
            child: Text(
              translate('shop-modal.slides.labels.who-did-you-like'),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
