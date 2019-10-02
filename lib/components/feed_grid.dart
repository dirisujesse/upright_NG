import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_share/simple_share.dart';
import 'package:Upright_NG/components/parsed_text.dart';

import 'package:auto_size_text/auto_size_text.dart';

class FeedGrid extends StatelessWidget {
  final List<dynamic> posts;
  final Function callback;
  FeedGrid({this.posts = const [], this.callback});

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    int _axisCount = _screenWidth <= 1000 ? 2 : 3;
    print(_screenWidth);
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _axisCount,
        mainAxisSpacing: 0,
        childAspectRatio: 5 / 7,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, idx) {
          final int gridCount = _axisCount * 2;
          final int tileIdx = _axisCount == 2 ? idx + 1 : idx;
          final bool condition = _axisCount == 2
              ? (tileIdx / gridCount).toString().endsWith("0") ||
                  ((tileIdx - 1) / gridCount).toString().endsWith("0")
              : tileIdx % 2 == 0;
          if (condition) {
            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                  context, '/post/${posts[idx]["id"]}/${posts[idx]["title"]}',
                  arguments: posts[idx]),
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.6),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      child: Hero(
                        tag: posts[idx]["id"],
                        child: posts[idx]["image"].endsWith(".m4a")
                            ? Image.asset(
                                "assets/images/waveform.png",
                                fit: BoxFit.cover,
                                color: Color.fromRGBO(0, 0, 0, 0.6),
                                colorBlendMode: BlendMode.darken,
                              )
                            : posts[idx]["image"].endsWith(".mp4")
                                ? Image.asset(
                                    "assets/images/vid.jpg",
                                    fit: BoxFit.cover,
                                    color: Color.fromRGBO(0, 0, 0, 0.6),
                                    colorBlendMode: BlendMode.darken,
                                  )
                                : posts[idx]["image"].endsWith("Logo.jpg")
                                    ? Image.asset(
                                        "assets/images/Logomin.jpg",
                                        fit: BoxFit.cover,
                                        color: Color.fromRGBO(0, 0, 0, 0.6),
                                        colorBlendMode: BlendMode.darken,
                                      )
                                    : Image.network(
                                        posts[idx]["image"],
                                        fit: BoxFit.cover,
                                        color: Color.fromRGBO(0, 0, 0, 0.6),
                                        colorBlendMode: BlendMode.darken,
                                      ),
                      ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      left: 5.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            UprightParsedText(
                              text: posts[idx]["title"],
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style:
                                  Theme.of(context).textTheme.headline.copyWith(
                                        fontSize: 20,
                                        color: appWhite,
                                        fontWeight: FontWeight.w900,
                                      ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: CircleAvatar(
                                backgroundColor: appWhite,
                                backgroundImage: posts[idx]["anonymous"]
                                    ? null
                                    : NetworkImage(
                                        posts[idx]["author"]["avatar"],
                                      ),
                                radius: 20,
                              ),
                              title: AutoSizeText(
                                posts[idx]["anonymous"]
                                    ? "Anonymous"
                                    : posts[idx]["author"]["name"],
                                style:
                                    Theme.of(context).textTheme.title.copyWith(
                                          fontSize: 17.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.0,
                      right: 5.0,
                      child: IconButton(
                        icon: Icon(
                          Icons.share,
                        ),
                        onPressed: () {
                          SimpleShare.share(
                            msg:
                                '${posts[idx]["body"] ?? ""} ${posts[idx]["image"] ?? ""}',
                            title: posts[idx]["title"],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                  context, '/post/${posts[idx]["id"]}/${posts[idx]["title"]}',
                  arguments: posts[idx]),
              child: Container(
                color: appLightGrey,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            UprightParsedText(
                              text: posts[idx]["title"],
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style:
                                  Theme.of(context).textTheme.headline.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            UprightParsedText(
                              text: posts[idx]["body"],
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                    ),
                    Positioned(
                      bottom: 20.0,
                      left: 5.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: CircleAvatar(
                                backgroundColor: appBlack,
                                backgroundImage: posts[idx]["anonymous"]
                                    ? null
                                    : NetworkImage(
                                        posts[idx]["author"]["avatar"],
                                      ),
                                radius: 20,
                              ),
                              title: AutoSizeText(
                                posts[idx]["anonymous"]
                                    ? "Anonymous"
                                    : posts[idx]["author"]["name"],
                                style:
                                    Theme.of(context).textTheme.title.copyWith(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.0,
                      right: 5.0,
                      child: IconButton(
                        icon: Icon(
                          Icons.share,
                          color: appBlack,
                        ),
                        onPressed: () {
                          SimpleShare.share(
                            msg:
                                '${posts[idx]["body"] ?? ""} ${posts[idx]["image"] ?? ""}',
                            title: posts[idx]["title"],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        childCount: posts.length,
      ),
    );
  }
}
