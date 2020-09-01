import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/models/alcohol.dart';
import 'package:jan_app_flutter/models/education.dart';
import 'package:jan_app_flutter/models/kids.dart';
import 'package:jan_app_flutter/models/marital_status.dart';
import 'package:jan_app_flutter/models/occupation.dart';
import 'package:jan_app_flutter/models/smoking.dart';
import 'package:jan_app_flutter/models/sport.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/models/zodiac_signs.dart';
import 'package:provider/provider.dart';
import 'package:jan_app_flutter/constants/styles.dart';

class WidgetProfileFields extends StatefulWidget {
  WidgetProfileFields({this.currentUser, this.index});

  final UserModel currentUser;
  final int index;

  @override
  _WidgetProfileFieldsState createState() =>
      _WidgetProfileFieldsState(currentUser);
}

class _WidgetProfileFieldsState extends State<WidgetProfileFields> {
  _WidgetProfileFieldsState(this.currentUser);

  final UserModel currentUser;

  int _height;
  List _heightOptions = [];
  int _weight;
  List _weightOptions = [];
  List<DocumentSnapshot> _education = [];
  dynamic educationState;
  int _selectedEducation;
  List<DocumentSnapshot> _occupation = [];
  dynamic occupationState;
  int _selectedOccupation;
  List<DocumentSnapshot> _smoking = [];
  dynamic smokingState;
  int _selectedSmoking;
  List<DocumentSnapshot> _alcohol = [];
  dynamic alcoholState;
  int _selectedAlcohol;
  List<DocumentSnapshot> _sport = [];
  dynamic sportState;
  int _selectedSport;
  List<DocumentSnapshot> _marital = [];
  dynamic maritalState;
  int _selectedMarital;
  List<DocumentSnapshot> _kids = [];
  dynamic kidsState;
  int _selectedKids;
  List<DocumentSnapshot> _zodiac = [];
  dynamic zodiacState;
  int _selectedZodiac;

  setEducation() {
    setState(() {
      _education = educationState.education;
      if (currentUser.education != null) {
        _selectedEducation = Provider.of<EducationState>(context, listen: false)
            .education
            .map((e) => e.reference.path)
            .toList()
            .indexOf(currentUser.education.path);
      }
    });
  }

  setOccupation() {
    setState(() {
      _occupation = occupationState.occupation;
      if (currentUser.occupation != null) {
        _selectedOccupation =
            Provider.of<OccupationState>(context, listen: false)
                .occupation
                .map((e) => e.reference.path)
                .toList()
                .indexOf(currentUser.occupation.path);
      }
    });
  }

  setSmoking() {
    setState(() {
      _smoking = smokingState.smoking;
      if (currentUser.smoking != null) {
        _selectedSmoking = Provider.of<SmokingState>(context, listen: false)
            .smoking
            .map((e) => e.reference.path)
            .toList()
            .indexOf(currentUser.smoking.path);
      }
    });
  }

  setAlcohol() {
    setState(() {
      _alcohol = alcoholState.alcohol;
      if (currentUser.alcohol != null) {
        _selectedAlcohol = Provider.of<AlcoholState>(context, listen: false)
            .alcohol
            .map((e) => e.reference.path)
            .toList()
            .indexOf(currentUser.alcohol.path);
      }
    });
  }

  setSport() {
    setState(() {
      _sport = sportState.sport;
      if (currentUser.sport != null) {
        _selectedSport = Provider.of<SportState>(context, listen: false)
            .sport
            .map((e) => e.reference.path)
            .toList()
            .indexOf(currentUser.sport.path);
      }
    });
  }

  setMarital() {
    setState(() {
      _marital = maritalState.maritalStatus;
      if (currentUser.maritalStatus != null) {
        _selectedMarital =
            Provider.of<MaritalStatusState>(context, listen: false)
                .maritalStatus
                .map((e) => e.reference.path)
                .toList()
                .indexOf(currentUser.maritalStatus.path);
      }
    });
  }

  setKids() {
    setState(() {
      _kids = kidsState.kids;
      if (currentUser.kids != null) {
        _selectedKids = Provider.of<KidsState>(context, listen: false)
            .kids
            .map((e) => e.reference.path)
            .toList()
            .indexOf(currentUser.kids.path);
      }
    });
  }

