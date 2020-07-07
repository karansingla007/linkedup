import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zoomclone/atoms/hero_text.dart';

const termsAndConditionList = [
  """
<p dir="ltr" style="line-height:1.38;text-align: center;margin-top:0pt;margin-bottom:0pt;"><span style="font-size:24pt;font-family:'Times New Roman';color:#000000;background-color:transparent;font-weight:700;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;">Privacy Policy</span></p>
<p dir="ltr" style="line-height:1.38;text-align: center;margin-top:0pt;margin-bottom:0pt;"><span style="font-size:10.5pt;font-family:Arial;color:#232333;background-color:#ffffff;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;">Last updated: July 2020</span></p>
<p dir="ltr" style="line-height:1.38;text-align: center;margin-top:0pt;margin-bottom:0pt;"><span style="font-size:24pt;font-family:'Times New Roman';color:#000000;background-color:transparent;font-weight:700;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;"><br></span><span style="font-size:12pt;font-family:'Times New Roman';color:#000000;background-color:transparent;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;">Its online meeting application.&nbsp;</span><span style="font-size:12pt;font-family:'Times New Roman';color:#000000;background-color:transparent;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;"><br></span><span style="font-size:12pt;font-family:'Times New Roman';color:#000000;background-color:transparent;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;">We use a microphone, camera for live streaming, no other use.</span><span style="font-size:12pt;font-family:'Times New Roman';color:#000000;background-color:transparent;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;"><br></span><span style="font-size:12pt;font-family:'Times New Roman';color:#000000;background-color:transparent;font-weight:400;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;">We use agora sdk in this for live streaming.</span><span style="font-size:12pt;font-family:'Times New Roman';color:#000000;background-color:transparent;font-weight:700;font-style:normal;font-variant:normal;text-decoration:none;vertical-align:baseline;white-space:pre;white-space:pre-wrap;"><br><br></span></p>
""",
];

class TermsAndCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextHero('Privacy Policy'),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Center(
          child: ListView.builder(
        itemBuilder: (context, index) => Html(
          padding: EdgeInsets.all(8.0),
          data: termsAndConditionList[index],
        ),
        itemCount: termsAndConditionList.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
      )),
    );
  }
}
