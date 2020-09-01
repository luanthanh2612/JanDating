import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/constants/styles.dart';

class WidgetProfilePhotoRequirements extends StatefulWidget {
//  Function(bool) showLoader;

  WidgetProfilePhotoRequirements();

  @override
  _WidgetProfilePhotoRequirementsState createState() =>
      _WidgetProfilePhotoRequirementsState();
}

class _WidgetProfilePhotoRequirementsState
    extends State<WidgetProfilePhotoRequirements> {
  List _rules = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        translate('add-photo-page.photo-requirements'),
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: colorGrey,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      translate(
                          'photo-requirements-modal.photo-requirements-title'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(translate(
                              'photo-requirements-modal.rule-${_rules[index]}')),
                        );
                      },
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      translate('buttons.okay'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textColor: colorMain,
                    disabledTextColor: Colors.grey,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: true,
        );
      },
    );
  }
}
