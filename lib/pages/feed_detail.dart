import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_icons/line_icons.dart';

import '../components/form_style.dart';

class FeedPage extends StatefulWidget {
  final String title;
  final String id;

  FeedPage({@required this.title, @required this.id});
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFE8C11C),
        child: Icon(
          Icons.share,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
      bottomNavigationBar: Container(
        // color: Color(0xFF318700),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      LineIcons.comment,
                      color: Color(0xFF318700),
                    ),
                    Text(
                      '5',
                      style: TextStyle(
                        color: Color(0xFF318700),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      LineIcons.heart_o,
                      color: Color(0xFF318700),
                    ),
                    Text(
                      '5',
                      style: TextStyle(
                        color: Color(0xFF318700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text('by Naomi Osaka'),
                Text(' | '),
                Text('04/12/1994'),
              ],
            )
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return [
            SliverAppBar(
              // backgroundColor: Color.fromRGBO(255, 255, 255, 0.0),
              pinned: true,
              title: Text(
                widget.title,
                style: TextStyle(
                    color: Color(0xFF318700),
                    fontSize: 18.0,
                    fontFamily: 'PlayfairDisplay'),
              ),
              elevation: 0,
              centerTitle: true,
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "by Dirisu Jesse",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF25333D),
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  "Lagos",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF25333D),
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  "May 12 2019; 03:00",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF25333D),
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                FadeInImage(
                  placeholder: AssetImage("assets/images/logo.jpg"),
                  fit: BoxFit.contain,
                  image: NetworkImage(
                    "https://www.tennisworldusa.org/imgb/60080/naomi-osaka-i-m-the-most-awkward-in-tennis.jpg",
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  """Naomi Osaka (大坂 なおみ Ōsaka Naomi, born October 16, 1997) is a professional tennis player who represents Japan. She is the reigning champion in women's singles at the US Open and the Australian Open. Osaka is ranked No. 1 in the world by the Women's Tennis Association (WTA), and is the first Asian player to hold the top ranking in singles. She has won three titles and reached five finals on the WTA Tour.

Born in Japan to a Haitian father and a Japanese mother, Osaka has lived in the United States since she was three years old. She came to prominence at the age of sixteen when she defeated former US Open champion Samantha Stosur in her WTA Tour debut at the 2014 Stanford Classic. Two years later, she reached her first WTA final at the 2016 Pan Pacific Open in Japan to enter the top 50 of the WTA rankings. Osaka made her breakthrough into the upper echelon of women's tennis in 2018, when she won her first WTA title at the Indian Wells Open. In September, she won the US Open, defeating 23-time major champion Serena Williams in the final to become the first Japanese player to win a Grand Slam singles tournament. She won her second Grand Slam title at the 2019 Australian Open.

Osaka is known for her multi-ethnic background and her shy, candid personality. On the court, she has an aggressive playing style with a powerful serve that can reach 125 miles per hour (200 km/h).""",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  color: Color(0xFF25333D),
                  child: Text(
                    "LOAD COMMENTS",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  height: 15.0,
                ),
                Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: Color(0xFFCCCCCC), fontSize: 18.0),
                            enabledBorder: formBrdr,
                            focusedBorder: formActiveBrdr,
                            labelText: 'Comment',
                            filled: false,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          color: Color(0xFFE8C11C),
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(color: Color(0xFF25333D)),
                          ),
                        )
                      ],
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
