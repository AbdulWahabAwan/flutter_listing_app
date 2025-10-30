class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  // Local UI fields (not from API)
  int likes;
  bool liked;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.likes = 0,
    this.liked = false,
  });

  /// Create Post from JSON (safe parsing)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: (json['userId'] is int) ? json['userId'] as int : int.tryParse('${json['userId']}') ?? 0,
      id: (json['id'] is int) ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      // If API returns a likes field (unlikely on jsonplaceholder) parse it; otherwise default 0
      likes: (json['likes'] is int) ? json['likes'] as int : int.tryParse('${json['likes']}') ?? 0,
      liked: (json['liked'] is bool) ? json['liked'] as bool : false,
    );
  }

  /// Convert to JSON (useful if you post to an API)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
      'likes': likes,
      'liked': liked,
    };
  }

  /// Utility to clone/update
  Post copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    int? likes,
    bool? liked,
  }) {
    return Post(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
    );
  }
}
