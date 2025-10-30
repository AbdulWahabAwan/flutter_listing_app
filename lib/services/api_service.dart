import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../models/comment_model.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetch all posts from the API
  Future<List<Post>> fetchPosts() async {
    try {
      final uri = Uri.parse('$_baseUrl/posts');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((e) => Post.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  /// Fetch comments for a specific post
  Future<List<CommentModel>> fetchCommentsForPost(int postId) async {
    try {
      final uri = Uri.parse('$_baseUrl/comments?postId=$postId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((e) => CommentModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  /// Simulate adding a new post (for demo/local only)
  /// Note: JSONPlaceholder will not actually create a new post on the server.
  Future<Post> createPost(String title, String body) async {
    try {
      final uri = Uri.parse('$_baseUrl/posts');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating post: $e');
    }
  }

  /// Simulate adding a comment (for demo/local only)
  /// Note: This won't persist on JSONPlaceholder — use locally via Provider.
  Future<CommentModel> createComment(int postId, String body) async {
    try {
      final uri = Uri.parse('$_baseUrl/comments');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'postId': postId,
          'name': 'You',
          'email': 'you@mail.com',
          'body': body,
        }),
      );

      if (response.statusCode == 201) {
        return CommentModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating comment: $e');
    }
  }
}
