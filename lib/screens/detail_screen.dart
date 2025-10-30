// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../providers/post_provider.dart';
import '../models/comment_model.dart';

class DetailScreen extends StatefulWidget {
  final Post post;
  const DetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final commentCtrl = TextEditingController();
  late Future<List<CommentModel>> _commentsFuture;

  String avatar(int id) => 'https://i.pravatar.cc/150?img=${(id % 6) + 1}';

  @override
  void initState() {
    super.initState();
    _commentsFuture = Provider.of<PostProvider>(context, listen: false).loadComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);
    final post = widget.post;

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(radius: 28, backgroundImage: NetworkImage(avatar(post.userId))),
              const SizedBox(width: 12),
              Expanded(
                child: Text(post.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ),
              IconButton(
                icon: Icon(post.liked ? Icons.favorite : Icons.favorite_border,
                    color: post.liked ? Colors.red : Colors.grey),
                onPressed: () => provider.toggleLike(post),
              ),
              Text('${post.likes}'),
            ]),
            const SizedBox(height: 10),
            Text(post.body, style: const TextStyle(fontSize: 16, height: 1.5)),
            const Divider(height: 30),
            const Text('Comments', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            FutureBuilder<List<CommentModel>>(
              future: _commentsFuture,
              builder: (context, snap) {
                final comments = snap.data ?? [];
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, i) {
                    final c = comments[i];
                    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatar(c.id))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(c.body),
                          Row(children: [
                            IconButton(
                              onPressed: () => provider.toggleCommentLike(post.id, c),
                              icon: Icon(c.liked ? Icons.favorite : Icons.favorite_border,
                                  color: c.liked ? Colors.red : Colors.grey, size: 18),
                            ),
                            Text('${c.likes}'),
                          ])
                        ]),
                      )
                    ]);
                  },
                );
              },
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(children: [
          CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatar(1))),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: commentCtrl,
              decoration: const InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (commentCtrl.text.isNotEmpty) {
                provider.addComment(post.id, commentCtrl.text);
                commentCtrl.clear();
              }
            },
          )
        ]),
      ),
    );
  }
}
