import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomclone/device_info.dart';
import 'package:zoomclone/screen/login_sign_up_screen.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';

class Util {
  static String getFullName(String firstName, String lastName) {
    String fullName = "";
    if (isStringNotNull(firstName)) {
      fullName = firstName + " ";
    }
    if (isStringNotNull(lastName)) {
      fullName = fullName + lastName;
    }
    return fullName;
  }

  static bool isStringNotNull(String str) {
    if (str != null) {
      str = str.trim();
      if (str.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  static bool isValidList(List list) {
    if (list != null && list.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isCurrentUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId =
        prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
    return currentUserId == userId;
  }

  static Future<Map> getCurrentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId =
        prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
    final currentUserName =
        prefs.getString(SharedPreferenceConstant.CURRENT_USER_NAME);
    final currentUserEmail =
        prefs.getString(SharedPreferenceConstant.CURRENT_USER_EMAIL);
    final currentUserFirstName =
        prefs.getString(SharedPreferenceConstant.CURRENT_USER_FIRST_NAME);
    final currentUserLastName =
        prefs.getString(SharedPreferenceConstant.CURRENT_USER_LAST_NAME);
    final currentUserProfilePicUrl =
        prefs.getString(SharedPreferenceConstant.CURRENT_USER_PROFILE_PIC);
    Map body = Map();
    body['userId'] = currentUserId;
    body['userName'] = currentUserName;
    body['firstName'] = currentUserFirstName;
    body['lastName'] = currentUserLastName;
    body['profilePicUrl'] = currentUserProfilePicUrl;

    return body;
  }

  static String getSignatureOfName({String firstName, String lastName}) {
    String value = '';
    if (isStringNotNull(firstName)) {
      value = firstName.substring(0, 1);
    }
    if (isStringNotNull(lastName)) {
      value = value + lastName.substring(0, 1);
    }
    return value;
  }

  static Future<String> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId =
        prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
    return currentUserId;
  }

  static Future<void> showDatePickerBottomSheet(context, onSelectDate) async {
    await DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        theme: DatePickerTheme(
            backgroundColor: Colors.white70,
            cancelStyle: TextStyle(
              color: Colors.red,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto Condensed',
            ),
            doneStyle: TextStyle(
              color: Colors.blue,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto Condensed',
            ),
            itemStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto Condensed',
            )),
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(Duration(days: 365)),
        onChanged: (date) {}, onConfirm: (date) {
      onSelectDate(date.millisecondsSinceEpoch);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  static Future<void> showDOBDatePickerBottomSheet(
      context, onSelectDate) async {
    await DatePicker.showDatePicker(context,
        showTitleActions: true,
        theme: DatePickerTheme(
            backgroundColor: Colors.white70,
            cancelStyle: TextStyle(
              color: Colors.red,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto Condensed',
            ),
            doneStyle: TextStyle(
              color: Colors.blue,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto Condensed',
            ),
            itemStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto Condensed',
            )),
        maxTime: DateTime.now(),
        minTime: DateTime.now().subtract(Duration(days: 365 * 80)),
        onChanged: (date) {}, onConfirm: (date) {
      onSelectDate(date.millisecondsSinceEpoch);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  static Future<bool> requestAllPermission() async {
    List<PermissionGroup> permissionsList = [
      PermissionGroup.camera,
      PermissionGroup.microphone,
      PermissionGroup.storage,
    ];
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(permissionsList);

    if (permissions[PermissionGroup.camera] == PermissionStatus.granted &&
        permissions[PermissionGroup.microphone] == PermissionStatus.granted &&
        permissions[PermissionGroup.storage] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  static logOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (err) {
      print(err);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginSignUpScreen()),
    );
  }

  static Future<Map<String, dynamic>> loadDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> _deviceParameters = Map();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _deviceParameters = _loadAndroidParameters(androidInfo);
      return _deviceParameters;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _deviceParameters = _loadIosParameters(iosInfo);
      return _deviceParameters;
    }
  }

  static Map _loadAndroidParameters(AndroidDeviceInfo androidDeviceInfo) {
    Map<String, dynamic> _deviceParameters = Map();

    _deviceParameters["brand"] = androidDeviceInfo.brand;
    _deviceParameters["device"] = androidDeviceInfo.device;
    _deviceParameters["manufacturer"] = androidDeviceInfo.manufacturer;
    _deviceParameters["model"] = androidDeviceInfo.model;
    _deviceParameters["product"] = androidDeviceInfo.product;
    _deviceParameters["versionBaseOs"] = androidDeviceInfo.version.baseOS;
    _deviceParameters["versionCodename"] = androidDeviceInfo.version.codename;
    _deviceParameters["versionIncremental"] =
        androidDeviceInfo.version.incremental;
    _deviceParameters["versionPreviewSdk"] =
        androidDeviceInfo.version.previewSdkInt;
    _deviceParameters["versionRelase"] = androidDeviceInfo.version.release;
    _deviceParameters["versionSdk"] = androidDeviceInfo.version.sdkInt;
    _deviceParameters["versionSecurityPatch"] =
        androidDeviceInfo.version.securityPatch;

    return _deviceParameters;
  }

  static Map _loadIosParameters(IosDeviceInfo iosInfo) {
    Map<String, dynamic> _deviceParameters = Map();

    _deviceParameters["model"] = iosInfo.model;
    _deviceParameters["brand"] = iosInfo.isPhysicalDevice;
    _deviceParameters["device"] = iosInfo.name;
    _deviceParameters["versionBaseOs"] = iosInfo.identifierForVendor;
    _deviceParameters["manufacturer"] = iosInfo.localizedModel;
    _deviceParameters["product"] = iosInfo.systemName;
    _deviceParameters["versionCodename"] = iosInfo.utsname.version;
    _deviceParameters["versionRelase"] = iosInfo.utsname.release;
    _deviceParameters["versionSdk"] = iosInfo.utsname.machine;
    _deviceParameters["versionSecurityPatch"] = iosInfo.utsname.nodename;
    _deviceParameters["versionPreviewSdk"] = iosInfo.utsname.sysname;

    return _deviceParameters;
  }
}
