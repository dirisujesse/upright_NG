// import 'dart:io';
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../components/form_style.dart';
import '../components/app_drawer.dart';
import '../components/app_bar_default.dart';
import '../stores/post.dart';


final postData = PostBloc();

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
  TextEditingController nameCtrl, emailCntrl, titleCtrl, contentCtrl;
  Color bCol;
  Color txtCol;
  double scrnSiaz;
  double scrnHaiyt;
  double pagePad;
  double topPadding;
  @override
  void initState() {
    nameCtrl = TextEditingController(text: "");
    emailCntrl = TextEditingController(text: "");
    titleCtrl = TextEditingController(text: "");
    contentCtrl = TextEditingController(text: "");
    super.initState();
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
      appBar: appBarDefault(title: "Add Post ${widget.isAnon ? "Anonymously" : ""}", context: context, bgCol: bCol, txtCol: txtCol),
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
                builder: (state) {
                  return Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          postData.isLoading
                              ? LinearProgressIndicator()
                              : SizedBox(
                                  height: 0,
                                ),
                          SizedBox(
                            height: topPadding,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Color(0xFFCCCCCC), fontSize: 18.0),
                              enabledBorder: widget.isAnon ? formBrdrWhite : formBrdr,
                              focusedBorder: widget.isAnon ? formActiveBrdrWhite : formActiveBrdr,
                              labelText: 'Post Title',
                              filled: false,
                            ),
                            style:
                                TextStyle(color: txtCol, fontSize: 20.0),
                            controller: nameCtrl,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Color(0xFFCCCCCC), fontSize: 18.0),
                              enabledBorder: widget.isAnon ? formBrdrWhite : formBrdr,
                              focusedBorder: widget.isAnon ? formActiveBrdrWhite : formActiveBrdr,
                              labelText: 'Post Body',
                              filled: false,
                            ),
                            keyboardType: TextInputType.multiline,
                            controller: contentCtrl,
                            maxLines: null,
                            style:
                                TextStyle(color: txtCol, fontSize: 20.0),
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (formKey.currentState.validate() &&
                                  !(nameCtrl.text.isEmpty &&
                                      emailCntrl.text.isEmpty &&
                                      titleCtrl.text.isEmpty &&
                                      contentCtrl.text.isEmpty)) {
                                formKey.currentState.save();
                                // postData.makeSuggestion({
                                //   "contributor": nameCtrl.text.trim(),
                                //   "email": emailCntrl.text.trim(),
                                //   "subject": titleCtrl.text.trim(),
                                //   "suggestion": contentCtrl.text.trim(),
                                // }).then((val) {
                                //   formKey.currentState.reset();
                                //   if (val) {
                                //     Scaffold.of(context).showSnackBar(
                                //       SnackBar(
                                //         backgroundColor:
                                //             Theme.of(context).accentColor,
                                //         content: Text(
                                //           "Suggestion was successfully submitted",
                                //         ),
                                //       ),
                                //     );
                                //   } else {
                                //     Scaffold.of(context).showSnackBar(
                                //       SnackBar(
                                //         backgroundColor: Color(0xFF9B0D54),
                                //         content: Text(
                                //           "Suggestion wasn't successfully submitted, please check that you have internet connection",
                                //         ),
                                //       ),
                                //     );
                                //   }
                                // }).catchError((err) {
                                //   formKey.currentState.reset();
                                //   Scaffold.of(context).showSnackBar(
                                //     SnackBar(
                                //       backgroundColor: Color(0xFF9B0D54),
                                //       content: Text(
                                //         "Suggestion wasn't successfully submitted, please check that you have internet connection",
                                //       ),
                                //     ),
                                //   );
                                // });
                              } else {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Color(0xFF9B0D54),
                                    content: Text(
                                      "Please provide valid entries",
                                    ),
                                  ),
                                );
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
