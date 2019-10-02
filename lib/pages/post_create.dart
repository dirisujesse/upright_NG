import 'dart:async';
import 'dart:convert';

import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:location/location.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:auto_size_text/auto_size_text.dart';
import '../styles/form_style.dart';
import '../components/video_player.dart';
import '../stores/post.dart';

final postData = PostBloc();
Timer interval;
String audioPath;

class PostCreatePage extends StatefulWidget {
  final bool isAnon;
  PostCreatePage({this.isAnon = false});

  @override
  State<StatefulWidget> createState() {
    return PostCreatePageState();
  }
}

class PostCreatePageState extends State<PostCreatePage> {
  TargetPlatform platform;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl, contentCtrl;
  Color bCol;
  Color txtCol;
  double scrnSiaz;
  double scrnHaiyt;
  double pagePad;
  double topPadding;
  ValueNotifier isAnon;
  ValueNotifier<Map<String, bool>> submitState;

  resetForm() {
    titleCtrl.clear();
    contentCtrl.clear();
  }

  @override
  void initState() {
    super.initState();
    isAnon = ValueNotifier(widget.isAnon);
    submitState = ValueNotifier({"isSubmitting": false, "submitted": false});
    titleCtrl = TextEditingController(text: "");
    contentCtrl = TextEditingController(text: "");
  }

  @override
  void dispose() {
    super.dispose();
    isAnon = ValueNotifier(widget.isAnon);
    submitState = ValueNotifier({"isSubmitting": false, "submitted": false});
    titleCtrl = TextEditingController(text: "");
    contentCtrl = TextEditingController(text: "");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postData.reset();
  }

