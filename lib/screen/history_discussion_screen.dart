import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/atoms/text_big_hero.dart';
import 'package:zoomclone/bloc/history_discussion_screen/history_discussion_screen.dart';
import 'package:zoomclone/shimmer/shimmer_list.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/empty_place_holder.dart';
import 'package:zoomclone/widgets/short_ended_discussion_info.dart';

class HistoryDiscussionScreen extends StatelessWidget {
  final HistoryDiscussionScreenBloc historyDiscussionScreenBloc =
      HistoryDiscussionScreenBloc();

  HistoryDiscussionScreen() {
    historyDiscussionScreenBloc.add(LoadHistoryDiscussionScreen());
  }

  Future<void> onRefresh() async {
    historyDiscussionScreenBloc.add(LoadHistoryDiscussionScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextBigHero(
                      Strings.HISTORY,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder(
                bloc: historyDiscussionScreenBloc,
                builder: (context, state) {
                  if (state is HistoryDiscussionScreenLoading) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ShimmerList(
                        screenHeight: MediaQuery.of(context).size.height - 32,
                        widthOfSingleElement:
                            MediaQuery.of(context).size.width - 32.0,
                      ),
                    );
                  } else if (state is HistoryDiscussionScreenLoaded) {
                    if (Util.isValidList(state.historySessionList)) {
                      return Flexible(
                        child: ListView.builder(
                          itemCount: state.historySessionList.length,
                          itemBuilder: (context, index) {
                            return ShortEndedDiscussionInfo(
                              sessionTitle: state.historySessionList[index]
                                  ['title'],
                              sessionDescription: state
                                  .historySessionList[index]['description'],
                              sessionId: state.historySessionList[index]
                                  ['sessionId'],
                            );
                          },
                        ),
                      );
                    } else {
                      return Container(
                          height: MediaQuery.of(context).size.height - 120,
                          child: Center(child: EmptyPlaceHolder()));
                    }
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
