import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/bloc/main/main.dart';
import 'package:zoomclone/screen/home_screen.dart';
import 'package:zoomclone/screen/login_sign_up_screen.dart';
import 'package:zoomclone/screen/meeting_detail_screen.dart';
import 'package:zoomclone/screen/welcome_screen.dart';
import 'package:zoomclone/utils/util.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainBloc mainBloc = MainBloc();

  @override
  void initState() {
    _initShareIntent();
    super.initState();
  }

  _initShareIntent() async {
    try {
      Map data = await MethodChannel('app.channel.shared.data')
          .invokeMethod('getSharedData');
      if (data.isEmpty) {
        mainBloc.add(LoadMain());
        return;
      }
      if (data.containsKey('shared_link_click')) {
        String link = data['shared_link_click'];
        print(link);
        List linkDetail = link.split('/');
        mainBloc.add(LoadMain(meetingId: linkDetail.last));
      }
    } catch (_) {
      mainBloc.add(LoadMain());
      print(_);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'linkedUp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder(
        bloc: mainBloc,
        builder: (context, state) {
          if (state is MainLoaded) {
            if (!Util.isStringNotNull(state.userDetail['userId'])) {
              return LoginSignUpScreen();
            } else if (Util.isStringNotNull(state.userDetail['userId'])) {
              if (state.userDetail['isLoadWelcome'] != null &&
                  state.userDetail['isLoadWelcome']) {
                if (Util.isStringNotNull(state.meetingId)) {
                  return MeetingDetailScreen(
                    meetingId: state.meetingId,
                  );
                }
                return HomeScreen();
              } else {
                return WelcomeScreen();
              }
            } else {
              return LoginSignUpScreen();
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
