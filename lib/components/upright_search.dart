import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'app_activity_indicator.dart';

import '../stores/post.dart';
import 'package:auto_size_text/auto_size_text.dart';

final postBloc = PostBloc.getInstance();

class UprightSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          primaryColor: appGreen,
          inputDecorationTheme: InputDecorationTheme(
            filled: false,
            fillColor: appWhite,
            focusColor: appWhite,
            hintStyle: TextStyle(
              color: appWhite,
              fontFamily: "OpenSans",
            ),
            contentPadding: EdgeInsets.all(0),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: appWhite, width: 2)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: appWhite, width: 3)),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: appRed, width: 3)),
          ),
        );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: appWhite,
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      color: appWhite,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length > 0) {
      Future.delayed(Duration(milliseconds: 50), postBloc.searchPosts(query));
      return StateBuilder(
        stateID: "postSearchState",
        blocs: [postBloc],
        builder: (_) {
          if (postBloc.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const AppSpinner(),
                  AutoSizeText("Searching records...")
                ],
              ),
            );
          }
          if (postBloc.isFail) {
            return Center(
              child: AutoSizeText(
                  "Sorry search failed you may have lost internet connection"),
            );
          }
          if (!(postBloc.isLoading && postBloc.isFail)) {
            if (postBloc.results.length > 0) {
              final results = postBloc.results;
              return ListView.builder(
                itemCount: results.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          results[index]["image"].endsWith(".mp4") ||
                                  results[index]["image"].endsWith(".m4a")
                              ? AssetImage("assets/images/Logomin.jpg")
                              : results[index]["image"].endsWith("Logo.jpg")
                                  ? AssetImage(
                                      "assets/images/Logomin.jpg",
                                    )
                                  : NetworkImage(results[index]["image"]),
                      backgroundColor: Colors.teal,
                    ),
                    title: AutoSizeText(
                      results[index]["title"],
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: AutoSizeText(
                      results[index]["anonymous"]
                          ? "Anonymous User"
                          : results[index]["author"]["name"],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        // query = "";
                        Navigator.pushNamed(context,
                            '/post/${results[index]["id"]}/${results[index]["title"]}',
                            arguments: results[index]);
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: AutoSizeText(
                    "Sorry no result was found that matched your query"),
              );
            }
          }
        },
      );
    } else {
      return Center(
        child: AutoSizeText("Enter post title to search"),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: AutoSizeText("Enter post title to search"),
    );
  }
}
