import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/atoms/text_user_name.dart';
import 'package:zoomclone/bloc/user_detail/user_detail.dart';
import 'package:zoomclone/utils/util.dart';

class TextUsernameWithBloc extends StatelessWidget {
  final String data;
  final Color color;
  final int maxLine;
  final TextOverflow overFlow;
  final UserDetailBloc userDetailBloc = UserDetailBloc();
  final String userId;

  TextUsernameWithBloc(this.data,
      {Key key,
      this.color = Colors.white,
      this.maxLine,
      this.overFlow,
      @required this.userId})
      : super(key: key) {
    if (!Util.isStringNotNull(data)) {
      userDetailBloc.add(LoadUserInfo(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Util.isStringNotNull(data)) {
      return TextUsername(
        data,
      );
    } else {
      return BlocBuilder(
        bloc: userDetailBloc,
        builder: (context, state) {
          if (state is UserDetailUpdated) {
            return TextUsername(state.data['userName']);
          } else {
            return Container();
          }
        },
      );
    }
  }
}
