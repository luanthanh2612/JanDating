import 'package:flutter/material.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'widget_matches.dart';
import 'widget_recent_chats.dart';

class ThreadsScreen extends StatefulWidget {
  final UserModel currentUser;
  final List<UserModel> matches;
  final List<UserModel> newmatches;
  ThreadsScreen(this.currentUser, this.matches, this.newmatches);

  @override
  _ThreadsScreenState createState() => _ThreadsScreenState();
}

class _ThreadsScreenState extends State<ThreadsScreen> {
  @override
  void initState() {
//    Future.delayed(Duration(milliseconds: 500), () {
//      if (widget.matches.length > 0 && widget.matches[0].lastmsg != null) {
//        widget.matches.sort((a, b) {
//          var adate = a.lastmsg; //before -> var adate = a.expiry;
//          var bdate = b.lastmsg; //before -> var bdate = b.expiry;
//          return bdate?.compareTo(
//              adate); //to get the order other way just switch `adate & bdate`
//        });
//        setState(() {});
//      }
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorMain,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Matches(),
              Divider(),
              RecentChats(widget.currentUser, widget.matches),
            ],
          ),
        ),
      ),
    );
  }
}
