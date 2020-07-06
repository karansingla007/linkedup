import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_big_button.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isVidoMute = false;
  bool isAudioMute = false;


  @override
  void initState() {
    super.initState();
    getData();

  }

  void getData() async{
    if(mounted) {
      final prefs = await SharedPreferences.getInstance();
      isAudioMute = prefs.getBool(SharedPreferenceConstant.MUTE_AUDIO_ALWAYS) ?? false;
      isVidoMute = prefs.getBool(SharedPreferenceConstant.MUTE_VIDEO_ALWAYS) ?? false;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextHero('Settings'),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextBigButton('Mute audio when join any meeting', fontWeight: FontWeight.bold,),
                    SizedBox(height: 4,),
                    TextSmallTitle('Mute audio always when you join any meeting'),
                  ],
                ),
               Expanded(child: Container(),),
               Switch(value: isAudioMute, onChanged: (status) async{
                 final prefs = await SharedPreferences.getInstance();
                 prefs.setBool(SharedPreferenceConstant.MUTE_AUDIO_ALWAYS, status);
               },),
              ],
            ),

            SizedBox(height: 4,),
            Container(height: 1, color: Colors.black26,),
            SizedBox(height: 4,),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextBigButton('Mute video when join any meeting', fontWeight: FontWeight.bold,),
                      SizedBox(height: 4,),
                      TextSmallTitle('Mute video always when you join any meeting'),
                    ],
                  ),
                ),
                Expanded(child: Container(),),
                Switch(value: isVidoMute, onChanged: (status) async{
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool(SharedPreferenceConstant.MUTE_VIDEO_ALWAYS, status);
                },),
              ],
            ),
          ],
        ),
      ),
    );
  }
}