import 'package:Upright_NG/components/page_scaffold.dart';
import 'package:Upright_NG/components/parsed_text.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TestimonialPage extends StatelessWidget {
  final List<dynamic> posts;
  const TestimonialPage({@required this.posts});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      color: Color(0xFFF9F9F9),
      activeRoute: 4,
      appBar: AppBar(
        backgroundColor: appWhite,
        leading: BackButton(
          color: appBlack,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed("/settings"),
          )
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed('/testimonials/create'),
      ),
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: appWhite,
                boxShadow: [
                  BoxShadow(
                    color: appShadow,
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Testimonial",
                      style: Theme.of(context).textTheme.title.copyWith(
                            color: appGreen,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      "Earn points by sharing your story on how you have used our gift items.",
                      style: TextStyle(
                          color: appGreen, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                itemCount: posts.length,
                itemBuilder: (context, idx) {
                  final post = posts[idx];
                  return Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.3),
                    margin: EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 25.0,
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
                            text: post["author"]["name"],
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
                                  .copyWith(fontSize: 17),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
