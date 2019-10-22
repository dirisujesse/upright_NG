import 'dart:convert';
import 'dart:async';

import 'package:Upright_NG/models/order.dart';
import 'package:dio/dio.dart'; // "https://www.uprightapi.cloud";

final http = Dio(
  BaseOptions(
    connectTimeout: 1000 * 20,
    receiveTimeout: 1000 * 20,
    baseUrl: "http://uprightapi.cloud",
  ),
);

var cancelToken = CancelToken();

void cancelReqs() {
  cancelToken.cancel();
  cancelToken = CancelToken();
}

class HttpService {
  static Future<dynamic> login(String username, String password) async {
    try {
      var req = await http.get(
        "/user/login/?username=$username&password=$password",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getUser(String id) async {
    try {
      var req = await http.get(
        "/user/login/?id=$id",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getTopUsers() async {
    try {
      var req = await http.get(
        "/user/getTopUsers",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> signup(String username, String name, String password, bool isMember) async {
    try {
      var req = await http.post(
        "/user/signup/?username=$username&name=$name&password=$password&isMember=$isMember",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getPosts() async {
    try {
      var req = await http.get(
        "/post?featured=false&limit=50&sort=createdAt%20DESC&populate=author",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getPostRange(int skip, int limit) async {
    try {
      var req = await http.get(
        "/post?featured=false&skip=$skip&limit=$limit&sort=createdAt%20DESC&populate=author",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getRecPosts() async {
    final int time = DateTime.now().millisecondsSinceEpoch;
    try {
      var req = await http.get(
        "/post/getrecposts/?time=$time",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getTrendingPosts() async {
    try {
      var req = await http.get(
        "/post/getTrendingPosts",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getFeaturedPosts() async {
    try {
      var req = await http.get(
        "/post/getFeaturedPosts",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getPost(String id) async {
    try {
      var req = await http.get(
        "/post/getpost/?id=$id",
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> searchPost(String title) async {
    try {
      var req = await http.get(
        '/post/?where={"title": {"contains": "$title"}}&sort=upvotes%20DESC&limit=10&populate=author',
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> addPost(Map<String, dynamic> post) async {
    try {
      var req = await http.post(
        '/post/createPost',
        data: json.encode(post),
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> addSuggestion(Map<String, dynamic> body) async {
    try {
      var req = await http.post(
        '/suggestions',
        cancelToken: cancelToken,
        data: json.encode(body),
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> upVote(bool isPost, String id,
      [String sort = 'upvote']) async {
    final endPoint = isPost ? "post" : "comment";
    try {
      var req = await http.put(
        '/$endPoint/$sort/?id=$id',
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> addComment(Map<String, dynamic> body) async {
    try {
      var req = await http.post(
        '/comments/addcomment',
        cancelToken: cancelToken,
        data: json.encode(body),
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getComments(String postId) async {
    try {
      var req = await http.get(
        '/comments/getcomments/?post=$postId',
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getProducts() async {
    try {
      var req = await http.get(
        '/product',
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data as List<dynamic>;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getGifts(String id) async {
    try {
      var req = await http.get(
        '/order?purchaser=$id&populate=purchaser,product',
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getTestimonials({int skip = 0, int limit = 20}) async {
    try {
      var req = await http.get(
        '/testimonial?skip=$skip&limit=$limit&populate=author&sort=createdAt%20DESC',
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> addTestimonial(Map<String, dynamic> testimonial) async {
    try {
      var req = await http.post(
        '/testimonial/createTestimonial',
        data: json.encode(testimonial),
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> pledge(String id) async {
    try {
      var req = await http.post(
        '/pledge',
        cancelToken: cancelToken,
        data: json.encode({"by": id})
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> makeOrder(Order order) async {
    try {
      var req = await http.post(
        '/order',
        cancelToken: cancelToken,
        data: json.encode(order.toJson())
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> getStats(String id) async {
    try {
      var req = await http.get(
        '/user/getuserstat/?id=$id',
        cancelToken: cancelToken,
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res;
    } catch (e) {
      return 404;
    }
  }

  static Future<dynamic> updateProfile(Map<String, dynamic> body, String id) async {
    try {
      var req = await http.put(
        '/user/updateprofile/?id=$id',
        cancelToken: cancelToken,
        data: json.encode(body),
      );
      if (req.statusCode > 201) {
        throw req.statusCode;
      }
      var res = req.data;
      return res is List<dynamic> ? res[0] : res;
    } catch (e) {
      return 404;
    }
  }
}
