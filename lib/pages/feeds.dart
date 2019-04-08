import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_icons/line_icons.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:simple_share/simple_share.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../components/app_drawer.dart';
import '../components/upright_search.dart';
import '../stores/post.dart';

final postData = PostBloc.getInstance();

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final bRadius = BorderRadius.only(
    topLeft: Radius.circular(5.0),
    topRight: Radius.circular(5.0),
  );
  int activ = 0;
  String title = "";
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrlCntrl;
  TabController tabCntrl;

  void initState() {
    scrlCntrl = ScrollController();
    tabCntrl = TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget carousel(List<dynamic> posts, context) {
    if (posts != null && posts.length > 0) {
      return Stack(
        children: <Widget>[
          PageView.builder(
            onPageChanged: (val) => setState(() => activ = val),
            itemCount: posts.length,
            itemBuilder: (context, idx) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context,
                    '/post/${posts[idx]["id"]}/${posts[idx]["title"]}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      posts[idx]["title"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontFamily: 'PlayfairDisplay',
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      posts[idx]["body"],
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      posts[idx]["time"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 50.0,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: DotsIndicator(
                numberOfDot: posts.length ?? 5,
                position: activ,
                dotColor: Color(0xFF2F333D),
                dotActiveColor: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              LineIcons.hourglass_o,
              size: 100.0,
              color: Colors.white,
            ),
            Text(
              "Oops featured post list looks empty, this may be due to a failed data fetch, check your network connection",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget recent(List<dynamic> posts, context, [isRecent = true]) {
    if (posts != null && posts.length > 0) {
      return LazyLoadScrollView(
        onEndOfPage: () => isRecent ? postData.loadNew(this) : print("ok"),
        scrollOffset: 50,
        child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, idx) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context,
                      '/post/${posts[idx]["id"]}/${posts[idx]["title"]}'),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        foregroundDecoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          borderRadius: bRadius,
                        ),
                        child: FadeInImage(
                          placeholder: AssetImage("assets/images/logo.jpg"),
                          fit: BoxFit.cover,
                          image: posts[idx]["image"].endsWith(".m4a") ? AssetImage("assets/images/waveform.png") : posts[idx]["image"].endsWith(".mp4") ? AssetImage("assets/images/vid.jpg") : NetworkImage(
                            posts[idx]["image"]
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              posts[idx]["title"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontFamily: 'PlayfairDisplay',
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              posts[idx]["body"],
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              posts[idx]["time"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        posts[idx]["title"],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        posts[idx]["body"],
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  child: SizedBox(
                    height: 20.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(LineIcons.frown_o),
                                Text(posts[idx]["downvotes"].toString()),
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(LineIcons.heart_o),
                                Text(posts[idx]["upvotes"].toString()),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.share,
                          ),
                          onTap: () {
                            SimpleShare.share(
                                msg: posts[idx]["body"],
                                title: posts[idx]["title"]);
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
        );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              LineIcons.hourglass_o,
              size: 100.0,
            ),
            Text(
              "Oops post list looks empty, this may be due to a failed data fetch, check your network connection",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      floatingActionButton: StateBuilder(
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.refresh,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => postData.getFeed(this),
                heroTag: "refresh",
              ),
              SizedBox(
                height: 5.0,
              ),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, '/post/add/notanon');
                },
                heroTag: "addpost",
              ),
            ],
          );
        },
      ),
      drawer: AppDrawer(),
      body: Builder(
        builder: (BuildContext context) {
          return StateBuilder(
            initState: (state) => postData.getFeed(state),
            builder: (_) {
              return NestedScrollView(
                controller: scrlCntrl,
                headerSliverBuilder:
                    (BuildContext context, bool boxIsScrolled) {
                  return [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      // snap: true,
                      bottom: TabBar(
                        controller: tabCntrl,
                        tabs: <Widget>[
                          Tab(
                            child: Text(
                              "RECENT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "TRENDING",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      backgroundColor: Color(0xFF3D8B37),
                      leading: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: UprightSearchDelegate());
                          },
                        ),
                      ],
                      expandedHeight: MediaQuery.of(context).size.height * 0.7,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Hero(
                          tag: "HOME",
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/tourguide01.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: postData.isLoading
                                  ? Theme.of(context).platform ==
                                          TargetPlatform.iOS
                                      ? CupertinoActivityIndicator()
                                      : CircularProgressIndicator()
                                  : postData.failed
                                      ? Column(
                                          children: <Widget>[
                                            Icon(
                                              LineIcons.frown_o,
                                              size: 100.0,
                                            ),
                                            Text(
                                                "Oops data fetch failed, check your internet connection"),
                                          ],
                                        )
                                      : Padding(
                                          padding: EdgeInsets.all(
                                            10.0,
                                          ),
                                          child: carousel(
                                              postData.fposts, context),
                                        ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: tabCntrl,
                  children: <Widget>[
                    postData.isLoading
                        ? Center(
                            child:
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? CupertinoActivityIndicator()
                                    : CircularProgressIndicator(),
                          )
                        : postData.failed
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      LineIcons.frown_o,
                                      size: 100.0,
                                    ),
                                    Text(
                                        "Oops data fetch failed, check your internet connection"),
                                  ],
                                ),
                              )
                            : recent(postData.posts, context),
                    postData.isLoading
                        ? Center(
                            child:
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? CupertinoActivityIndicator()
                                    : CircularProgressIndicator(),
                          )
                        : postData.failed
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      LineIcons.frown_o,
                                      size: 100.0,
                                    ),
                                    Text(
                                        "Oops data fetch failed, check your internet connection"),
                                  ],
                                ),
                              )
                            : recent(postData.tposts, context, false),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