  setZodiac() {
    setState(() {
      _zodiac = zodiacState.zodiac;
      if (currentUser.zodiacSign != null) {
        _selectedZodiac = Provider.of<ZodiacSignsState>(context, listen: false)
            .zodiac
            .map((e) => e.reference.path)
            .toList()
            .indexOf(currentUser.zodiacSign.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    switch (widget.index) {
      case 2:
        educationState.removeListener(setEducation);
        break;
      case 3:
        occupationState.removeListener(setOccupation);
        break;
      case 4:
        smokingState.removeListener(setSmoking);
        break;
      case 5:
        alcoholState.removeListener(setAlcohol);
        break;
      case 6:
        sportState.removeListener(setSport);
        break;
      case 7:
        maritalState.removeListener(setMarital);
        break;
      case 8:
        kidsState.removeListener(setKids);
        break;
      case 9:
        zodiacState.removeListener(setZodiac);
        break;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.index) {
      case 0:
        if (_height == null) {
          _height = currentUser.height - 100;
        }
        for (var i = 100; i < 241; i++) {
          var realFeet = ((i * 0.393700) / 12);
          var feet = (realFeet).floor();
          var inches = ((realFeet - feet) * 12).round();

          _heightOptions
              .add('$i ${translate("enter-height-page.cm")} ($feet\'$inches")');
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: colorMain,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                padding: EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 200,
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Align(
                                  alignment: FractionalOffset(1, 1),
                                  child: FlatButton(
                                    child: Text(
                                      translate(
                                          'search-filter.languages-filter.ready-button'),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: colorMain),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                      initialItem:
                                          _height != null ? _height : 70),
                                  itemExtent: 45.0,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      _height = index;
                                    });
                                  },
                                  children: new List<Widget>.generate(
                                    _heightOptions.length,
                                    (int index) {
                                      return new Center(
                                        child: new Text(
                                            '${_heightOptions[index]}'),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).whenComplete(() {
                      currentUser.setHeight(_height + 100);
                    });
                  },
                  child: Text(
                    _height != null
                        ? '${_heightOptions[_height]}'
                        : translate(
                            'enter-height-page.height-input-placeholder'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ),
            ],
          ),
        );
      case 1:
        if (_weight == null) {
          _weight = currentUser.weight != null ? currentUser.weight - 30 : null;
        }
        for (var i = 30; i < 250; i++) {
          var lb = (i * 2.2046).toStringAsFixed(0);

          _weightOptions.add(
              '$i ${translate("questionnaire-modal.kg")} ($lb ${translate("questionnaire-modal.lb")})');
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: colorMain,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                padding: EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 200,
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Align(
                                  alignment: FractionalOffset(1, 1),
                                  child: FlatButton(
                                    child: Text(
                                      translate(
                                          'search-filter.languages-filter.ready-button'),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: colorMain),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                      initialItem:
                                          _weight != null ? _weight : 40),
                                  itemExtent: 45.0,
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      _weight = index;
                                    });
                                  },
                                  children: new List<Widget>.generate(
                                    _weightOptions.length,
                                    (int index) {
                                      return new Center(
                                        child: new Text(
                                            '${_weightOptions[index]}'),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).whenComplete(() {
                      currentUser
                          .setWeight(_weight != null ? _weight + 30 : null);
                    });
                  },
                  child: Text(
                    _weight != null
                        ? '${_weightOptions[_weight]}'
                        : translate('questionnaire-modal.placeholders.weight'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ),
              _weight != null
                  ? FlatButton(
                      child: Text(translate('buttons.cancel')),
                      onPressed: () {
                        setState(() {
                          _weight = null;
                        });
                        currentUser.setWeight(null);
                      },
                    )
                  : Container(),
            ],
          ),
        );
      case 2:
        educationState = context.watch<EducationState>();
        setEducation();
        educationState.addListener(setEducation);

        return _displayList(
          _education,
          _selectedEducation,
          (index) {
            setState(() {
              if (_selectedEducation != index) {
                _selectedEducation = index;
                currentUser
                    .setEducation(_education[_selectedEducation].reference);
              } else {
                _selectedEducation = null;
                currentUser.setEducation(null);
              }
            });
          },
        );
      case 3:
        occupationState = context.watch<OccupationState>();
        setOccupation();
        occupationState.addListener(setOccupation);

        return _displayList(
          _occupation,
          _selectedOccupation,
          (index) {
            setState(() {
              if (_selectedOccupation != index) {
                _selectedOccupation = index;
                currentUser
                    .setOccupation(_occupation[_selectedOccupation].reference);
              } else {
                _selectedOccupation = null;
                currentUser.setOccupation(null);
              }
            });
          },
        );
      case 4:
        smokingState = context.watch<SmokingState>();
        setSmoking();
        smokingState.addListener(setSmoking);

        return _displayList(
          _smoking,
          _selectedSmoking,
          (index) {
            setState(() {
              if (_selectedSmoking != index) {
                _selectedSmoking = index;
                currentUser.setSmoking(_smoking[_selectedSmoking].reference);
              } else {
                _selectedSmoking = null;
                currentUser.setSmoking(null);
              }
            });
          },
        );
      case 5:
        alcoholState = context.watch<AlcoholState>();
        setAlcohol();
        alcoholState.addListener(setAlcohol);

        return _displayList(
          _alcohol,
          _selectedAlcohol,
          (index) {
            setState(() {
              if (_selectedAlcohol != index) {
                _selectedAlcohol = index;
                currentUser.setAlcohol(_alcohol[_selectedAlcohol].reference);
              } else {
                _selectedAlcohol = null;
                currentUser.setAlcohol(null);
              }
            });
          },
        );
      case 6:
        sportState = context.watch<SportState>();
        setSport();
        sportState.addListener(setSport);

        return _displayList(
          _sport,
          _selectedSport,
          (index) {
            setState(() {
              if (_selectedSport != index) {
                _selectedSport = index;
                currentUser.setSport(_sport[_selectedSport].reference);
              } else {
                _selectedSport = null;
                currentUser.setSport(null);
              }
            });
          },
        );
      case 7:
        maritalState = context.watch<MaritalStatusState>();
        setMarital();
        maritalState.addListener(setMarital);

        return _displayList(
          _marital,
          _selectedMarital,
          (index) {
            setState(() {
              if (_selectedMarital != index) {
                _selectedMarital = index;
                currentUser
                    .setMaritalStatus(_marital[_selectedMarital].reference);
              } else {
                _selectedMarital = null;
                currentUser.setMaritalStatus(null);
              }
            });
          },
        );
      case 8:
        kidsState = context.watch<KidsState>();
        setKids();
        kidsState.addListener(setKids);

        return _displayList(
          _kids,
          _selectedKids,
          (index) {
            setState(() {
              if (_selectedKids != index) {
                _selectedKids = index;
                currentUser.setKids(_kids[_selectedKids].reference);
              } else {
                _selectedKids = null;
                currentUser.setKids(null);
              }
            });
          },
        );
      case 9:
        zodiacState = context.watch<ZodiacSignsState>();
        setZodiac();
        zodiacState.addListener(setZodiac);

        return _displayList(
          _zodiac,
          _selectedZodiac,
          (index) {
            setState(() {
              if (_selectedZodiac != index) {
                _selectedZodiac = index;
                currentUser.setZodiacSign(_zodiac[_selectedZodiac].reference);
              } else {
                _selectedZodiac = null;
                currentUser.setZodiacSign(null);
              }
            });
          },
        );
      default:
        return Container();
    }
  }

  Widget _displayList(List<DocumentSnapshot> array, selectedIndex, callback) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        itemCount: array.length,
        itemBuilder: (BuildContext context, int index) {
          final data = array[index].data();
          return GestureDetector(
            onTap: () => callback(index),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 15.0),
              decoration: BoxDecoration(
                color:
                    (selectedIndex == index) ? colorMain : Colors.transparent,
                border: Border.all(
                  width: 2,
                  color: colorMain,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              padding: EdgeInsets.all(18),
              child: Text(
                translate('${data['label']}'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    color:
                        (selectedIndex == index) ? Colors.white : Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
