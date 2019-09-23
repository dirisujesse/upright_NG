import 'package:Upright_NG/components/app_banner.dart';
import 'package:Upright_NG/components/feed_grid.dart';
import 'package:Upright_NG/components/page_scaffold.dart';
import 'package:Upright_NG/components/parsed_text.dart';
import 'package:Upright_NG/delegates/header_delegate.dart';
import 'package:Upright_NG/pages/post_create.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:line_icons/line_icons.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:auto_size_text/auto_size_text.dart';
import '../components/app_activity_indicator.dart';
import '../components/upright_search.dart';
import '../stores/post.dart';

final postData = PostBloc.getInstance();

class FeedsPage extends StatefulWidget {
  final int activePage;
  final bool isAnon;
  FeedsPage({
    this.activePage = 0,
    this.isAnon = false,
  });

  @override
  State<StatefulWidget> createState() {
    return FeedsPageState();
  }
}

class FeedsPageState extends State<FeedsPage> with TickerProviderStateMixin {
  String title = "";
  ScrollController scrlCntrl;
  TabController tabCntrl;
  ValueNotifier activePage;

  void initState() {
    scrlCntrl = ScrollController();
    tabCntrl =
        TabController(length: 2, vsync: this, initialIndex: widget.activePage);
    tabCntrl.addListener(() => activePage.value = tabCntrl.index);
    activePage = ValueNotifier(widget.activePage);
    super.initState();
  }

  @override
  void dispose() {
    postData.disposeFeeds();
    scrlCntrl.dispose();
    super.dispose();
  }

  void switchTabs(int indx) {
    tabCntrl.animateTo(indx,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activePage,
      builder: (context, page, child) {
        return PageScaffold(
          navWithinHome: switchTabs,
          activeRoute: page,
          floatingActionButton: page == 0
              ? Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.refresh,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () => postBloc.getFeed(this, true),
                        heroTag: "refresh",
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () => switchTabs(1),
                        heroTag: "addpost",
                      ),
                    ],
                  ),
                )
              : null,
          child: StateBuilder(
            initState: (state) => postData.getFeed(state),
            blocs: [postBloc],
            builder: (_) {
              return NestedScrollView(
                controller: scrlCntrl,
                headerSliverBuilder:
                    (BuildContext context, bool boxIsScrolled) {
                  return [
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      backgroundColor: Color(0xFF467D4D),
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
                      expandedHeight: MediaQuery.of(context).size.height * 0.3,
                      flexibleSpace: const AppBanner(),
                    ),
                    SliverPersistentHeader(
                      floating: false,
                      pinned: true,
                      delegate: UprightSliverAppBarDelegate(
                        child: TabBar(
                          controller: tabCntrl,
                          tabs: <Widget>[
                            Tab(
                              child: AutoSizeText(
                                "Feed",
                              ),
                            ),
                            Tab(
                              child: AutoSizeText(
                                "Report",
                              ),
                            )
                          ],
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
                            child: const AppSpinner(),
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
                                    AutoSizeText(
                                        "Oops data fetch failed, check your internet connection"),
                                  ],
                                ),
                              )
                            : StateBuilder(
                                stateID: "recPostState",
                                blocs: [postData],
                                builder: (_) {
                                  return LazyLoadScrollView(
                                    child: CustomScrollView(
                                      slivers: <Widget>[
                                        SliverList(
                                          delegate: SliverChildListDelegate(
                                            [
                                              Carousel(
                                                  posts: postData.testimonials),
                                            ],
                                          ),
                                        ),
                                        Feeds(
                                          isRecent: true,
                                          posts: postData.posts,
                                        )
                                      ],
                                    ),
                                    onEndOfPage: () => postData.loadNew(),
                                  );
                                },
                              ),
                    PostCreatePage(
                      isAnon: widget.isAnon,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class Carousel extends StatelessWidget {
  final activ = ValueNotifier(0);
  final List<dynamic> posts;
  Carousel({@required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts != null && posts.length > 0) {
      return Container(
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              child: AutoSizeText(
                "Testimonials",
                style:
                    Theme.of(context).textTheme.headline.copyWith(fontSize: 25),
              ),
              padding: EdgeInsets.only(
                top: 10.0,
                left: 15.0,
                bottom: 5,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: posts.map((post) {
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, '/testimonials',
                          arguments: posts),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 20.0,
                          top: 10.0,
                          bottom: 10.0,
                          // left: 10.0,
                        ),
                        width: 300,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                color: appShadow,
                                blurRadius: 5,
                                spreadRadius: 3,
                              )
                            ]),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(15),),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: appBlack,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      post["author"]["avatar"],
                                    ),
                                  ),
                                ),
                              ),
                              title: UprightParsedText(
                                text: post["author"]["username"],
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .copyWith(fontSize: 20),
                              ),
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                              child: UprightParsedText(
                                text: post["content"],
                                maxLines: post["content"].toString().length,
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                              ),
                            ))
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
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
              color: Colors.white,
            ),
            AutoSizeText(
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
}

class Feeds extends StatelessWidget {
  final List<dynamic> posts;
  final bool isRecent;

  Feeds({@required this.posts, this.isRecent = false});

  @override
  Widget build(BuildContext context) {
    if (posts != null && posts.length > 0) {
      return FeedGrid(
        posts: posts,
      );
    } else {
      return SliverList(
        delegate: SliverChildListDelegate([
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  LineIcons.hourglass_o,
                  size: 100.0,
                ),
                AutoSizeText(
                  "Oops post list looks empty, this may be due to a failed data fetch, check your network connection",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ]),
      );
    }
  }
}
