import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../components/app_drawer.dart';
import '../styles/text_style.dart';
import '../components/app_bar_default.dart';
import '../components/app_activity_indicator.dart';
import '../models/user.dart';
import '../stores/user.dart';
import 'package:auto_size_text/auto_size_text.dart';

final usrBloc = UserBloc.getInstance();

class TopcontributorsPage extends StatefulWidget {
  _TopcontributorsPageState createState() => _TopcontributorsPageState();
}

class _TopcontributorsPageState extends State<TopcontributorsPage> {
  @override
  void dispose() {
    usrBloc.disposeTopConts();
    super.dispose();
  }

  Widget tile(User data) {
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
          backgroundImage: NetworkImage(data.avatar),
        ),
        title: AutoSizeText(
          data.name,
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

  dynamic body(UserBloc data) {
    if (data.isLoadingTopUsrs) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const AppSpinner(),
            AutoSizeText(
              data.msgTopUsrs,
              style: AppTextStyle.appText,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }

    if (!data.isLoadingTopUsrs && data.topConts.length < 1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            data.loadingTopUsrsFail
                ? Icon(
                    LineIcons.exclamation_circle,
                    size: 100.0,
                  )
                : Icon(
                    LineIcons.trash,
                    size: 100.0,
                  ),
            AutoSizeText(
              data.loadingTopUsrsFail
                  ? data.msgTopUsrs
                  : "Ooops Contributors list is empty",
              style: AppTextStyle.appText,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }

    if (data.topConts.length > 1) {
      return ListView.builder(
        itemCount: data.topConts.length,
        itemBuilder: (BuildContext context, int index) {
          return tile(User.fromJson(data.topConts[index]));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFCCCCCC),
            ),
          ),
        ),
        height: 40,
        child: Center(
          child: AutoSizeText(
            "PULL PAGE TO REFRESH",
            style: AppTextStyle.appText,
          ),
        ),
      ),
      drawer: AppDrawer(),
      appBar: appBarDefault(title: "Top Contributors", context: context),
      backgroundColor: Colors.white,
      body: StateBuilder(
        initState: (state) => usrBloc.getTopConts(state),
        builder: (_) => RefreshIndicator(
              onRefresh: () {
                usrBloc.getTopConts(this);
                return Future.value(null);
              },
              child: body(usrBloc),
            ),
      ),
    );
  }
}
