import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import "dart:async";
import 'package:line_icons/line_icons.dart';
import '../components/app_drawer.dart';
import '../components/text_style.dart';
import '../components/app_bar_default.dart';
import '../services/http_service.dart';

class TopcontributorsPage extends StatefulWidget {
  _TopcontributorsPageState createState() => _TopcontributorsPageState();
}

class _TopcontributorsPageState extends State<TopcontributorsPage> {
  bool isLoading = true;
  String msg = "Loading top users..";
  List<dynamic> topConts = [];

  Future<void> getTopConts() {
    setState(() {
      isLoading = true;
      msg = "Loading top users..";
    });
    HttpService.getTopUsers().then((val) {
      setState(() {
        topConts = val;
        isLoading = false;
        msg = "";
      });
    }).catchError((err) {
      print(err);
      setState(() {
        isLoading = false;
        msg =
            "Failed to load top users check that you are connected to the internet";
      });
    });
    return Future.value(null);
  }

  void initState() {
    getTopConts();
    super.initState();
  }

  Widget tile(Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xFF37B34A), width: 5),
          // bottom: BorderSide(color: Color(0xFF25333D), width: 1.5),
        ),
      ),
      child: ListTile(
        // contentPadding: EdgeInsets.all(15.0),
        enabled: false,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data["avatar"]),
        ),
        title: Text(
          data["name"],
          style: AppTextStyle.appHeader,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              LineIcons.star,
              color: Color(0xFFE8C11C),
            ),
            Icon(
              LineIcons.star,
              color: Color(0xFFE8C11C),
            ),
            Icon(
              LineIcons.star,
              color: Color(0xFFE8C11C),
            ),
            Icon(
              LineIcons.star,
              color: Color(0xFFE8C11C),
            ),
            Icon(
              LineIcons.star,
              color: Color(0xFFE8C11C),
            ),
          ],
        ),
      ),
    );
  }

  dynamic get body {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(),
            Text(
              msg,
              style: AppTextStyle.appText,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
    
    if (!isLoading && topConts.length < 1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            msg.length > 0
                ? Icon(
                    LineIcons.exclamation_circle,
                    size: 100.0,
                  )
                : Icon(
                    LineIcons.trash,
                    size: 100.0,
                  ),
            Text(
              msg.length > 0 ? msg : "Ooops Contributors list is empty",
              style: AppTextStyle.appText,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }

    if (topConts.length > 1) {
      return ListView.builder(
        itemCount: topConts.length,
        itemBuilder: (BuildContext context, int index) {
          return tile(topConts[index]);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFCCCCCC)))),
        height: MediaQuery.of(context).size.height * 0.08,
        child: Center(
          child: Text(
            "PULL PAGE TO REFRESH",
            style: AppTextStyle.appText,
          ),
        ),
      ),
      drawer: AppDrawer(),
      appBar: AppBarDefault(title: "Top Contributors"),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => getTopConts(),
        child:  body,
      ),
    );
  }
}
