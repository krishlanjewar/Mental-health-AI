import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpme/features/community/data/services/community_service.dart';
import 'dart:math';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final CommunityService _communityService = CommunityService();
  final TextEditingController _postController = TextEditingController();
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  final List<String> _animalNames = [
    'Koala',
    'Badger',
    'Heron',
    'Fox',
    'Owl',
    'Panda',
    'Tiger',
    'Rabbit',
    'Deer',
    'Otter',
  ];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() => _isLoading = true);
    try {
      final posts = await _communityService.getPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _getAnonymousName(String userId) {
    // Generate a consistent pseudo-random name based on userId
    final random = Random(userId.hashCode);
    final name = _animalNames[random.nextInt(_animalNames.length)];
    return 'Anonymous $name';
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Share Anonymously',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _postController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText:
                      "What's on your mind? Don't worry, nobody will know it's you...",
                  hintStyle: GoogleFonts.outfit(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: GoogleFonts.outfit(fontSize: 16),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8DBDBA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Post to Community',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _submitPost() async {
    final content = _postController.text.trim();
    if (content.isEmpty) return;

    Navigator.pop(context);
    try {
      await _communityService.createPost(content);
      _postController.clear();
      _fetchPosts();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to post: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Community Support',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showCreatePostDialog,
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF8DBDBA),
              size: 32,
            ),
          ),
          const SizedBox(width: 10),
        ],
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchPosts,
              color: const Color(0xFF8DBDBA),
              child: _posts.isEmpty
                  ? Center(
                      child: Text(
                        'Be the first to share something!',
                        style: GoogleFonts.outfit(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        return _buildPostCard(
                          _getAnonymousName(post['user_id']),
                          post['content'],
                          post['id'],
                          post['support_count'] ?? 0,
                        );
                      },
                    ),
            ),
    );
  }

  Widget _buildPostCard(
    String username,
    String content,
    String postId,
    int supportCount,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  username,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8DBDBA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.withOpacity(0.1)),
          Row(
            children: [
              _buildActionButton(
                Icons.favorite,
                '$supportCount Support',
                () async {
                  await _communityService.giveSupport(postId);
                  _fetchPosts();
                },
                color: Colors.pink[300],
              ),
              const SizedBox(width: 20),
              _buildActionButton(Icons.chat_bubble_outline, 'Reply', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[600]),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: color ?? Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
