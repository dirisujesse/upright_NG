import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'app_activity_indicator.dart';

import '../stores/post.dart';

final postBloc = PostBloc.getInstance();

class UprightSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Theme.of(context).platform == TargetPlatform.iOS
          ? Icons.arrow_back_ios
          : Icons.arrow_back),
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
                  Text("Searching records...")
                ],
              ),
            );
          }
          if (postBloc.isFail) {
            return Center(
              child: Text(
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
                    backgroundImage: results[index]["image"].endsWith(".mp4") || results[index]["image"].endsWith(".m4a") ? AssetImage("assets/images/logo.jpg") : NetworkImage(results[index]["image"]),
                    backgroundColor: Colors.teal,
                  ),
                  title: Text(
                    results[index]["title"],
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    results[index]["anonymous"] ? "Anonymous User" : results[index]["author"]["name"],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      // query = "";
                      Navigator.pushNamed(
                        context, '/post/${results[index]["id"]}/${results[index]["title"]}');
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Sorry no result was found that matched your query"),
            );
          } 
          }
        },
      );
    } else {
      return Center(
        child: Text("Enter post title to search"),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Enter post title to search"),
    );
  }
}
