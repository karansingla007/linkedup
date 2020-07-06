import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_input.dart';
import 'package:zoomclone/bloc/feedback/feedback.dart';
import 'package:zoomclone/bloc/feedback/feedback_bloc.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/custom/wave_loader.dart';
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
      body: BlocListener(
        bloc: feedbackBloc,
        listener: (context, state) {
          if(state is FeedbackLoaded) {
            Toast.show("Your feedback has submitted.", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8),
          child: Column(
            children: <Widget>[
              TextInput(
                controller: feedbackTitleController,
                label: Strings.TITLE,
                hintText: Strings.TYPE_YOUR_TITLE,
                minLines: 1,
                maxLines: 2,
              ),
              SizedBox(
                height: 24,
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
              BlocBuilder(
                bloc: feedbackBloc,
                builder: (context, state) {
                  if(state is FeedbackSubmiting) {
                    return WaveLoader.spinKit(size: 20);
                  } else {
                  return RoundedShapeButton(
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
                  );
                  }
                },
              ),
             SizedBox(height: 64,),
            ],
          ),
        ),
      ),
    );
  }
}
