import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  final formBrdr = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  );
  final formActiveBrdr = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  );
  List<Widget> loginWidget(context) {
    return <Widget>[
      TextField(
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
            enabledBorder: formBrdr,
            focusedBorder: formActiveBrdr,
            labelText: 'Username',
            filled: false),
        style: TextStyle(color: Colors.white, fontSize: 20.0),
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(
        height: 10.0,
      ),
      RaisedButton(
        color: Color(0xFFE8C11C),
        child: Text('LOGIN'),
        onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
      ),
      Row(
        children: <Widget>[
          Text(
            "New here?",
            style: TextStyle(color: Colors.white),
          ),
          FlatButton(
            child: Text(
              "register",
              style: TextStyle(color: Colors.blueAccent),
            ),
            onPressed: () => setState(() => isLogin = false),
          )
        ],
      )
    ];
  }

  List<Widget> regWidget(context) {
    return <Widget>[
      TextField(
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
          enabledBorder: formBrdr,
          focusedBorder: formActiveBrdr,
          labelText: 'Fullname',
          filled: false,
        ),
        style: TextStyle(color: Colors.white, fontSize: 20.0),
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(
        height: 10.0,
      ),
      TextField(
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
          enabledBorder: formBrdr,
          focusedBorder: formActiveBrdr,
          labelText: 'Username',
          filled: false,
        ),
        style: TextStyle(color: Colors.white, fontSize: 20.0),
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(
        height: 10.0,
      ),
      RaisedButton(
        color: Color(0xFFE8C11C),
        child: Text('REGISTER'),
        onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
      ),
      Row(
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(color: Colors.white),
          ),
          FlatButton(
            child: Text(
              "login",
              style: TextStyle(color: Colors.blueAccent),
            ),
            onPressed: () => setState(() => isLogin = true),
          )
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/tourguide02.jpg"),
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: isLogin ? loginWidget(context) : regWidget(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
