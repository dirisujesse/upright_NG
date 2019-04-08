import 'package:flutter/material.dart';

import '../components/app_drawer.dart';
import '../components/app_bar_default.dart';
import '../components/form_style.dart';
import '../stores/suggestion.dart';

import 'package:states_rebuilder/states_rebuilder.dart';

final suggData = SuggestionBloc.getInstance();

class SuggestionPage extends StatefulWidget {
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl, emailCntrl, titleCtrl, contentCtrl;
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

    return Scaffold(
      drawer: AppDrawer(),
      appBar: appBarDefault(title: "Suggestions", context: context),
      backgroundColor: Colors.white,
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
                stateID: "suggState",
                blocs: [suggData],
                builder: (state) {
                  return Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          suggData.isLoading
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
                              enabledBorder: formBrdr,
                              focusedBorder: formActiveBrdr,
                              labelText: 'Your Name',
                              filled: false,
                            ),
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            controller: nameCtrl,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Color(0xFFCCCCCC), fontSize: 18.0),
                              enabledBorder: formBrdr,
                              focusedBorder: formActiveBrdr,
                              errorBorder: errBrdr,
                              labelText: 'Email',
                              filled: false,
                            ),
                            validator: (String val) {
                              if (val.isEmpty ||
                                  !RegExp(r'\b[\w\d\W\D]+(?:@(?:[\w\d\W\D]+(?:\.(?:[\w\d\W\D]+))))\b')
                                      .hasMatch(val)) {
                                return 'Email must be valid e.g username@mailprovider.com';
                              }
                            },
                            controller: emailCntrl,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Color(0xFFCCCCCC), fontSize: 18.0),
                              enabledBorder: formBrdr,
                              focusedBorder: formActiveBrdr,
                              labelText: 'Suggestion Title',
                              filled: false,
                            ),
                            controller: titleCtrl,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Color(0xFFCCCCCC), fontSize: 18.0),
                              enabledBorder: formBrdr,
                              focusedBorder: formActiveBrdr,
                              labelText: 'Suggestion',
                              filled: false,
                            ),
                            keyboardType: TextInputType.multiline,
                            controller: contentCtrl,
                            maxLines: null,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (formKey.currentState.validate() &&
                                  !(nameCtrl.text.isEmpty &&
                                      emailCntrl.text.isEmpty &&
                                      titleCtrl.text.isEmpty &&
                                      contentCtrl.text.isEmpty)) {
                                formKey.currentState.save();
                                suggData.makeSuggestion({
                                  "contributor": nameCtrl.text.trim(),
                                  "email": emailCntrl.text.trim(),
                                  "subject": titleCtrl.text.trim(),
                                  "suggestion": contentCtrl.text.trim(),
                                }).then((val) {
                                  formKey.currentState.reset();
                                  if (val) {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        content: Text(
                                          "Suggestion was successfully submitted",
                                        ),
                                      ),
                                    );
                                  } else {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Color(0xFF9B0D54),
                                        content: Text(
                                          "Suggestion wasn't successfully submitted, please check that you have internet connection",
                                        ),
                                      ),
                                    );
                                  }
                                }).catchError((err) {
                                  formKey.currentState.reset();
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Color(0xFF9B0D54),
                                      content: Text(
                                        "Suggestion wasn't successfully submitted, please check that you have internet connection",
                                      ),
                                    ),
                                  );
                                });
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
