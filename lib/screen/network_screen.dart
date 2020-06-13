import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/atoms/text_big_hero.dart';
import 'package:zoomclone/bloc/network_screen/network_screen.dart';
import 'package:zoomclone/shimmer/shimmer_list.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/empty_place_holder.dart';
import 'package:zoomclone/widgets/network_user_widget.dart';

class NetworkScreen extends StatelessWidget {
  final NetworkScreenBloc networkScreenBloc = NetworkScreenBloc();

  NetworkScreen() {
    networkScreenBloc.add(LoadNetworkScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Strings.MY_NETWORK,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder(
              bloc: networkScreenBloc,
              builder: (context, state) {
                if (state is NetworkScreenLoading) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ShimmerList(
                      screenHeight: MediaQuery.of(context).size.height - 32,
                      widthOfSingleElement:
                          MediaQuery.of(context).size.width - 32.0,
                    ),
                  );
                } else if (state is NetworkScreenLoaded) {
                  if (Util.isValidList(state.myNetworkList)) {
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ListView.separated(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8,
                          ),
                          itemCount: state.myNetworkList.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.black12,
                            height: 16,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              child: NetworkUserWidget(
                                profilePicUrl: state.myNetworkList[index]
                                    ['user']['profilePicUrl'],
                                firstName: state.myNetworkList[index]['user']
                                    ['firstName'],
                                lastName: state.myNetworkList[index]['user']
                                    ['lastName'],
                                userName: state.myNetworkList[index]['user']
                                    ['userName'],
                              ),
                            );
                          },
                        ),
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
    );
  }
}
