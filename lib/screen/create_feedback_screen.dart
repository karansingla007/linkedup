import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_input.dart';
import 'package:zoomclone/bloc/feedback/feedback.dart';
import 'package:zoomclone/bloc/feedback/feedback_bloc.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';

class CreateFeedbackScreen extends StatelessWidget {
  final TextEditingController feedbackDescriptionController =
      TextEditingController();
  final TextEditingController feedbackTitleController = TextEditingController();
  final FeedbackBloc feedbackBloc = FeedbackBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextHero('Feedback'),
      ),
      body: Column(
        children: <Widget>[
          TextInput(
            controller: feedbackTitleController,
            label: Strings.TITLE,
            hintText: Strings.TYPE_YOUR_TITLE,
            minLines: 1,
            maxLines: 2,
          ),
          SizedBox(
            height: 8,
          ),
          TextInput(
            controller: feedbackDescriptionController,
            label: Strings.DESCRIPTION,
            hintText: Strings.TYPE_YOUR_DESCRIPTION,
            minLines: 1,
            maxLines: 3,
          ),
          Expanded(
            child: Container(),
          ),
          RoundedShapeButton(
            text: 'SUBMIT',
            onPressed: () async {
              Map deviceInfo = await Util.loadDeviceInfo();
              Map feedbackDetail = Map();
              feedbackDetail['feedbackDescription'] =
                  feedbackDescriptionController.text;
              feedbackDetail['feedbackTitle'] = feedbackTitleController.text;

              feedbackDetail.addAll(deviceInfo);

              feedbackBloc.add(LoadFeedback(body: feedbackDetail));
            },
          ),
        ],
      ),
    );
  }
}
