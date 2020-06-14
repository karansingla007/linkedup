import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:zoomclone/api/google_api.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_body_1.dart';
import 'package:zoomclone/atoms/text_input.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/bloc/user_detail/user_detail.dart';
import 'package:zoomclone/buttons/shape_button_small.dart';
import 'package:zoomclone/custom/radio_light.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/dialogs/image_select_dialog.dart';
import 'package:zoomclone/molecule/auto_complete.dart';
import 'package:zoomclone/molecule/circle_image.dart';
import 'package:zoomclone/screen/image_preview_screen.dart';
import 'package:zoomclone/shimmer/circle_shimmer.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/empty_place_holder.dart';

class EditProfile extends StatelessWidget {
  final TextEditingController firstNameTextEditingController =
      TextEditingController();
  final TextEditingController lastNameTextEditingController =
      TextEditingController();
  final TextEditingController designationEditingController =
      TextEditingController();
  final TextEditingController collegeEditingController =
      TextEditingController();
  final TextEditingController livingInEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController userNameTextEditingController =
      TextEditingController();
  String userType;

  final UserDetailBloc userDetailBloc = UserDetailBloc();
  final UserDetailBloc updateUserDetailBloc = UserDetailBloc();
  final UserDetailBloc uploadProfilePhoto = UserDetailBloc();

  EditProfile() {
    userDetailBloc.add(LoadUserInfo());
  }

  void saveProfileChanges(context) {
    if (isValidate()) {
      Map body = Map();
      body['userName'] = userNameTextEditingController.text;
      body['firstName'] = firstNameTextEditingController.text;
      body['lastName'] = lastNameTextEditingController.text;
      body['location'] = livingInEditingController.text;
      body['designation'] = designationEditingController.text;
      body['company'] = collegeEditingController.text;
      body['email'] = emailTextEditingController.text;
      body['mobileNumber'] = phoneNumberTextEditingController.text;
      body['userType'] = userType;
      updateUserDetailBloc.add(UpdateUserDetail(userInfo: body));
    } else {
      Toast.show(
        Strings.PLEASE_ENTER_VALID_DATA,
        context,
        gravity: Toast.CENTER,
        duration: Toast.LENGTH_LONG,
      );
    }
  }

  bool isValidate() {
    return Util.isStringNotNull(userNameTextEditingController.text) &&
        Util.isStringNotNull(firstNameTextEditingController.text) &&
        Util.isStringNotNull(lastNameTextEditingController.text) &&
        Util.isStringNotNull(livingInEditingController.text);
  }

