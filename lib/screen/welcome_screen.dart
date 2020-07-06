import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as inputFormatterx;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:zoomclone/api/google_api.dart';
import 'package:zoomclone/atoms/large_title.dart';
import 'package:zoomclone/atoms/text_big_title.dart';
import 'package:zoomclone/atoms/text_body_1.dart';
import 'package:zoomclone/atoms/text_input.dart';
import 'package:zoomclone/bloc/user_detail/user_detail.dart';
import 'package:zoomclone/bloc/welcome_screen/welcome_screen.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/dialogs/image_select_dialog.dart';
import 'package:zoomclone/molecule/auto_complete.dart';
import 'package:zoomclone/molecule/circle_image.dart';
import 'package:zoomclone/screen/image_preview_screen.dart';
import 'package:zoomclone/screen/user_info_screen.dart';
import 'package:zoomclone/shimmer/circle_shimmer.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/empty_place_holder.dart';

class WelcomeScreen extends StatelessWidget {
  final WelcomeScreenBloc welcomeScreenBloc = WelcomeScreenBloc();
  final WelcomeScreenBloc updateInfoBloc = WelcomeScreenBloc();

  WelcomeScreen() {
    welcomeScreenBloc.add(LoadWelcomeScreen());
  }

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController livingInEditingController =
      TextEditingController();
  final UserDetailBloc uploadProfilePhoto = UserDetailBloc();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: Scaffold(
        body: BlocListener(
          bloc: updateInfoBloc,
          listener: (context, state) {
            if (state is UpdateUserInfoWelcomeLoaded) {
              if (state.data['isUserNameAvailable'] != null &&
                  state.data['isUserNameAvailable']) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserInfoScreen()),
                );
              } else {
                Toast.show(
                  Strings.USER_NAME_IS_NOT_AVAILABLE,
                  context,
                  gravity: Toast.CENTER,
                  duration: Toast.LENGTH_LONG,
                );
              }
            }
          },
          child: BlocListener(
            bloc: welcomeScreenBloc,
            listener: (context, state) {
              if (state is WelcomeScreenLoaded) {
                userNameController.text = state.data['userName'];
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: BlocBuilder(
                bloc: welcomeScreenBloc,
                builder: (context, state) {
                  if (state is WelcomeScreenLoading) {
                    return WaveLoader.spinKit();
                  } else if (state is WelcomeScreenLoaded) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: LargeTitle(
                              Strings.WELCOME,
                              textAlign: TextAlign.center,
                              shadowEnabled: true,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: TextBigTitle(
                                state.data['userName'] ?? '',
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 58),
                            child: Row(
                              children: <Widget>[
                                BlocBuilder(
                                    bloc: uploadProfilePhoto,
                                    builder: (context, userProfilePhotoState) {
                                      if (userProfilePhotoState
                                          is UserProfilePhotoUpdating) {
                                        return CircleShimmer(
                                          height: 88,
                                          width: 88,
                                        );
                                      } else if (userProfilePhotoState
                                          is UserProfilePhotoUpdated) {
                                        updateSharedPrefImage(
                                            userProfilePhotoState.data['path']);
                                        return Container(
                                          height: 99,
                                          width: 99,
                                          color: Colors.transparent,
                                          child: Stack(
                                            overflow: Overflow.visible,
                                            children: <Widget>[
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: GestureDetector(
                                                      onTap: () =>
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ImagePreviewScreen(
                                                                            image:
                                                                                userProfilePhotoState.data['path'],
                                                                          ))),
                                                      child: Hero(
                                                        tag: 'imageView',
                                                        child:
                                                            CircleImageWithBorder(
                                                          userProfilePhotoState
                                                              .data['path'],
                                                          signature: Util
                                                              .getSignatureOfName(
                                                                  firstName: state
                                                                          .data[
                                                                      'firstName'],
                                                                  lastName: state
                                                                          .data[
                                                                      'lastName']),
                                                        ),
                                                      ))),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      openGallery(context),
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    width: 44.0,
                                                    height: 44.0,
                                                    child: Icon(
                                                      Icons.photo_camera,
                                                      size: 30.0,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          height: 99,
                                          width: 99,
                                          color: Colors.transparent,
                                          child: Stack(
                                            overflow: Overflow.visible,
                                            children: <Widget>[
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: GestureDetector(
                                                      onTap: () =>
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ImagePreviewScreen(
                                                                            image:
                                                                                state.data['profilePicUrl'],
                                                                          ))),
                                                      child: Hero(
                                                        tag: 'imageView',
                                                        child:
                                                            CircleImageWithBorder(
                                                          state.data[
                                                              'profilePicUrl'],
                                                          signature: Util
                                                              .getSignatureOfName(
                                                                  firstName: state
                                                                          .data[
                                                                      'firstName'],
                                                                  lastName: state
                                                                          .data[
                                                                      'lastName']),
                                                        ),
                                                      ))),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      openGallery(context),
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    width: 44.0,
                                                    height: 44.0,
                                                    child: Icon(
                                                      Icons.photo_camera,
                                                      size: 30.0,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }),
                                SizedBox(
                                  width: 16,
                                ),
                                Flexible(
                                  child: TextInput(
                                    enabled: true,
                                    controller: userNameController,
                                    textColor: Colors.black,
                                    fontSize: 20,
                                    hintText: Strings.ENTER_USER_NAME,
                                    label: Strings.ENTER_USER_NAME,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextInput(
                                    controller: firstNameController,
                                    textColor: Colors.black,
                                    fontSize: 20,
                                    hintText: Strings.ENTER_FIRST_NAME,
                                    label: Strings.ENTER_FIRST_NAME,
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Flexible(
                                  child: TextInput(
                                    controller: lastNameController,
                                    textColor: Colors.black,
                                    fontSize: 20,
                                    hintText: Strings.ENTER_LAST_NAME,
                                    label: Strings.ENTER_LAST_NAME,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 16),
                            child: AutoComplete(
                              textEditingController: livingInEditingController,
                              labelText: Strings.LIVING_IN,
                              hintText: 'Start typing to get suggestions',
                              itemBuilder: (BuildContext context, itemData) {
                                return Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextBody1(
                                    itemData['description'],
                                    color: Colors.black,
                                    shadowEnabled: false,
                                  ),
                                );
                              },
                              suggestionSelectionCallback: (suggestion) {
                                String address = suggestion['description'];
                                livingInEditingController.text = address;
                              },
                              suggestionsCallback: (String pattern) async {
                                List locations = await GoogleApiClient()
                                    .getWaveLikeList(pattern);
                                return locations;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 42,
                          ),
                          BlocBuilder(
                            bloc: updateInfoBloc,
                            builder: (context, state) {
                              if (state is UpdateUserInfoWelcomeLoading) {
                                return WaveLoader.spinKit(size: 20);
                              } else {
                                return RoundedShapeButton(
                                  text: Strings.CONTINUE,
                                  onPressed: () {
                                    updateProfile(context);
                                  },
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: EmptyPlaceHolder());
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateProfile(context) {
    if (Util.isStringNotNull(firstNameController.text) &&
        Util.isStringNotNull(lastNameController.text) &&
        Util.isStringNotNull(livingInEditingController.text) &&
        Util.isStringNotNull(userNameController.text) && Util.isAlpha(firstNameController.text) && Util.isAlpha(lastNameController.text)) {
      Map body = Map();
      body['userName'] = userNameController.text;
      body['firstName'] = firstNameController.text;
      body['lastName'] = lastNameController.text;
      body['location'] = livingInEditingController.text;
      updateInfoBloc.add(SendUserData(userInfo: body));
    } else {
      Toast.show(
        Strings.PLEASE_ENTER_VALID_DATA,
        context,
        gravity: Toast.CENTER,
        duration: Toast.LENGTH_LONG,
      );
    }
  }

  openGallery(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 20,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.white,
                width: 1.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            content: ImageSelectDialog(onSelectGallery, onClickSave),
          );
        });
  }

  onClickSave(String url) {
    uploadProfilePhoto.add(UploadProfilePhoto(url: url));
  }

  onSelectGallery() async {
    var gallery = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    uploadProfilePhoto.add(UploadProfilePhoto(imageFile: gallery));
  }

  void updateSharedPrefImage(imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        SharedPreferenceConstant.CURRENT_USER_PROFILE_PIC, imageUrl);
  }
}