  presentSnack(
    BuildContext context,
    String content, [
    Color bgCol = const Color(0xFF9B0D54),
    Color txtCol = appWhite,
  ]) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: AutoSizeText(content),
        backgroundColor: bgCol,
        action: SnackBarAction(
          textColor: txtCol,
          label: "OK",
          onPressed: () {},
        ),
      ),
    );
  }

  void showMediaDialog({BuildContext context, bool isVideo}) {
    isVideo
        ? postData.getVideo(platform, true)
        : postData.getImage(platform, true);
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return SafeArea(
    //       child: Container(
    //         height: scrnHaiyt,
    //         width: scrnSiaz,
    //         child: Center(
    //           child: Container(
    //             color: appWhite,
    //             padding: EdgeInsets.all(20),
    //             constraints: BoxConstraints(maxHeight: 300),
    //             child: SingleChildScrollView(
    //               child: Column(
    //                 children: <Widget>[
    //                   FlatButton(
    //                     child: AutoSizeText(
    //                       "Take ${isVideo ? "Video" : "Photo"}",
    //                     ),
    //                     onPressed: () {
    //                       Navigator.pop(context);
    //                       isVideo ? postData.getVideo(platform) : postData.getImage(platform);
    //                     },
    //                   ),
    //                   FlatButton(
    //                     child: AutoSizeText(
    //                       "Open Gallery",
    //                     ),
    //                     onPressed: () {
    //                       Navigator.pop(context);
    //                       isVideo ? postData.getVideo(platform, true) : postData.getImage(platform, true);
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  void addPost(BuildContext context) {
    Location().getLocation().then((val) {
      submitState.value = {"isSubmitting": true, "submitted": false};
      final data = {
        "title": titleCtrl.text.trim(),
        "body": contentCtrl.text.trim(),
        "author": postData.usrData.activeUser.id,
        "long": val.longitude,
        "lat": val.latitude,
        "img": postData.isImg
            ? base64Encode(postData.image.readAsBytesSync())
            : postData.isVid
                ? base64Encode(postData.video.readAsBytesSync())
                : postData.isAud
                    ? base64Encode(postData.audio.readAsBytesSync())
                    : "",
        "anonymous": isAnon.value,
        "isVideo": postData.isAud ? 'audio' : postData.isVid,
      };
      presentSnack(
        context,
        "Post is being submitted",
        appGreen,
      );
      postData.addPost(data, postData).then((val) {
        if (val) {
          presentSnack(
            context,
            "Post was successfully submitted",
            appGreen,
          );
          postData.reset();
          resetForm();
          submitState.value = {"isSubmitting": false, "submitted": true};
        } else {
          submitState.value = {"isSubmitting": false, "submitted": false};
          presentSnack(
            context,
            "Post wasn't successfully submitted, please check that you have internet connection",
          );
        }
      }).catchError((err) {
        print(err);
        submitState.value = {"isSubmitting": false, "submitted": false};
        presentSnack(
          context,
          "Post wasn't successfully submitted, please check that you have internet connection",
        );
      });
    }).catchError((err) {
      submitState.value = {"isSubmitting": false, "submitted": false};
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: AutoSizeText(
              "Location Fetch Failure",
            ),
            content: AutoSizeText(
              "We couldn't get your location, please allow for us to get your location",
            ),
            actions: <Widget>[
              FlatButton(
                child: AutoSizeText("OK"),
                onPressed: () {
                  Location().requestPermission();
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    scrnSiaz = MediaQuery.of(context).size.width;
    scrnHaiyt = MediaQuery.of(context).size.height;
    pagePad = scrnSiaz > 550 ? scrnSiaz * 0.085 : scrnSiaz * 0.035;
    topPadding = scrnSiaz > 550 ? scrnSiaz * 0.010 : scrnSiaz * 0.15;
    bCol = widget.isAnon ? Color(0xFF25333D) : Colors.white;
    txtCol = !widget.isAnon ? Color(0xFF25333D) : Colors.white;

    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: pagePad,
          top: 20.0,
          right: pagePad,
        ),
        child: StateBuilder(
          stateID: "postCreateState",
          blocs: [postData],
          builder: (_) {
            if (!postData.usrData.isLoggedIn) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AutoSizeText(
                    "Sign In to Report",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appBlack.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    child: AutoSizeText("Sign in"),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("/login");
                    },
                  )
                ],
              );
            } else {
              return ValueListenableBuilder(
                valueListenable: submitState,
                builder: (context, stateVal, child) {
                  if (stateVal["isSubmitting"]) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: appBlack,
                              backgroundImage: NetworkImage(
                                  postData.usrData.activeUser.avatar),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            AutoSizeText(
                              postData.usrData.activeUser.name,
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        LinearProgressIndicator(),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: scrnSiaz * 0.9),
                          alignment: Alignment.center,
                          child: Center(
                            child: AutoSizeText(
                              "Please wait while we send your Report",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: appBlack.withOpacity(0.6),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (stateVal["submitted"]) {
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Image.asset(
                            "assets/images/happy_face.png",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: scrnSiaz * 0.5),
                          alignment: Alignment.center,
                          child: Center(
                            child: AutoSizeText(
                              "Thank you for contributing to a corruption free Nigeria.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: appBlack.withOpacity(0.6),
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          child: AutoSizeText("Return to feed"),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed("/home");
                          },
                        )
                      ],
                    );
                  } else {
                    return Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: CircleAvatar(
                                backgroundColor: appBlack,
                                backgroundImage: NetworkImage(
                                    postData.usrData.activeUser.avatar),
                              ),
                              title: AutoSizeText(
                                postData.usrData.activeUser.name,
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              decoration:
                                  formInputStyle.copyWith(hintText: 'Title'),
                              controller: titleCtrl,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Title should not be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              decoration:
                                  formInputStyle.copyWith(hintText: 'Details'),
                              keyboardType: TextInputType.multiline,
                              controller: contentCtrl,
                              maxLines: null,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Details should not be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  AutoSizeText(
                                    "Evidence",
                                    style: TextStyle(
                                        color: appBlack.withOpacity(0.6)),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: 30,
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
                                          size: 30,
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
                                          size: 30,
                                          color: appAsh,
                                        ),
                                        onPressed: () {
                                          postData.activateRecord(platform);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: formInputGreen,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: formInputGreen,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  AutoSizeText(
                                    "Anonymous",
                                    style: TextStyle(
                                        color: appBlack.withOpacity(0.6)),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: isAnon,
                                    builder: (context, valu, child) {
                                      return Switch(
                                        onChanged: (val) {
                                          isAnon.value = val;
                                        },
                                        value: isAnon.value = valu,
                                        activeColor: appGreen,
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            MediaContainer(),
                            SizedBox(
                              height: 10.0,
                            ),
                            StateBuilder(
                              stateID: "postRecBtnState",
                              blocs: [postData],
                              builder: (_) {
                                if (postData.isRecording) {
                                  return RecordWidget(
                                    bCol: bCol,
                                    txtCol: txtCol,
                                    stopRecAudio: () => postData.stopRecAudio(),
                                    recAudio: () => postData.recAudio(platform),
                                    pos: postData.pos,
                                    recUsedTime: postData.recUsedTime,
                                    padding: pagePad,
                                  );
                                } else {
                                  return SizedBox(height: 0);
                                }
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            RaisedButton(
                              onPressed: () {
                                if (!postData.isSubmitingPost) {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    addPost(context);
                                  } else {
                                    presentSnack(
                                      context,
                                      "Please provide title and body entries",
                                    );
                                  }
                                }
                              },
                              child: AutoSizeText(
                                "Report",
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );

    // return PageScaffold(
    //   child: NestedScrollView(
    //     headerSliverBuilder: (BuildContext context, bool isScrolled) {
    //       return [
    //         SliverAppBar(
    //           backgroundColor: Color(0xFF467D4D),
    //           flexibleSpace: AppBanner(),
    //           expandedHeight: MediaQuery.of(context).size.height * 0.3,
    //           iconTheme: IconThemeData(color: appWhite),
    //         ),
    //       ];
    //     },
    //     body:
    //   ),
    //   activeRoute: 1,
    // );
  }
}

class MediaContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      stateID: "postMediaState",
      blocs: [postData],
      builder: (_) {
        if (postData.isImg) {
          return Image.file(
            postData.image,
            fit: BoxFit.contain,
            height: 400,
          );
        }
        if (postData.isVid) {
          return VideoWidget(
            filePath: postData.video,
            isUrl: false,
          );
        }
        if (postData.isAud) {
          return VideoWidget(
            filePath: postData.audio,
            isUrl: false,
          );
        }
        return SizedBox(
          height: 0.0,
        );
      },
    );
  }
}

class RecordWidget extends StatelessWidget {
  final String recUsedTime;
  final Color txtCol;
  final Color bCol;
  final Function stopRecAudio;
  final Function recAudio;
  final double pos;
  final double padding;

  RecordWidget({
    this.bCol,
    this.txtCol,
    this.recUsedTime,
    this.stopRecAudio,
    this.recAudio,
    this.pos,
    this.padding = 0,
  });

  @override
  Widget build(BuildContext context) {
    List<int> span =
        recUsedTime.split(":").map((String it) => int.parse(it)).toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 70.0,
          constraints: BoxConstraints(
              maxHeight: 70.0, maxWidth: constraints.maxWidth - padding),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: txtCol,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LinearPercentIndicator(
                progressColor: Color(0xFFE8C11C),
                percent: pos,
                backgroundColor: bCol,
                width: constraints.constrainWidth() * 0.5,
                lineHeight: 8.0,
                leading: AutoSizeText(
                  "$recUsedTime",
                  style: TextStyle(color: bCol),
                ),
                trailing: AutoSizeText(
                  "0${4 - span[0]}:${59 - span[1]}",
                  style: TextStyle(color: bCol),
                ),
              ),
              FloatingActionButton(
                heroTag: "recBtn",
                backgroundColor: bCol,
                child: Icon(
                  postData.isRecording ? Icons.stop : Icons.mic,
                  color: txtCol,
                  size: 30,
                ),
                onPressed: () {
                  if (postData.isRecording) {
                    stopRecAudio();
                  } else {
                    recAudio();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
