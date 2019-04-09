import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:path_provider/path_provider.dart' as fs;
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:location/location.dart';
import 'package:flutter_sound/flutter_sound.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FlutterSound recorder = FlutterSound();
  var _recorderObserver;
  TextEditingController titleCtrl, contentCtrl;
  Color bCol;
  Color txtCol;
  double scrnSiaz;
  double scrnHaiyt;
  double pagePad;
  double topPadding;
  double pos = 0;
  bool isVid = false;
  bool isAud = false;
  bool isImg = false;
  bool isRecording = false;
  bool showRecWidget = false;
  File _image;
  File _video;
  File _audio;

  @override
  void initState() {
    titleCtrl = TextEditingController(text: "");
    contentCtrl = TextEditingController(text: "");
    super.initState();
  }

  activateRecord() {
    setState(() {
      showRecWidget = true;
    });
  }

  reset() {
    setState(() {
      _image = null;
      _video = null;
      _audio = null;
      isImg = false;
      isAud = false;
      isVid = false;
      isRecording = false;
      showRecWidget = false;
      audioPath = null;
      titleCtrl = TextEditingController(text: "");
      contentCtrl = TextEditingController(text: "");
    });
  }

  Widget recordWidget(context) {
    if (showRecWidget) {
      return Container(
      width: scrnSiaz,
      color: txtCol,
      height: 70.0,
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "00:00",
                style: TextStyle(color: bCol),
              ),
              LinearPercentIndicator(
                progressColor: Color(0xFFE8C11C),
                percent: pos / 100,
                backgroundColor: bCol,
                width: MediaQuery.of(context).size.width * 0.6,
                lineHeight: 10.0,
              ),
              Text(
                "05:00",
                style: TextStyle(color: bCol),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              isRecording ? Icons.stop : Icons.play_arrow,
              color: bCol,
              size: 30,
            ),
            onPressed: () {
              if (isRecording) {
                stopRecAudio();
              } else {
                recAudio();
              }
            },
          )
        ],
      ),
    );
    } else {
      return SizedBox(height: 0,);
    }
  }

  Future recAudio() async {
    int progress = 0;
    if (isAud) {
      setState(() {
        isAud = false;
      });
    }

    await recorder.setSubscriptionDuration(1);
    final recordingPath = await fs.getApplicationDocumentsDirectory();
    audioPath = await recorder.startRecorder(
        join(recordingPath.path, DateTime.now().toIso8601String()));

    _recorderObserver = recorder.onRecorderStateChanged.listen((e) {});

    interval = Timer.periodic(Duration(seconds: 1), (duration) {
      progress += 1;
      setState(() {
        isRecording = true;
        pos = ((progress / (60 * 5)) * 100);
      });
      print(pos);
      if (pos >= 100.0) {
        stopRecAudio();
      }
    });
  }

  Future stopRecAudio() async {
    String result = await recorder.stopRecorder();
    if (_recorderObserver != null) {
      _recorderObserver.cancel();
      _recorderObserver = null;
      showRecWidget = false;
      if (result != null) {
        if (interval != null) {
          interval.cancel();
        }
        setState(() {
          isRecording = false;
          _image = null;
          _video = null;
          _audio = File(audioPath);
          isImg = false;
          isAud = true;
          isVid = false;
          pos = 0;
        });
      }
    }
  }

  Future getImage([isGal = false]) async {
    if (isImg) {
      setState(() {
        isImg = false;
      });
    }

    var image = await ImagePicker.pickImage(
            source: isGal ? ImageSource.gallery : ImageSource.camera) ??
        _image;

    if (image != null) {
      setState(() {
        _image = image;
        _video = null;
        _audio = null;
        isImg = true;
        isAud = false;
        isRecording = false;
        isVid = false;
      });
    }
  }

  Future getVideo([isGal = false]) async {
    if (isVid) {
      setState(() {
        isVid = false;
      });
    }
    var vid = await ImagePicker.pickVideo(
            source: isGal ? ImageSource.gallery : ImageSource.camera) ??
        _video;

    if (vid != null) {
      setState(() {
        _video = vid;
        _image = null;
        _audio = null;
        isImg = false;
        isAud = false;
        isVid = true;
        isRecording = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    scrnSiaz = MediaQuery.of(context).size.width;
    scrnHaiyt = MediaQuery.of(context).size.height;
    pagePad = scrnSiaz > 550 ? scrnSiaz * 0.085 : scrnSiaz * 0.035;
    topPadding = scrnSiaz > 550 ? scrnSiaz * 0.010 : scrnSiaz * 0.15;
    bCol = widget.isAnon ? Color(0xFF25333D) : Colors.white;
    txtCol = !widget.isAnon ? Color(0xFF25333D) : Colors.white;

    return Scaffold(
      drawer: AppDrawer(),
      bottomSheet: recordWidget(context),
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
              return StateBuilder(
                stateID: "postCreateState",
                blocs: [postData],
                builder: (_) {
                  return Form(
                    key: formKey,
                    child: SingleChildScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                                  getImage();
                                                },
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: FlatButton(
                                                child: Text("Open Gallery"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  getImage(true);
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
                                                  getVideo();
                                                },
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: FlatButton(
                                                child: Text("Open Gallery"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  getVideo(true);
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
                                      activateRecord();
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
                          isImg
                              ? Image.file(
                                  _image,
                                  height: 300,
                                  fit: BoxFit.cover,
                                )
                              : isVid
                                  ? VideoWidget(
                                      filePath: _video,
                                      isUrl: false,
                                    )
                                  : isAud
                                      ? VideoWidget(
                                          filePath: _audio,
                                          isUrl: false,
                                        )
                                      : SizedBox(
                                          height: 0.0,
                                        ),
                          SizedBox(
                            height: 10.0,
                          ),
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
                                      "author": postData.usrData.activeUser.id,
                                      "long": val.longitude,
                                      "lat": val.latitude,
                                      "img": isImg
                                          ? base64Encode(
                                              _image.readAsBytesSync())
                                          : isVid
                                              ? base64Encode(
                                                  _video.readAsBytesSync())
                                              : isAud
                                                  ? base64Encode(
                                                      _audio.readAsBytesSync())
                                                  : "",
                                      "anonymous": widget.isAnon,
                                      "isVideo": isAud ? 'audio' : isVid
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
                                                Theme.of(context).accentColor,
                                            content: Text(
                                              "Post was successfully submitted",
                                            ),
                                          ),
                                        );
                                        reset();
                                      } else {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Color(0xFF9B0D54),
                                            content: Text(
                                              "Post wasn't successfully submitted, please check that you have internet connection",
                                            ),
                                          ),
                                        );
                                      }
                                    }).catchError((err) {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Color(0xFF9B0D54),
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
                                          title: Text("Location Fetch Failure"),
                                          content: Text(
                                              "We couldn't get your location, please allow for us to get your location"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("OK"),
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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
