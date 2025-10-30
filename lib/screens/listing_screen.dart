import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../models/post_model.dart';
import 'add_post_screen.dart'; // 👈 You’ll create this next (for adding threads)

class ListingScreen extends StatefulWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  int _selectedIndex = 0;

  String excerpt(String body) {
    final trimmed = body.replaceAll('\n', ' ');
    if (trimmed.length > 120) return '${trimmed.substring(0, 120)}...';
    return trimmed;
  }

  String avatarForIndex(int index) {
    final idx = (index % 6) + 1;
    return 'https://i.pravatar.cc/150?img=$idx';
  }

  String fakeTimeFromId(int id) {
    final days = (id % 4) + 1;
    return '${days}d';
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    // 👇 Handle navigation actions
    switch (index) {
      case 0: // Home
      // Already on ListingScreen
        break;
      case 1: // Search
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Search feature coming soon!')),
        );
        break;
      case 2: // Add Thread
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPostScreen()),
        );
        break;
      case 3: // Favorites
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorites feature coming soon!')),
        );
        break;
      case 4: // Profile
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile feature coming soon!')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Threads',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddPostScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: provider.loading
            ? const Center(child: CircularProgressIndicator())
            : provider.error != null
            ? Center(child: Text('Error: ${provider.error}'))
            : ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: provider.posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 18),
          itemBuilder: (context, index) {
            final post = provider.posts[index];
            return InkWell(
              onTap: () => Navigator.pushNamed(context, '/detail', arguments: post),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(avatarForIndex(index)),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' ${post.title[0].toUpperCase()}${post.title.substring(1)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          excerpt(post.body),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey.shade700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fakeTimeFromId(post.id),
                          style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
