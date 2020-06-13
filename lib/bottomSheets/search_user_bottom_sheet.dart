import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/buttons/shape_button_small.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/molecule/auto_complete.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';
import 'package:zoomclone/widgets/short_user_info_small_widget.dart';

class SearchUserBottomSheet extends StatefulWidget {
  final Function(Map) onClickInvite;

  SearchUserBottomSheet({this.onClickInvite});

  @override
  _SearchUserBottomSheetState createState() => _SearchUserBottomSheetState();
}

class _SearchUserBottomSheetState extends State<SearchUserBottomSheet> {
  final TextEditingController searchController = TextEditingController();
  bool showLocationLoader = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 2, color: Colors.black38)),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.search,
                  color: Colors.black38,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: AutoComplete(
                    textEditingController: searchController,
                    hintText: Strings.ADD_SPEAKERS_USERNAME,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    autoFocus: true,
                    suggestionsCallback: (String pattern) async {
                      if (Util.isStringNotNull(pattern)) {
                        setState(() {
                          showLocationLoader = true;
                        });
                      }
                      List suggestedUsers =
                          await Api().getUserDetailByPattern(pattern: pattern);
                      setState(() {
                        showLocationLoader = false;
                      });
                      return suggestedUsers;
                    },
                    itemBuilder: (BuildContext context, itemData) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(8.0),
                              child: ShortUserInfoShortWidget(
                                userName: itemData['userName'],
                                firstName: itemData['firstName'],
                                lastName: itemData['lastName'],
                                profilePicUrl: itemData['profilePicUrl'],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          ShapeButtonSmall(
                            text: Strings.INVITE,
                            onPressed: () {
                              widget.onClickInvite(itemData);
                            },
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      );
                    },
                    suggestionSelectionCallback: (suggestion) {},
                    direction: AxisDirection.down,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Visibility(
                      visible: showLocationLoader,
                      child: WaveLoader.spinKit(size: 12)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
