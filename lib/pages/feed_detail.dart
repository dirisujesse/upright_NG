import 'package:Upright_NG/components/parsed_text.dart';
import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:simple_share/simple_share.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../stores/post.dart';
import '../models/post.dart';
import '../styles/form_style.dart';
import '../components/video_player.dart';
import '../components/app_activity_indicator.dart';

final postData = PostBloc.getInstance();

class FeedPage extends StatefulWidget {
  final String title;
  final String id;
  final Post post;

  FeedPage({
    @required this.title,
    @required this.id,
    @required this.post,
  });
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
    postData.post = widget.post;
  }

  @override
  void dispose() {
    postData.disposeFeed();
    super.dispose();
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhite,
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          child: Icon(Icons.forum),
          onPressed: () {
            postData.loadComments(widget.post.id);
            Scaffold.of(context).showBottomSheet(
              (context) => CommentsList(),
            );
          },
          // label: AutoSizeText("View Comments"),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          color: Color(0xFF318700),
          padding: EdgeInsets.all(0),
          child: Table(
            children: [
              TableRow(
                children: [
                  GestureDetector(
                    onTap: () {
                      postData.vote();
                    },
                    child: Container(
                      color: Color(0xFF3B5998),
                      height: 60.0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            StateBuilder(
                              blocs: [postData],
                              stateID: "postDetState",
                              builder: (_) {
                                return AutoSizeText(
                                  postData.post.upvotes.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xFFC536A4),
                    height: 60.0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.forum,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          StateBuilder(
                            blocs: [postData],
                            stateID: "postComState",
                            builder: (_) {
                              return AutoSizeText(
                                postData.comments != null
                                    ? postData.comments.length.toString()
                                    : widget.post.comments != null
                                        ? widget.post.comments.length.toString()
                                        : "0",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      color: Color(0xFF1DA1F2),
                      height: 60.0,
                      child: Center(
                        child: Icon(
                          LineIcons.twitter,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    onTap: () => launch(
                        "https://twitter.com/intent/tweet?text=${widget.post.body}"),
                  ),
                  GestureDetector(
                    child: Container(
                      color: Color(0xFF39B34A),
                      height: 60.0,
                      child: Center(
                        child: Icon(
                          LineIcons.whatsapp,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    onTap: () =>
                        launch("whatsapp://send?text=${widget.post.body}"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return [
                SliverAppBar(
                  leading: BackButton(
                      // color: Colors.black,
                      ),
                  pinned: true,
                  elevation: 0,
                  expandedHeight: MediaQuery.of(context).size.height * 0.35,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.share,
                      ),
                      // color: Colors.black,
                      onPressed: () {
                        SimpleShare.share(
                          msg: widget.post.body,
                          title: widget.title,
                          subject: widget.post.image,
                        );
                      },
                    ),
                  ],
                  flexibleSpace: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: FlexibleSpaceBar(
                          background: Container(
                            color: appAsh,
                            child: AspectRatio(
                              aspectRatio: 100.0 / 80.0,
                              child: Hero(
                                tag: widget.id,
                                child: widget.post.image.endsWith(".m4a") ||
                                        widget.post.image.endsWith(".mp4")
                                    ? Image.asset(
                                        "assets/images/logo.jpg",
                                        color: Color.fromRGBO(0, 0, 0, 0.7),
                                        colorBlendMode: BlendMode.darken,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        widget.post.image,
                                        color: Color.fromRGBO(0, 0, 0, 0.7),
                                        colorBlendMode: BlendMode.darken,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          color: appGreen,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 10.0,
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 30,
                        child: Container(
                          child: AutoSizeText(
                            widget.post.title
                                .replaceAll(new RegExp(r"\s{2,}"), " ")
                                .trim(),
                            style:
                                Theme.of(context).textTheme.headline.copyWith(
                                      fontSize: 25.0,
                                      color: appWhite,
                                    ),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ];
            },
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: appBlack,
                          backgroundImage: widget.post.anonymous
                              ? null
                              : NetworkImage(
                                  widget.post.author.avatar,
                                ),
                          radius: 30,
                        ),
                        title: AutoSizeText(
                          widget.post.anonymous
                              ? "Anonymous"
                              : widget.post.author.name,
                          style: Theme.of(context).textTheme.title.copyWith(
                                fontSize: 22.0,
                              ),
                        ),
                        subtitle: AutoSizeText(
                          widget.post.time,
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: widget.post.image.endsWith(".m4a") ||
                              widget.post.image.endsWith(".mp4")
                          ? Padding(
                              child: VideoWidget(
                                url: widget.post.image,
                              ),
                              padding: EdgeInsets.only(
                                bottom: 20.0,
                              ),
                            )
                          : null,
                    ),
                    UprightParsedText(
                      text: widget.post.body,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    postData.usrData.isLoggedIn
                        ? Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  color: appGreen,
                                  height: 5.0,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  decoration: formInputStyle.copyWith(
                                    hintText: 'Comment',
                                    prefixIcon: Icon(
                                      Icons.forum,
                                      color: appGreen,
                                    ),
                                  ),
                                  controller: comntCtrl,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  validator: (String val) {
                                    if (val.isEmpty) {
                                      return "Please you must provide content";
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: appGreen,
                                          content: AutoSizeText(
                                              "Submitting your comment"),
                                        ),
                                      );
                                      postData
                                          .addComment(comntCtrl.text)
                                          .then((val) {
                                        if (val) {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: appGreen,
                                              content: AutoSizeText(
                                                "Comment was successfully submitted",
                                              ),
                                            ),
                                          );
                                          comntCtrl.clear();
                                        } else {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  Color(0xFF9B0D54),
                                              content: AutoSizeText(
                                                "Comment wasn't successfully submitted, please check that you have internet connection",
                                              ),
                                            ),
                                          );
                                        }
                                      }).catchError((err) {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Color(0xFF9B0D54),
                                            content: AutoSizeText(
                                              "Comment wasn't successfully submitted, please check that you have internet connection",
                                            ),
                                          ),
                                        );
                                      });
                                    }
                                  },
                                  child: AutoSizeText(
                                    "Add Comment",
                                    style: TextStyle(
                                      color: appWhite,
                                    ),
                                  ),
                                  // padding: EdgeInsets.symmetric(vertical: 10.0),
                                )
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 0.0,
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.constrainWidth();
        final tall = constraints.constrainHeight();
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          height: tall * 0.83,
          width: wide,
          constraints: BoxConstraints(maxHeight: tall * 0.83),
          decoration: BoxDecoration(
            color: formInputGreen,
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
                    child: const AppSpinner(),
                  );
                } else {
                  final comments = postData.comments;
                  if (comments.length > 0) {
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, idx) {
                        return Container(
                          constraints: BoxConstraints(
                            maxWidth: wide * 0.9,
                          ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.teal,
                                backgroundImage: NetworkImage(
                                  comments[idx]["author"]["avatar"],
                                ),
                                radius: 34.0,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(
                                    comments[idx]["author"]["name"],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  AutoSizeText(
                                    comments[idx]["time"],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  AutoSizeText(
                                    comments[idx]["body"],
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: AutoSizeText(
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
      },
    );
  }
}
