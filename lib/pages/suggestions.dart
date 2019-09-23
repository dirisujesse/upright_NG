import 'package:Upright_NG/components/app_form.dart';
import 'package:Upright_NG/components/form_scaffold.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';

import '../components/app_drawer.dart';
import '../styles/form_style.dart';
import '../stores/suggestion.dart';

import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    super.initState();
    nameCtrl = TextEditingController(text: "");
    emailCntrl = TextEditingController(text: "");
    titleCtrl = TextEditingController(text: "");
    contentCtrl = TextEditingController(text: "");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrnSiaz = MediaQuery.of(context).size.width;
    scrnHaiyt = MediaQuery.of(context).size.height;
    pagePad = scrnSiaz > 550 ? scrnSiaz * 0.085 : scrnSiaz * 0.035;
    topPadding = scrnSiaz > 550 ? scrnHaiyt * 0.05 : scrnSiaz * 0.035;
  }

  void presentSnackBar({
    @required String title,
    @required context,
    Color color,
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color ?? Color(0xFF9B0D54),
        content: AutoSizeText(
          title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      bottomInset: 0,
      drawer: AppDrawer(),
      content: AppForm(
        padding: EdgeInsets.only(
          left: pagePad,
          right: pagePad,
          top: topPadding,
        ),
        title: "Suggestions",
        subTitle: "Please provide suggestions with the form below",
        formFields: Builder(
          builder: (BuildContext context) {
            return StateBuilder(
              stateID: "suggState",
              blocs: [suggData],
              builder: (state) {
                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      suggData.isLoading
                          ? LinearProgressIndicator()
                          : SizedBox(height: 0),
                      SizedBox(
                        height: suggData.isLoading ? 20 : 0,
                      ),
                      TextFormField(
                        decoration: formInputStyle.copyWith(
                          hintText: 'Name',
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            size: 25,
                            color: appGreen,
                          ),
                        ),
                        controller: nameCtrl,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: formInputStyle.copyWith(
                          hintText: 'Email',
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            size: 25,
                            color: appGreen,
                          ),
                        ),
                        validator: (String val) {
                          if (val.isEmpty ||
                              !RegExp(r'\b[\w\d\W\D]+(?:@(?:[\w\d\W\D]+(?:\.(?:[\w\d\W\D]+))))\b')
                                  .hasMatch(val)) {
                            return 'Email must is invalid e.g username@mailprovider.com';
                          }
                          return null;
                        },
                        controller: emailCntrl,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: formInputStyle.copyWith(
                          hintText: 'Suggestion Title',
                          prefixIcon: Icon(
                            Icons.title,
                            size: 25,
                            color: appGreen,
                          ),
                        ),
                        controller: titleCtrl,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: formInputStyle.copyWith(
                          hintText: 'Suggestion',
                          prefixIcon: Icon(
                            Icons.message,
                            size: 25,
                            color: appGreen,
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        controller: contentCtrl,
                        maxLines: null,
                      ),
                      SizedBox(
                        height: 20.0,
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
                                presentSnackBar(
                                    context: context,
                                    title:
                                        "Suggestion was successfully submitted",
                                    color: Theme.of(context).accentColor);
                              } else {
                                presentSnackBar(
                                    context: context,
                                    title:
                                        "Suggestion wasn't successfully submitted, please check that you have internet connection");
                              }
                            }).catchError((err) {
                              formKey.currentState.reset();
                              presentSnackBar(
                                  context: context,
                                  title:
                                      "Suggestion wasn't successfully submitted, please check that you have internet connection");
                            });
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Color(0xFF9B0D54),
                                content: AutoSizeText(
                                  "Please provide valid entries",
                                ),
                              ),
                            );
                          }
                        },
                        child: AutoSizeText("Submit Suggestion"),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      navIcon: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              size: 30.0,
              color: appWhite,
            ),
            onPressed: Scaffold.of(context).openDrawer,
          );
        },
      ),
    );
  }
}
