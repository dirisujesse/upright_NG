import 'dart:async';

import 'package:Upright_NG/components/media.dart';
import 'package:Upright_NG/components/page_scaffold.dart';
import 'package:Upright_NG/components/record_widget.dart';
import 'package:Upright_NG/stores/testimonial.dart';
import 'package:Upright_NG/stores/user.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Upright_NG/styles/form_style.dart';
import 'package:Upright_NG/components/undeline_input.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

UserBloc usrData = UserBloc.getInstance();
TestimonialBloc testimonialBloc = TestimonialBloc.getInstance();

class TestimonialCreationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestimonialCreationPageState();
  }
}

class _TestimonialCreationPageState extends State<TestimonialCreationPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController locCtrl = TextEditingController();
  final TextEditingController msgCtrl = TextEditingController();
  final TextEditingController uploadCtrl = TextEditingController();
  final ValueNotifier<String> submitState = ValueNotifier("default");
  TargetPlatform platform;
  Color bCol;
  Color txtCol;
  double scrnSiaz;
  double scrnHaiyt;
  double pagePad;
  double topPadding;

  void showMediaDialog({BuildContext context, bool isVideo}) {
    isVideo
        ? testimonialBloc.getVideo(platform, true)
        : testimonialBloc.getImage(platform, true);
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    scrnSiaz = MediaQuery.of(context).size.width;
    scrnHaiyt = MediaQuery.of(context).size.height;
    pagePad = scrnSiaz > 550 ? scrnSiaz * 0.085 : scrnSiaz * 0.035;
    topPadding = scrnSiaz > 550 ? scrnSiaz * 0.010 : scrnSiaz * 0.15;
    bCol = Color(0xFF25333D);
    txtCol = Colors.white;

    return PageScaffold(
      color: Color(0xFFF9F9F9),
      bottomSheet: Builder(
        builder: (context) {
          return GestureDetector(
            child: Container(
              child: Center(
                  child: ValueListenableBuilder(
                valueListenable: submitState,
                builder: (context, val, child) {
                  if (!usrData.isLoggedIn) {
                    return Text(
                      "LOGIN TO SHARE",
                      style: TextStyle(color: appWhite),
                    );
                  } else if (val == "submitting") {
                    return Text(
                      "SHARING TESTIMONIAL",
                      style: TextStyle(color: appWhite),
                    );
                  } else if (val == "failed") {
                    return Text(
                      "SHARING FAILED RETRY",
                      style: TextStyle(color: appWhite),
                    );
                  } else if (val == "success") {
                    return Text(
                      "TESTIMONIAL SUBMITTED",
                      style: TextStyle(color: appWhite),
                    );
                  }
                  return Text(
                    "SHARE",
                    style: TextStyle(color: appWhite),
                  );
                },
              )),
              color: appGreen,
              height: MediaQuery.of(context).size.height * 0.08,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.08),
              width: MediaQuery.of(context).size.width,
            ),
            onTap: () {
              if (usrData.isLoggedIn) {
                if (formKey.currentState.validate() &&
                    submitState.value != "success" &&
                    submitState.value != "submitting") {
                  formKey.currentState.save();
                  submitState.value = "submitting";
                  testimonialBloc.addTestimonial({
                    "location": locCtrl.text.trim(),
                    "content": msgCtrl.text.trim(),
                  }, testimonialBloc).then((val) {
                    if (val) {
                      submitState.value = "success";
                      Timer(Duration(seconds: 1), () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      submitState.value = "failed";
                    }
                  }).catchError((err) {
                    submitState.value = "failed";
                  });
                }
              } else {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          );
        },
      ),
      activeRoute: 4,
      appBar: AppBar(
        backgroundColor: appWhite,
        leading: BackButton(
          color: appBlack,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed("/settings"),
          )
        ],
        elevation: 0,
      ),
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: appWhite,
                boxShadow: [
                  BoxShadow(
                    color: appShadow,
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Testimonial",
                      style: Theme.of(context).textTheme.title.copyWith(
                            color: appGreen,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      "Earn points by sharing your story on how you have used our gift items.",
                      style: TextStyle(
                          color: appGreen, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 20,
                  left: MediaQuery.of(context).size.width * 0.085,
                  right: MediaQuery.of(context).size.width * 0.085,
                  bottom: 200,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        decoration: underlineInputStyle.copyWith(
                          hintText: 'Your location',
                          prefixIcon: Icon(
                            Icons.location_on,
                            size: 25,
                            color: appGreen,
                          ),
                        ),
                        validator: (String val) {
                          if (val.isEmpty) {
                            return 'Location should not be empty';
                          }
                          return null;
                        },
                        controller: locCtrl,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: underlineInputStyle.copyWith(
                          // hintText: 'Story',
                          prefixIcon: Icon(
                            Icons.text_fields,
                            size: 25,
                            color: appGreen,
                          ),
                        ),
                        validator: (String val) {
                          if (val.isEmpty) {
                            return 'Story should not be empty';
                          }
                          return null;
                        },
                        maxLines: 5,
                        controller: msgCtrl,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      MediaContainer(
                        id: "testimonialMediaState",
                        bloc: testimonialBloc,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      StateBuilder(
                        stateID: "testimonialRecBtnState",
                        blocs: [testimonialBloc],
                        builder: (_) {
                          if (testimonialBloc.isRecording) {
                            return RecordWidget(
                              bloc: testimonialBloc,
                              bCol: bCol,
                              txtCol: txtCol,
                              stopRecAudio: () =>
                                  testimonialBloc.stopRecAudio(),
                              recAudio: () =>
                                  testimonialBloc.recAudio(platform),
                              pos: testimonialBloc.pos,
                              recUsedTime: testimonialBloc.recUsedTime,
                              padding: pagePad,
                            );
                          } else {
                            return SizedBox(height: 0);
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      UnderlineContainer(
                        prefix: Icon(
                          Icons.file_upload,
                          color: appGreen,
                          size: 25,
                        ),
                        title: AutoSizeText(
                          "Upload",
                          textAlign: TextAlign.start,
                        ),
                        suffix: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 25,
                                color: appAsh,
                              ),
                              onPressed: () {
                                showMediaDialog(
                                  context: context,
                                  isVideo: false,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.videocam,
                                size: 25,
                                color: appAsh,
                              ),
                              onPressed: () {
                                showMediaDialog(
                                  context: context,
                                  isVideo: true,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.mic,
                                size: 25,
                                color: appAsh,
                              ),
                              onPressed: () =>
                                  testimonialBloc.activateRecord(platform),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/fb.png",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset("assets/images/twitter.png"),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset("assets/images/insta.png"),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset("assets/images/whatsapp.png"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
