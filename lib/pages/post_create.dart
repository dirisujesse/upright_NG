import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:location/location.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../components/form_style.dart';
import '../components/app_drawer.dart';
import '../components/app_bar_default.dart';
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

  resetForm() {
    titleCtrl.clear();
    contentCtrl.clear();
  }

  @override
  void initState() {
    titleCtrl = TextEditingController(text: "");
    contentCtrl = TextEditingController(text: "");
    super.initState();
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

    return Scaffold(
      drawer: AppDrawer(),
      bottomSheet: StateBuilder(
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
              );
            } else {
              return SizedBox(height: 0);
            }
          }),
      appBar: appBarDefault(
          title: "Add Post ${widget.isAnon ? "Anonymously" : ""}",
          context: context,
          bgCol: bCol,
          txtCol: txtCol),
      backgroundColor: bCol,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: scrnHaiyt,
          width: scrnSiaz,
          padding: EdgeInsets.symmetric(horizontal: pagePad, vertical: 10.0),
          child: Builder(
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "ADD MEDIA TO POST",
                          style: TextStyle(color: txtCol),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: txtCol,
                              ),
                              onPressed: () {
                                showMenu(
                                    position: RelativeRect.fromLTRB(
                                        scrnSiaz * 0.05,
                                        scrnHaiyt * 0.1,
                                        0.0,
                                        0.0),
                                    context: context,
                                    items: [
                                      PopupMenuItem(
                                        child: FlatButton(
                                          child: Text("Take Photo"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            postData.getImage(platform);
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: FlatButton(
                                          child: Text("Open Gallery"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            postData.getImage(platform, true);
                                          },
                                        ),
                                      )
                                    ]);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.videocam,
                                size: 30,
                                color: txtCol,
                              ),
                              onPressed: () {
                                showMenu(
                                    position: RelativeRect.fromLTRB(
                                        scrnSiaz * 0.05,
                                        scrnHaiyt * 0.1,
                                        0.0,
                                        0.0),
                                    context: context,
                                    items: [
                                      PopupMenuItem(
                                        child: FlatButton(
                                          child: Text("Record Video"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            postData.getVideo(platform);
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: FlatButton(
                                          child: Text("Open Gallery"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            postData.getVideo(platform, true);
                                          },
                                        ),
                                      )
                                    ]);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.mic,
                                size: 30,
                                color: txtCol,
                              ),
                              onPressed: () {
                                postData.activateRecord(platform);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: txtCol,
                    ),
                    MediaContainer(),
                    SizedBox(
                      height: 10.0,
                    ),
                    StateBuilder(
                      stateID: "postCreateState",
                      blocs: [postData],
                      builder: (_) {
                        return Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              postData.isSubmitingPost
                                  ? LinearProgressIndicator()
                                  : SizedBox(
                                      height: 0,
                                    ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Color(0xFFCCCCCC), fontSize: 18.0),
                                  enabledBorder: widget.isAnon
                                      ? formBrdrWhiteUnd
                                      : formBrdrUnd,
                                  focusedBorder: widget.isAnon
                                      ? formActiveBrdrWhiteUnd
                                      : formActiveBrdrUnd,
                                  labelText: 'Post Title',
                                  filled: false,
                                ),
                                style: TextStyle(color: txtCol, fontSize: 20.0),
                                controller: titleCtrl,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Color(0xFFCCCCCC), fontSize: 18.0),
                                  enabledBorder: widget.isAnon
                                      ? formBrdrWhiteUnd
                                      : formBrdrUnd,
                                  focusedBorder: widget.isAnon
                                      ? formActiveBrdrWhiteUnd
                                      : formActiveBrdrUnd,
                                  labelText: 'Post Body',
                                  filled: false,
                                ),
                                keyboardType: TextInputType.multiline,
                                controller: contentCtrl,
                                maxLines: null,
                                style: TextStyle(color: txtCol, fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  if (!postData.isSubmitingPost) {
                                    if (formKey.currentState.validate() &&
                                        !(titleCtrl.text.isEmpty &&
                                            contentCtrl.text.isEmpty)) {
                                      formKey.currentState.save();
                                      Location().getLocation().then((val) {
                                        final data = {
                                          "title": titleCtrl.text.trim(),
                                          "body": contentCtrl.text.trim(),
                                          "author":
                                              postData.usrData.activeUser.id,
                                          "long": val.longitude,
                                          "lat": val.latitude,
                                          "img": postData.isImg
                                              ? base64Encode(postData.image
                                                  .readAsBytesSync())
                                              : postData.isVid
                                                  ? base64Encode(postData.video
                                                      .readAsBytesSync())
                                                  : postData.isAud
                                                      ? base64Encode(postData
                                                          .audio
                                                          .readAsBytesSync())
                                                      : "",
                                          "anonymous": widget.isAnon,
                                          "isVideo": postData.isAud
                                              ? 'audio'
                                              : postData.isVid
                                        };
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            content: Text(
                                              "Post is being submitted",
                                            ),
                                          ),
                                        );
                                        postData.addPost(data).then((val) {
                                          if (val) {
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .accentColor,
                                                content: Text(
                                                  "Post was successfully submitted",
                                                ),
                                              ),
                                            );
                                            postData.reset();
                                            resetForm();
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Color(0xFF9B0D54),
                                                content: Text(
                                                  "Post wasn't successfully submitted, please check that you have internet connection",
                                                ),
                                              ),
                                            );
                                          }
                                        }).catchError((err) {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  Color(0xFF9B0D54),
                                              content: Text(
                                                "Post wasn't successfully submitted, please check that you have internet connection",
                                              ),
                                            ),
                                          );
                                        });
                                      }).catchError((err) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Location Fetch Failure"),
                                              content: Text(
                                                  "We couldn't get your location, please allow for us to get your location"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Location()
                                                        .requestPermission();
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      });
                                    } else {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Color(0xFF9B0D54),
                                          content: Text(
                                            "Please provide title and body entries",
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                color: Color(0xFFE8C11C),
                                child: Text(
                                  "SUBMIT",
                                  style: TextStyle(color: Color(0xFF25333D)),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
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
            height: 300,
            fit: BoxFit.contain,
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

  RecordWidget({
    this.bCol,
    this.txtCol,
    this.recUsedTime,
    this.stopRecAudio,
    this.recAudio,
    this.pos,
  });

  @override
  Widget build(BuildContext context) {
    List<int> span =
        recUsedTime.split(":").map((String it) => int.parse(it)).toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: txtCol,
          height: constraints.constrainHeight(70.0),
          width: constraints.constrainWidth(),
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LinearPercentIndicator(
                progressColor: Color(0xFFE8C11C),
                percent: pos,
                backgroundColor: bCol,
                width: constraints.constrainWidth() * 0.6,
                lineHeight: 8.0,
                leading: Text(
                    "$recUsedTime",
                    style: TextStyle(color: bCol),
                  ),
                trailing: Text(
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
