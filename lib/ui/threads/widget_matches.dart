import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';
import 'package:jan_app_flutter/ui/threads/page_chat.dart';
import 'package:provider/provider.dart';

class Matches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final UserModel currentUser = authProvider.currentUser;
    List<Map<String, dynamic>> matches;

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          height: 115.0,
          child: StreamBuilder(
            stream: firestoreDatabase.getMatchedListStream(currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return Center(
                    child: Text(
                  "No match found",
                  style: TextStyle(color: colorGrey, fontSize: 16),
                ));
              }

              if (snapshot.data.length == 0) {
                return Center(
                    child: Text(
                  "No match found",
                  style: TextStyle(color: colorGrey, fontSize: 16),
                ));
              }

              matches = snapshot.data;

              return ListView.builder(
                padding: EdgeInsets.only(left: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: matches.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ChatPage(
                          sender: currentUser,
                          chatId:
                              chatId(currentUser.uid, matches[index]['uid']),
                          //second: matches[index],
                          second: currentUser,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: colorGrey,
                            radius: 35.0,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                                imageUrl: currentUser.photoUrl,
                                //imageUrl: matches[index].photoUrl,
                                useOldImageOnUrlChange: true,
                                placeholder: (context, url) =>
                                    CupertinoActivityIndicator(
                                  radius: 15,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(height: 6.0),
                          Expanded(
                            child: Text(
                              // currentUser.firstName,
                              matches[index]['firstName'],
                              style: TextStyle(
                                color: colorGrey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}

var groupChatId;
chatId(String currentUserId, String senderId) {
  if (currentUserId.hashCode <= senderId.hashCode) {
    return groupChatId = '${currentUserId}-${senderId}';
  } else {
    return groupChatId = '${senderId}-${currentUserId}';
  }
}
