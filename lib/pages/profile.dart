import 'dart:async';

import 'package:Upright_NG/components/page_scaffold.dart';
import 'package:Upright_NG/components/ratings.dart';
import 'package:Upright_NG/stores/post.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../components/app_activity_indicator.dart';
import '../stores/user.dart';
import 'package:auto_size_text/auto_size_text.dart';

final usrData = UserBloc.getInstance();
final postData = PostBloc.getInstance();

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _displayStarExplanation({BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Color(0x00),
          body: SafeArea(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: appWhite,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Rating System",
                        style: Theme.of(context).textTheme.title,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              RatingWidget(
                                postCount: 0,
                                showTitle: false,
                                alignment: WrapAlignment.start,
                              ),
                              Text(
                                "0 to 9 posts",
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              RatingWidget(
                                postCount: 10,
                                showTitle: false,
                                alignment: WrapAlignment.start,
                              ),
                              Text(
                                "10 to 19 posts",
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              RatingWidget(
                                postCount: 20,
                                showTitle: false,
                                alignment: WrapAlignment.start,
                              ),
                              Text(
                                "20 to 29 posts",
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              RatingWidget(
                                postCount: 30,
                                showTitle: false,
                                alignment: WrapAlignment.start,
                              ),
                              Text(
                                "30 to 39 posts",
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              RatingWidget(
                                postCount: 40,
                                showTitle: false,
                                alignment: WrapAlignment.start,
                              ),
                              Text(
                                "40 to 49 posts",
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              RatingWidget(
                                postCount: 50,
                                showTitle: false,
                                alignment: WrapAlignment.start,
                              ),
                              Text(
                                "50 or more posts",
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      activeRoute: 3,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: appBlack),
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.title,
            ),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                child: Text("My Gifts"),
                onPressed: () {
                  Navigator.of(context).pushNamed("/gifts");
                },
                textColor: Colors.grey,
                padding: EdgeInsets.all(5),
              )
            ],
            pinned: true,
            elevation: 0,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              size: 15,
                              color: appYellow,
                            ),
                            Text(
                              "?",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      onTap: () => _displayStarExplanation(context: context),
                    )),
                UserAvatar(),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    AutoSizeText(
                      usrData.activeUser.username,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 30.0, color: appBlack),
                    ),
                    SizedBox(
                      width: usrData.activeUser.isMember ?? false ? 5 : 0,
                    ),
                    StateBuilder(
                      blocs: [usrData],
                      stateID: "memberState1",
                      builder: (_) {
                        if (usrData.activeUser.isMember ?? false) {
                          return Image.asset("assets/images/verified.png");
                        }
                        return SizedBox();
                      },
                    )
                  ],
                ),
                AutoSizeText(
                  "${usrData.activeUser.state ?? "Login"}, ${usrData.activeUser.country ?? "to show location"}",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                usrData.isLoggedIn
                    ? StateBuilder(
                        initState: (state) {
                          Timer(Duration(seconds: 1),
                              () => usrData.getUserStat(state));
                        },
                        builder: (_) {
                          final count = usrData.usrStat ?? {"posts": 0};
                          return Column(
                            children: <Widget>[
                              RatingWidget(postCount: count["posts"]),
                              SizedBox(
                                height: 25,
                              ),
                              usrData.isLoadingStat
                                  ? Center(
                                      child: const AppSpinner(),
                                    )
                                  : usrData.usrStat != null
                                      ? const StatsWidget()
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const StatsWidget(),
                                              FlatButton(
                                                padding: EdgeInsets.all(5),
                                                child: AutoSizeText(
                                                  "User stat retrieval fetch failed, retry",
                                                  style: TextStyle(
                                                    color: Color(0xFF007CBB),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    usrData.getUserStat(this),
                                              )
                                            ],
                                          ),
                                        )
                            ],
                          );
                        },
                      )
                    : SizedBox(),
              ],
            ),
          ),
          usrData.isLoggedIn ?? false
              ? SliverPadding(
                  padding: EdgeInsets.only(top: 30),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 13,
                                        width: 13,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: appGreen,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Feeds",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                  Text(
                                    DateFormat.yMMMEd().format(DateTime.now()),
                                    textAlign: TextAlign.end,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final size = MediaQuery.of(context).size;
                            if (postData.posts != null &&
                                postData.posts.length > 0) {
                              final posts = postData.posts;
                              return Container(
                                constraints: BoxConstraints(
                                  maxHeight: size.height * 0.3,
                                  maxWidth: size.width,
                                ),
                                child: ListView.builder(
                                  itemCount:
                                      posts.length > 5 ? 5 : posts.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, idx) {
                                    return GestureDetector(
                                      onTap: () => Navigator.pushNamed(context,
                                          '/post/${posts[idx]["id"]}/${posts[idx]["title"]}',
                                          arguments: posts[idx]),
                                      child: Container(
                                        width: size.width * 0.8,
                                        margin: EdgeInsets.only(right: 20),
                                        color: appShadow,
                                        child: posts[idx]["image"]
                                                .endsWith(".m4a")
                                            ? Image.asset(
                                                "assets/images/waveform.png",
                                                fit: BoxFit.cover,
                                              )
                                            : posts[idx]["image"]
                                                    .endsWith(".mp4")
                                                ? Image.asset(
                                                    "assets/images/vid.jpg",
                                                    fit: BoxFit.cover,
                                                  )
                                                : posts[idx]["image"]
                                                        .endsWith("Logo.jpg")
                                                    ? Image.asset(
                                                        "assets/images/Logomin.jpg",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        posts[idx]["image"],
                                                        fit: BoxFit.cover,
                                                      ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Center(
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.cloud_off,
                                      size: 40,
                                    ),
                                    Text(
                                        "No feed, check your internet connection"),
                                  ],
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Sign in to view profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RaisedButton(
                        child: Text("Sign In"),
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed("/login"),
                      )
                    ]),
                  ),
                )
        ],
      ),
    );
  }
}

