import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/bloc/user_detail/user_detail.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/screen/create_feedback_screen.dart';
import 'package:zoomclone/screen/edit_profile.dart';
import 'package:zoomclone/screen/my_meetings_screen.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/profile_action_widget.dart';
import 'package:zoomclone/widgets/short_user_info_widget.dart';

class ProfileScreen extends StatelessWidget {
  final UserDetailBloc userDetailBloc = UserDetailBloc();

  ProfileScreen() {
    userDetailBloc.add(LoadCurrentUserInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Column(
        children: <Widget>[
          BlocBuilder(
            bloc: userDetailBloc,
            builder: (context, state) {
              if (state is UserDetailLoaded) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: Colors.black12, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShortUserInfoWidget(
                        profilePicUrl: state.data['profilePicUrl'],
                        firstName: state.data['firstName'],
                        lastName: state.data['lastName'],
                        userName: state.data['userName'],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyMeetingsScreen()),
              );
            },
            child: ProfileActionWidget(
              text: 'My Meetings',
              icon: Icon(
                Icons.tv,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateFeedbackScreen()),
              );
            },
            child: ProfileActionWidget(
              text: Strings.FEEDBACK,
              icon: Icon(
                Icons.feedback,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
            },
            child: ProfileActionWidget(
              text: 'Edit Profile',
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: ProfileActionWidget(
              text: 'Settings',
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RoundedShapeButton(
              text: Strings.LOG_OUT,
              textColor: Colors.white,
              color: Colors.red,
              onPressed: () {
                Util.logOut(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
