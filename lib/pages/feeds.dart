import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../components/app_drawer.dart';
import '../components/upright_search.dart';
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

  Widget carousel(Map<String, dynamic> posts, context) {
    return Stack(
      children: <Widget>[
        PageView.builder(
          onPageChanged: (val) => setState(() => activ = val),
          itemCount: 5,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Bird Dies in Berlin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  Text(
                    "Unfortunately a bird today passed away at the Berlin zoo...",
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    DateTime.now().toIso8601String(),
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
              numberOfDot: 5,
              position: activ,
              dotColor: Color(0xFF2F333D),
              dotActiveColor: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ],
    );
  }

  Widget recent(Map<String, dynamic> posts, context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, idx) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/post/1/Bird Dies in Berlin'),
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
                        image: NetworkImage(
                          "https://www.tennisworldusa.org/imgb/60080/naomi-osaka-i-m-the-most-awkward-in-tennis.jpg",
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Bird Dies in Berlin",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        Text(
                          "Unfortunately a bird today passed away at the Berlin zoo...",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          DateTime.now().toIso8601String(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
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
                      "Bird Dies in Berlin",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "Unfortunately a bird today passed away at the Berlin zoo...",
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
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
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
                              Icon(LineIcons.comment),
                              Text('5'),
                            ],
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(LineIcons.heart_o),
                              Text('5'),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.share,
                        ),
                        onTap: () => "",
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      drawer: AppDrawer(),
      body: Builder(
        builder: (BuildContext context) {
          return NestedScrollView(
            controller: scrlCntrl,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
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
                          delegate: UprightSearchDelegate()
                        );
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
                            image: AssetImage("assets/images/tourguide01.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: carousel({}, context),
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
                recent({}, context),
                recent({}, context),
              ],
            ),
          );
        },
      ),
    );
  }
}