class StatsWidget extends StatelessWidget {
  const StatsWidget();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: appGreen,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                usrData.usrStat != null
                    ? usrData.usrStat["posts"] != null
                        ? usrData.usrStat["posts"].toString()
                        : "0"
                    : "0",
                style: Theme.of(context).textTheme.body2.copyWith(
                      color: appWhite,
                    ),
              ),
              AutoSizeText(
                "Posts",
                style:
                    Theme.of(context).textTheme.body1.copyWith(color: appWhite),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: appGreen,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                usrData.usrStat != null
                    ? usrData.usrStat["comments"] != null
                        ? usrData.usrStat["comments"].toString()
                        : "0"
                    : "0",
                style:
                    Theme.of(context).textTheme.body2.copyWith(color: appWhite),
              ),
              AutoSizeText(
                "Comments",
                style:
                    Theme.of(context).textTheme.body1.copyWith(color: appWhite),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: appGreen,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                usrData.usrStat != null
                    ? usrData.usrStat["points"] != null
                        ? usrData.usrStat["points"].toString()
                        : "0"
                    : "0",
                style:
                    Theme.of(context).textTheme.body2.copyWith(color: appWhite),
              ),
              AutoSizeText(
                "Points",
                style:
                    Theme.of(context).textTheme.body1.copyWith(color: appWhite),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                StateBuilder(
                  stateID: "avatarState1",
                  blocs: [usrData],
                  builder: (_) {
                    return CircleAvatar(
                      radius: 100,
                      backgroundImage: usrData.tempAvatar != null
                          ? FileImage(usrData.tempAvatar)
                          : NetworkImage(
                              usrData.activeUser.avatar,
                            ),
                      backgroundColor: appGreen,
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: usrData.isLoggedIn
                      ? GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appWhite.withOpacity(0.95),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Icon(
                                Icons.add_a_photo,
                                color: appGreen,
                                size: 30,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (!usrData.isChangingAvatar) {
                              usrData.getImage(
                                  Theme.of(context).platform, true);
                            }
                            // Scaffold.of(context).showBottomSheet(
                            //   (context) {
                            //     return FractionallySizedBox(
                            //       heightFactor: 0.15,
                            //       child: Row(
                            //         crossAxisAlignment: CrossAxisAlignment.stretch,
                            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //         children: <Widget>[
                            //           FlatButton.icon(
                            //             icon: Icon(Icons.photo_library),
                            //             label: Text("Open Gallery"),
                            //             textColor: appBlack,
                            //             onPressed: () {
                            //               usrData.getImage(Theme.of(context).platform, true);
                            //             },
                            //           ),
                            //           FlatButton.icon(
                            //             icon: Icon(Icons.camera),
                            //             label: Text("Take Photo"),
                            //             textColor: appBlack,
                            //             onPressed: () {
                            //               usrData.getImage(Theme.of(context).platform, false);
                            //             },
                            //           ),
                            //         ],
                            //       ),
                            //     );
                            //   },
                            //   backgroundColor: appWhite,
                            //   elevation: 2
                            // );
                          },
                        )
                      : SizedBox(),
                ),
                Positioned.fill(
                  child: StateBuilder(
                    stateID: "avatarState",
                    blocs: [usrData],
                    builder: (_) {
                      return Container(
                        color: usrData.isChangingAvatar
                            ? Colors.white.withOpacity(0.8)
                            : null,
                        child: Center(
                          child: usrData.isChangingAvatar
                              ? AppSpinner()
                              : SizedBox(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
