import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/reddit_post_model.dart';
import '../../data/services/reddit_service.dart';
import 'reddit_post_detail_page.dart';

class ExplorePageReddit extends StatefulWidget {
  const ExplorePageReddit({super.key});

  @override
  State<ExplorePageReddit> createState() => _ExplorePageRedditState();
}

class _ExplorePageRedditState extends State<ExplorePageReddit> {
  final RedditService _service = RedditService();
  List<RedditPost> _posts = [];
  bool _isLoading = true;
  String? _error;
  int _selectedCategory = 0;

  final _categories = [
    {'label': 'All', 'icon': Icons.grid_view_rounded, 'color': const Color(0xFF5D5B8C)},
    {'label': 'Mental Health', 'icon': Icons.favorite_rounded, 'color': const Color(0xFF8DBDBA)},
    {'label': 'Exam Stress', 'icon': Icons.psychology_rounded, 'color': const Color(0xFFE65C62)},
    {'label': 'Study Tips', 'icon': Icons.menu_book_rounded, 'color': const Color(0xFFA5C860)},
    {'label': 'Engineering', 'icon': Icons.engineering_rounded, 'color': const Color(0xFFEBC137)},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final label = _categories[_selectedCategory]['label'] as String;
      final posts = label == 'All'
          ? await _service.fetchAllPosts()
          : await _service.fetchByCategory(label);
      if (mounted) setState(() { _posts = posts; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            expandedHeight: 0,
            title: Row(
              children: [
                Text(
                  'Explore',
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4500).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.reddit, color: Color(0xFFFF4500), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Reddit',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFFF4500),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Color(0xFF5D5B8C)),
                onPressed: _load,
                tooltip: 'Refresh',
              ),
              const SizedBox(width: 4),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: _buildCategoryBar(),
            ),
          ),
        ],
        body: _buildBody(),
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final selected = index == _selectedCategory;
          return GestureDetector(
            onTap: () {
              if (_selectedCategory != index) {
                setState(() => _selectedCategory = index);
                _load();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? (cat['color'] as Color)
                    : (cat['color'] as Color).withOpacity(0.08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    color: selected ? Colors.white : (cat['color'] as Color),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['label'] as String,
                    style: GoogleFonts.outfit(
                      color: selected ? Colors.white : (cat['color'] as Color),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        itemCount: 6,
        itemBuilder: (_, i) => _buildSkeletonCard(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Could not load posts',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check your internet connection',
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              label: Text('Try Again', style: GoogleFonts.outfit()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D5B8C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No posts found',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: const Color(0xFFFF4500),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(_posts[index]);
        },
      ),
    );
  }

  Widget _buildPostCard(RedditPost post) {
    final subColor = _getSubredditColor(post.subreddit);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RedditPostDetailPage(post: post)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail if valid
            if (post.thumbnail != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  post.thumbnail!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subreddit + time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: subColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.reddit, color: subColor, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'r/${post.subreddit}',
                              style: GoogleFonts.outfit(
                                color: subColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        post.timeAgo,
                        style: GoogleFonts.outfit(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Title
                  Text(
                    post.title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.35,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Snippet
                  if (post.selftext.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      post.selftext,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Stats + author
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: subColor.withOpacity(0.2),
                        child: Text(
                          post.author[0].toUpperCase(),
                          style: TextStyle(color: subColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'u/${post.author}',
                        style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 12),
                      ),
                      const Spacer(),
                      _buildStat(Icons.arrow_upward_rounded, '${post.score}', const Color(0xFFFF4500)),
                      const SizedBox(width: 12),
                      _buildStat(Icons.chat_bubble_outline_rounded, '${post.numComments}', Colors.blueGrey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 3),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(80, 28, radius: 20),
          const SizedBox(height: 12),
          _shimmerBox(double.infinity, 16),
          const SizedBox(height: 8),
          _shimmerBox(double.infinity * 0.7, 14),
          const SizedBox(height: 16),
          _shimmerBox(120, 12),
        ],
      ),
    );
  }

  Widget _shimmerBox(double width, double height, {double radius = 8}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Color _getSubredditColor(String subreddit) {
    switch (subreddit.toLowerCase()) {
      case 'mentalhealth':
        return const Color(0xFF8DBDBA);
      case 'engineeringstudents':
        return const Color(0xFF5D5B8C);
      default:
        return const Color(0xFFFF4500);
    }
  }
}
