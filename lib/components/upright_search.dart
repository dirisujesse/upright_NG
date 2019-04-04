import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../stores/post.dart';

final postBloc = PostBloc();

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
      return StateBuilder(
        initState: (state) => postBloc.searchPosts(state, query),
        builder: (_) {
          if (postBloc.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Theme.of(context).platform == TargetPlatform.iOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
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
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(results[index]["avatar"]),
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
                    onPressed: () => Navigator.pushNamed(
                        context, '/post/$index/${results[index]["title"]}'),
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
