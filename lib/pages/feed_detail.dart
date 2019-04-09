import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_icons/line_icons.dart';
import 'package:simple_share/simple_share.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../stores/post.dart';
import '../models/post.dart';
import '../components/form_style.dart';
import '../components/video_player.dart';

final postData = PostBloc.getInstance();

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
  TextEditingController comntCtrl;

  @override
  void initState() {
    super.initState();
    comntCtrl = TextEditingController(text: "");
  }

  Widget commentsList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      margin: EdgeInsets.symmetric(horizontal: 1.0),
      height: MediaQuery.of(context).size.height * 0.83,
      decoration: BoxDecoration(
        color: Color(0xCCCCCCCC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: StateBuilder(
        blocs: [postData],
        stateID: "postComState",
        builder: (_) {
          if (postData.showComments) {
            if (postData.isLoadingComments) {
              return Center(
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
              );
            } else {
              final comments = postData.comments;
              if (comments.length > 0) {
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.teal,
                            backgroundImage: NetworkImage(
                              comments[idx]["author"]["avatar"],
                            ),
                            radius: 34.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                comments[idx]["author"]["name"],
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                comments[idx]["time"],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10.0,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  comments[idx]["body"],
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "Be the first to comment",
                  ),
                );
              }
            }
          }
          return SizedBox(
            height: 0.0,
          );
        },
      ),
    );
  }

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
        onPressed: () {
          SimpleShare.share(msg: postData.post.body, title: widget.title);
        },
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF318700),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        height: 40.0,
        child: StateBuilder(
          blocs: [postData],
          stateID: "postDetState",
          builder: (_) {
            final Post post = postData.post ?? null;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => postData.vote(false),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            LineIcons.frown_o,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            post == null ? "0" : post.downvotes.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () => postData.vote(),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            LineIcons.heart,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            post == null ? "0" : post.upvotes.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  post == null
                      ? ""
                      : !post.anonymous
                          ? "by " + post.author.name
                          : "by Anonymous User",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            );
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  title: Text(
                    "POST",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  elevation: 0.5,
                  centerTitle: true,
                ),
              ];
            },
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              height: MediaQuery.of(context).size.height,
              child: StateBuilder(
                initState: (state) => postData.getPost(state, widget.id),
                builder: (_) {
                  if (postData.isLoadingPost) {
                    return Center(
                      child: Theme.of(context).platform == TargetPlatform.iOS
                          ? CupertinoActivityIndicator()
                          : CircularProgressIndicator(),
                    );
                  } else {
                    if (postData.post != null) {
                      final post = postData.post;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              widget.title.toUpperCase().trim(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF318700),
                                fontSize: 20.0,
                                fontFamily: 'PlayfairDisplay',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              post.anonymous
                                  ? "Anonymous User"
                                  : post.author.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF25333D),
                                fontSize: 14.0,
                              ),
                            ),
                            post.anonymous
                                ? SizedBox(
                                    height: 0.0,
                                  )
                                : Text(
                                    post.loc,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF25333D),
                                      fontSize: 14.0,
                                    ),
                                  ),
                            Text(
                              post.time,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF25333D),
                                fontSize: 12.0,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            post.image.endsWith("m4a") ||
                                    post.image.endsWith("mp4")
                                ? VideoWidget(
                                    url: post.image,
                                  )
                                : FadeInImage(
                                    // height: 200.0,
                                    placeholder:
                                        AssetImage("assets/images/logo.jpg"),
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      post.image,
                                    ),
                                  ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              post.body,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            StateBuilder(
                                blocs: [postData],
                                stateID: "postComState1",
                                builder: (_) {
                                  return RaisedButton(
                                    color: Color(0xFF25333D),
                                    child: Text(
                                      "LOAD COMMENTS",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      postData.loadComments(postData.post.id);
                                      Scaffold.of(context).showBottomSheet(
                                        (context) => commentsList(context),
                                      );
                                    },
                                  );
                                }),
                            SizedBox(
                              height: 15.0,
                            ),
                            postData.usrData.isLoggedIn
                                ? Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                                color: Color(0xFFCCCCCC),
                                                fontSize: 18.0),
                                            enabledBorder: formBrdr,
                                            focusedBorder: formActiveBrdr,
                                            errorBorder: errBrdr,
                                            focusedErrorBorder: errBrdr,
                                            labelText: 'Comment',
                                            filled: false,
                                          ),
                                          controller: comntCtrl,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          validator: (String val) {
                                            if (val.isEmpty) {
                                              return "Please you must provide content";
                                            }
                                          },
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0),
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            if (formKey.currentState
                                                .validate()) {
                                              formKey.currentState.save();
                                              Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Submitting your comment"),
                                                  action: SnackBarAction(
                                                    label: "OK",
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              );
                                              postData
                                                  .addComment(comntCtrl.text)
                                                  .then((val) {
                                                if (val) {
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .accentColor,
                                                      content: Text(
                                                        "Comment was successfully submitted",
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          Color(0xFF9B0D54),
                                                      content: Text(
                                                        "Comment wasn't successfully submitted, please check that you have internet connection",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }).catchError((err) {
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Color(0xFF9B0D54),
                                                    content: Text(
                                                      "Comment wasn't successfully submitted, please check that you have internet connection",
                                                    ),
                                                  ),
                                                );
                                              });
                                            }
                                          },
                                          color: Color(0xFFE8C11C),
                                          child: Text(
                                            "SUBMIT",
                                            style: TextStyle(
                                                color: Color(0xFF25333D)),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 0.0,
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
                              LineIcons.frown_o,
                              size: 50.0,
                            ),
                            Text(
                              "Oops data fetch failed, check your internet connection",
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
