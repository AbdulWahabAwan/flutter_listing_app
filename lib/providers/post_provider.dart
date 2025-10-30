// lib/providers/post_provider.dart
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class PostProvider with ChangeNotifier {
  List<Post> posts = [];
  bool loading = false;
  String? error;

  /// 🟦 Load initial fake posts
  Future<void> loadPosts() async {
    loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    posts = List.generate(
      10,
          (i) => Post(
        userId: i + 1,
        id: i + 1,
        title: 'Sample thread ${i + 1}',
        body: 'This is a sample thread body number ${i + 1}.',
        likes: 0,
      ),
    );

    loading = false;
    notifyListeners();
  }

  /// ❤️ Toggle like on a post
  void toggleLike(Post post) {
    post.liked = !post.liked;
    post.likes += post.liked ? 1 : -1;
    notifyListeners();
  }

  /// ➕ Add a new post (from form or locally)
  void addPost(String title, String body) {
    final id = posts.isNotEmpty ? posts.first.id + 1 : 1;
    posts.insert(
      0,
      Post(
        userId: 1,
        id: id,
        title: title,
        body: body,
        likes: 0,
      ),
    );
    notifyListeners();
  }

  /// 🟢 Add post object directly (for AddPostScreen)
  void addLocalPost(Post post) {
    posts.insert(0, post); // ✅ Fixed line
    notifyListeners();
  }

  /// 💬 Comments storage
  final Map<int, List<CommentModel>> _comments = {};

  Future<List<CommentModel>> loadComments(int postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _comments[postId] ?? [];
  }

  /// ➕ Add a new comment
  void addComment(int postId, String text) {
    final newComment = CommentModel(
      postId: postId,
      id: DateTime.now().millisecondsSinceEpoch,
      name: 'You',
      email: 'you@mail.com',
      body: text,
      likes: 0,
    );

    _comments.putIfAbsent(postId, () => []).insert(0, newComment);
    notifyListeners();
  }

  /// ❤️ Toggle like on a comment
  void toggleCommentLike(int postId, CommentModel comment) {
    comment.liked = !comment.liked;
    comment.likes += comment.liked ? 1 : -1;
    notifyListeners();
  }
}
