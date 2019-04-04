import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../components/form_style.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isEdit = false;
  List<Widget> grids(Map<String, dynamic> user) {
    return [
      Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          // shape: BoxShape.circle,
          // border: Border(
          //   right: BorderSide(color: Color(0xFF333333)),
          //   bottom: BorderSide(color: Color(0xFF333333)),
          // ),
          color: Color(0xFFE8C11C),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "0",
              style: TextStyle(fontSize: 50.0),
            ),
            Text(
              "POSTS",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          // border: Border(
          //   bottom: BorderSide(color: Color(0xFF333333)),
          // ),
          color: Color(0xFFE8C11C),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "0",
              style: TextStyle(fontSize: 50.0),
            ),
            Text(
              "COMMENTS",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          // border: Border(
          //   right: BorderSide(color: Color(0xFF333333)),
          // ),
          color: Color(0xFFE8C11C),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "0",
              style: TextStyle(fontSize: 50.0),
            ),
            Text(
              "UPVOTES",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xFFE8C11C),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "0",
              style: TextStyle(fontSize: 50.0),
            ),
            Text(
              "DOWNVOTES",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    ];
  }

  Widget form(Map<String, dynamic> user) {
    // <FormLabel TextColor="#111" Alignment="Left">Name</FormLabel>
    // <FormLabel TextColor="#111" Alignment="Left">Email</FormLabel>
    // <FormLabel TextColor="#111" Alignment="Left">City</FormLabel>
    // <FormLabel TextColor="#111" Alignment="Left">State</FormLabel>
    // <FormLabel TextColor="#111" Alignment="Left">Country</FormLabel>

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          alignment: FractionalOffset.center,
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 18.0),
                      enabledBorder: formBrdr,
                      focusedBorder: formActiveBrdr,
                      labelText: 'Name',
                      filled: false,
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                    // controller: nameCtrl,
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
                    // controller: emailCntrl,
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
                      labelText: 'City',
                      filled: false,
                    ),
                    // controller: titleCtrl,
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
                      labelText: 'State',
                      filled: false,
                    ),
                    // controller: titleCtrl,
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
                      labelText: 'Country',
                      filled: false,
                    ),
                    // controller: titleCtrl,
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
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Product Detail'),
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isEdit ? Icons.close : Icons.edit),
        onPressed: () => setState(() => isEdit = !isEdit),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFF4D4E4E),
            leading: IconButton(
              icon: Icon(
                Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoIcons.back
                    : Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Dirisu Jesse",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
              background: Hero(
                tag: "Dirisu Jesse",
                child: Container(
                  decoration: BoxDecoration(color: Color(0xFF4D4E4E)),
                  child: Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                          'https://www.themealdb.com/images/ingredients/chocolate.png'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          isEdit
              ? form({})
              : SliverGrid.count(
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  crossAxisCount: 2,
                  children: grids({}),
                ),
        ],
      ),
    );
  }
}