  void updateSharedPrefInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceConstant.CURRENT_USER_NAME,
        userNameTextEditingController.text);
    prefs.setString(SharedPreferenceConstant.CURRENT_USER_FIRST_NAME,
        firstNameTextEditingController.text);
    prefs.setString(SharedPreferenceConstant.CURRENT_USER_LAST_NAME,
        lastNameTextEditingController.text);
    prefs.setString(SharedPreferenceConstant.CURRENT_USER_LOCATION,
        livingInEditingController.text);
    prefs.setString(SharedPreferenceConstant.CURRENT_USER_DESIGNATION,
        designationEditingController.text);
  }

  void updateSharedPrefImage(imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        SharedPreferenceConstant.CURRENT_USER_PROFILE_PIC, imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: <Widget>[
            TextHero('Edit Profile'),
            Expanded(
              child: Container(),
            ),
            BlocListener(
              bloc: updateUserDetailBloc,
              listener: (context, state) {
                if (state is UserDetailUpdated) {
                  if (state.data['isUserNameAvailable']) {
                    updateSharedPrefInfo();
                    Toast.show(
                      Strings.PROFILE_UPDATE,
                      context,
                      gravity: Toast.CENTER,
                      duration: Toast.LENGTH_LONG,
                    );
                    Navigator.pop(context);
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
              child: BlocBuilder(
                bloc: updateUserDetailBloc,
                builder: (context, state) {
                  if (state is UserDetailUpdating) {
                    return WaveLoader.spinKit(size: 20);
                  } else {
                    return ShapeButtonSmall(
                      text: 'SAVE',
                      width: 60,
                      height: 30,
                      color: Colors.white,
                      onPressed: () {
                        saveProfileChanges(context);
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: BlocListener(
        bloc: userDetailBloc,
        listener: (context, state) {
          if (state is UserDetailLoaded) {
            firstNameTextEditingController.text = state.data['firstName'];
            lastNameTextEditingController.text = state.data['lastName'];
            lastNameTextEditingController.text = state.data['lastName'];
            designationEditingController.text = state.data['designation'];
            collegeEditingController.text = state.data['company'];
            livingInEditingController.text = state.data['location'];
            emailTextEditingController.text = state.data['email'];
            phoneNumberTextEditingController.text = state.data['mobileNumber'];
            userNameTextEditingController.text = state.data['userName'];
            userType = state.data['userType'];
          }
        },
        child: BlocBuilder(
          bloc: userDetailBloc,
          builder: (context, state) {
            if (state is UserDetailLoaded) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          BlocBuilder(
                            bloc: uploadProfilePhoto,
                            builder: (context, userProfilePhotoState) {
                              if (userProfilePhotoState
                                  is UserProfilePhotoUpdating) {
                                return CircleShimmer(
                                  height: 99,
                                  width: 99,
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
                                          alignment: Alignment.bottomCenter,
                                          child: GestureDetector(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImagePreviewScreen(
                                                            image:
                                                                userProfilePhotoState
                                                                        .data[
                                                                    'path'],
                                                          ))),
                                              child: Hero(
                                                tag: 'imageView',
                                                child: CircleImageWithBorder(
                                                  userProfilePhotoState
                                                      .data['path'],
                                                  signature:
                                                      Util.getSignatureOfName(
                                                          firstName: state.data[
                                                              'firstName'],
                                                          lastName: state.data[
                                                              'lastName']),
                                                ),
                                              ))),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () => openGallery(context),
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
                                          alignment: Alignment.bottomCenter,
                                          child: GestureDetector(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImagePreviewScreen(
                                                            image: state.data[
                                                                'profilePicUrl'],
                                                          ))),
                                              child: Hero(
                                                tag: 'imageView',
                                                child: CircleImageWithBorder(
                                                  state.data['profilePicUrl'],
                                                  signature:
                                                      Util.getSignatureOfName(
                                                          firstName: state.data[
                                                              'firstName'],
                                                          lastName: state.data[
                                                              'lastName']),
                                                ),
                                              ))),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () => openGallery(context),
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
                            },
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextInput(
                                label: 'Username',
                                controller: userNameTextEditingController,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, top: 32),
                        child: TextSmallTitle(
                          'Basic Information',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, top: 16, bottom: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextInput(
                                  label: 'First Name',
                                  controller: firstNameTextEditingController,
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextInput(
                                  label: 'Last Name',
                                  controller: lastNameTextEditingController,
                                  keyboardType: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 24.0,
                        ),
                        child: TextSmallTitle('Designation'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RadioLight(
                                    width: 140,
                                    labels: <String>[
                                      Strings.STUDENT,
                                      Strings.PROFESSIONAL,
                                    ],
                                    picked: userType,
                                    activeColor: Colors.blue,
                                    orientation:
                                        RadioGroupedButtonsOrientation.WRAP,
                                    onSelected: (String value) {
                                      userType = value;
                                    },
                                  ),
                                  TextInput(
                                    label: 'Studying/Designation',
                                    controller: designationEditingController,
                                    keyboardType: TextInputType.text,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextInput(
                                    label: 'College/Company',
                                    controller: collegeEditingController,
                                    keyboardType: TextInputType.text,
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: TextSmallTitle(Strings.PERSONALISE),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
//                      TextSmallTitle(Strings.AGE_RANGE),

                                AutoComplete(
                                  textEditingController:
                                      livingInEditingController,
                                  labelText: Strings.LIVING_IN,
                                  hintText: 'Start typing to get suggestions',
                                  labelStyle: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                  hintStyle: TextStyle(
                                      color: Colors.black26, fontSize: 14),
                                  itemBuilder:
                                      (BuildContext context, itemData) {
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
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: TextSmallTitle(Strings.ACCOUNT_SETTINGS),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, bottom: 16.0, left: 16, right: 16),
                            child: Column(
                              children: <Widget>[
                                TextInput(
                                  controller: emailTextEditingController,
                                  hintText: 'Email Address',
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextInput(
                                  readOnly: true,
                                  controller: phoneNumberTextEditingController,
                                  hintText: 'Phone Number',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is UserDetailLoading) {
              return WaveLoader.spinKit();
            } else {
              return EmptyPlaceHolder(
                text: Strings.SOMETHING_WENT_WRONG,
              );
            }
          },
        ),
      ),
    );
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
              borderRadius:
              BorderRadius.circular(8.0),
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
}
