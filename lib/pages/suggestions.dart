import 'package:flutter/material.dart';
import '../components/app_drawer.dart';
import '../components/app_bar_default.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    scrnSiaz = MediaQuery.of(context).size.width;
    scrnHaiyt = MediaQuery.of(context).size.height;
    pagePad = scrnSiaz > 550 ? scrnSiaz * 0.085 : scrnSiaz * 0.035;
    topPadding = scrnSiaz > 550 ? scrnSiaz * 0.010 : scrnSiaz * 0.15;
    final formBrdr = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    );
    final formActiveBrdr = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    );
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBarDefault(title: "Suggestions"),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: scrnHaiyt,
          width: scrnSiaz,
          padding: EdgeInsets.symmetric(horizontal: pagePad, vertical: 10.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: topPadding,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      labelText: 'Your Name',
                      filled: false,
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                    controller: nameCtrl,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      labelText: 'Email',
                      filled: false,
                    ),
                    controller: emailCntrl,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      labelText: 'Suggestion Title',
                      filled: false,
                    ),
                    controller: titleCtrl,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      labelText: 'Suggestion',
                      filled: false,
                    ),
                    keyboardType: TextInputType.multiline,
                    controller: contentCtrl,
                    maxLines: null,
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                  RaisedButton(
                    onPressed: () => Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Submitting your suggestions"),
                            action: SnackBarAction(
                              label: "OK",
                              onPressed: () => "",
                            ),
                          ),
                        ),
                    color: Color(0xFFE8C11C),
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: Color(0xFF25333D)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
