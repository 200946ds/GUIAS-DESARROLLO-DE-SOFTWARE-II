import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';

class PostsPaginatedScreen extends StatefulWidget {
  const PostsPaginatedScreen({super.key});

  @override
  State<PostsPaginatedScreen> createState() => _PostsPaginatedScreenState();
}

class _PostsPaginatedScreenState extends State<PostsPaginatedScreen> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  final List<Post> _posts = [];
  int _currentPage = 1;
  final int _limit = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _apiService.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newPosts = await _apiService.getPostsPaginated(
        page: _currentPage,
        limit: _limit,
      );

      setState(() {
        _posts.addAll(newPosts);
        _currentPage++;
        _hasMore = newPosts.length == _limit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _posts.clear();
      _currentPage = 1;
      _hasMore = true;
      _error = null;
    });
    await _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts (Paginación)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _error != null && _posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $_error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _posts.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  // Indicador de carga al final
                  if (index == _posts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final post = _posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${post.id}')),
                      title: Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        post.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostDetailScreen(post: post),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}