import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

const url =
    "https://www.uprightapi.cloud"; //"https://reportapp-dirisu.herokuapp.com"

class HttpService {
  static Future<dynamic> login(String username) async {
    try {
      var req = await http.get(
        "$url/user/login/?username=$username",
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> getUser(String id) async {
    try {
      var req = await http.get(
        "$url/user/login/?id=$id",
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> getTopUsers() async {
    try {
      var req = await http.get(
        "$url/user/getTopUsers",
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> signup(String username, String name) async {
    try {
      var req = await http.post(
          "$url/user/signup/?username=$username&name=$name",
          headers: {"Content-Type": "application/json"});
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> getPosts() async {
    try {
      var req = await http.get(
        "$url/post?featured=false&limit=50&sort=createdAt%20DESC",
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> getRecPosts() async {
    final int time = DateTime.now().millisecondsSinceEpoch;
    try {
      var req = await http.get(
        "$url/post/getrecposts/?time=$time",
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> getTrendingPosts() async {
    try {
      var req = await http.get(
        "$url/post/getTrendingPosts",
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> getFeaturedPosts() async {
    try {
      var req = await http.get(
        "$url/post/getFeaturedPosts",
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> getPost(String id) async {
    try {
      var req = await http.get(
        "$url/post/getpost/?id=$id",
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> searchPost(String title) async {
    try {
      var req = await http.get(
        '$url/post/?where={"title": {"contains": "$title"}}&sort=upvotes%20DESC&limit=10',
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> addPost(Map<String, dynamic> post) async {
    try {
      var req = await http.post(
        '$url/post/createpost',
        headers: {"Content-Type": "application/json"},
        body: post,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> addSuggestion(Map<String, dynamic> body) async {
    try {
      var req = await http.post(
        '$url/suggestions',
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> upVote(bool isPost, String id,
      [String sort = 'upvote']) async {
    final endPoint = isPost ? "post" : "comment";
    try {
      var req = await http.put(
        '$url/$endPoint/$sort/?id=$id',
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> addComment(Map<String, dynamic> body) async {
    try {
      var req = await http.post(
        '$url/comments/addcomment',
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> getComments(String postId) async {
    try {
      var req = await http.get(
        '$url/comments/getcomments/?post=$postId',
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> getStats(String id) async {
    try {
      var req = await http.get(
        '$url/user/getuserstat/?id=$id',
        headers: {"Content-Type": "application/json"},
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }

  static Future<dynamic> updateProfile(Map<String, dynamic> body) async {
    try {
      var req = await http.put(
        '$url/user/updateprofile',
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = json.decode(req.body);
      return res;
    } catch (e) {
      print(e);
      return 404;
    }
  }
}
