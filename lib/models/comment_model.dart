class CommentModel {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  // Local UI fields
  int likes;
  bool liked;

  CommentModel({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
    this.likes = 0,
    this.liked = false,
  });

  /// Create CommentModel from JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      postId: (json['postId'] is int) ? json['postId'] as int : int.tryParse('${json['postId']}') ?? 0,
      id: (json['id'] is int) ? json['id'] as int : int.tryParse('${json['id']}') ?? DateTime.now().millisecondsSinceEpoch,
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      likes: (json['likes'] is int) ? json['likes'] as int : int.tryParse('${json['likes']}') ?? 0,
      liked: (json['liked'] is bool) ? json['liked'] as bool : false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
      'likes': likes,
      'liked': liked,
    };
  }

  CommentModel copyWith({
    int? postId,
    int? id,
    String? name,
    String? email,
    String? body,
    int? likes,
    bool? liked,
  }) {
    return CommentModel(
      postId: postId ?? this.postId,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      body: body ?? this.body,
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
    );
  }
}
