import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:jan_app_flutter/constants//styles.dart';

// ignore: must_be_immutable
class WidgetProfilePhoto extends StatefulWidget {
  Function(bool) showLoader;
  final List<PhotoModel> photos;

  WidgetProfilePhoto({this.photos, this.showLoader});

  @override
  _WidgetProfilePhotoState createState() =>
      _WidgetProfilePhotoState(photos: photos);
}

class _WidgetProfilePhotoState extends State<WidgetProfilePhoto> {
  _WidgetProfilePhotoState({this.photos});

  final picker = ImagePicker();
  final List<PhotoModel> photos;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        children: [
          _renderImageBlock(0, authProvider),
          _renderImageBlock(1, authProvider),
          _renderImageBlock(2, authProvider),
          _renderImageBlock(3, authProvider),
          _renderImageBlock(4, authProvider),
          _renderImageBlock(5, authProvider),
        ],
      ),
    );
  }

  _renderImageBlock(index, authProvider) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 30,
      height: MediaQuery.of(context).size.height / 4.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: photos.length >= index
                  ? colorMain
                  : colorMain.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: DragTarget(
            onWillAccept: (value) => photos.length > index,
            onAccept: (value) {
              setState(() {
                final photo = photos[value];
                photos.removeAt(value);
                photos.insert(index, photo);
                setUserState(authProvider.currentUser);
              });
            },
            builder: (BuildContext context, List<dynamic> candidateData,
                List<dynamic> rejectedData) {
              return photos.length <= index
                  ? Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 0.5,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          color: colorMain,
                          onPressed: photos.length >= index
                              ? () => onSelectPhoto(index, authProvider)
                              : null,
                        ),
                      ),
                    )
                  : Draggable(
                      data: index,
                      feedback: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Opacity(
                            opacity: 0.6,
                            child: CachedNetworkImage(
                                height:
                                    MediaQuery.of(context).size.height / 4.5 -
                                        25,
                                width:
                                    MediaQuery.of(context).size.width / 3 - 30,
                                fit: BoxFit.cover,
                                imageUrl: photos[index].url,
                                placeholder: (context, url) => Center(
                                      child: Platform.isIOS
                                          ? CupertinoActivityIndicator()
                                          : CircularProgressIndicator(),
                                    )),
                          )),
                      child: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: CachedNetworkImage(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                imageUrl: photos[index].url,
                                placeholder: (context, url) => Center(
                                      child: Platform.isIOS
                                          ? CupertinoActivityIndicator()
                                          : CircularProgressIndicator(),
                                    )),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 0.5,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.remove),
                                color: colorMain,
                                onPressed: photos.length > 1
                                    ? () {
                                        setState(() {
                                          photos.removeAt(index);
                                          setUserState(
                                              authProvider.currentUser);
                                        });
                                      }
                                    : () => showErrorNotification(
                                        context,
                                        translate(
                                            'photo-deletion-warning-modal.message')),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  onSelectPhoto(index, authProvider) {
    showModalBottomSheet(
        context: context,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(30.0),
            topRight: const Radius.circular(30.0),
          ),
        ),
        builder: (context) {
          return Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    translate('add-photo-page.action-sheet.title'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.attach_file, color: colorMain),
                  title: Text(
                      translate('add-photo-page.action-sheet.gallery-button')),
                  onTap: () =>
                      getImage(ImageSource.gallery, authProvider, index),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: colorMain),
                  title: Text(translate(
                      'add-photo-page.action-sheet.take-photo-button')),
                  onTap: () =>
                      getImage(ImageSource.camera, authProvider, index),
                ),
              ],
            ),
          );
        });
  }

  Future getImage(source, authProvider, index) async {
    Navigator.pop(context);

    widget.showLoader(true);
    var pickedFile;

    try {
      pickedFile = await picker.getImage(
        source: source,
        maxWidth: 640,
        preferredCameraDevice: CameraDevice.front,
      );
    } catch (e) {
      widget.showLoader(false);
      showErrorNotification(
          context,
          (source == ImageSource.camera)
              ? translate('error-message.camera-permission-denied')
              : translate('error-message.gallery-permission-denied'));
    }

    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop',
              toolbarColor: colorMain,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      if (croppedFile != null) {
        final StorageReference storageReference = FirebaseStorage()
            .ref()
            .child('profile-photos')
            .child(authProvider.currentUser.uid)
            .child('${DateTime.now().toIso8601String()}.png');

        final StorageUploadTask uploadTask =
            storageReference.putData(await croppedFile.readAsBytes());

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          // You can use this to notify yourself or your user in any kind of way.
          // For example: you could use the uploadTask.events stream in a StreamBuilder instead
          // to show your user what the current status is. In that case, you would not need to cancel any
          // subscription as StreamBuilder handles this automatically.

          // Here, every StorageTaskEvent concerning the upload is printed to the logs.
          // print('EVENT ${event.type}');
        });

        await uploadTask.onComplete;
        streamSubscription.cancel();

        final photo = PhotoModel(
          path: await storageReference.getPath(),
          url: await storageReference.getDownloadURL(),
        );

        setState(() {
          //_photos.add(photo);
          //_photosRef.add(photoRef);
          photos.add(photo);
          setUserState(authProvider.currentUser);
        });
      }
      widget.showLoader(false);
    } else {
      widget.showLoader(false);
    }
  }

  setUserState(UserModel user) {
    user.setPhotos(photos);
  }
}
