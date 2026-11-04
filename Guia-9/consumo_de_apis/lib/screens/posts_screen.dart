import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';
import 'graphql_demo_screen.dart';
import 'posts_paginated_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late final ApiService _apiService;
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _postsFuture = _apiService.getPosts();
    });
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPosts,
            tooltip: 'Recargar',
          ),
          IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'Demo GraphQL',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GraphqlDemoScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Paginación',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PostsPaginatedScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // Estado: Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado: Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPosts,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Estado: Datos disponibles
          final posts = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _loadPosts(),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${post.id}')),
                    title: Text(
                      post.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );
          if (created == true) _loadPosts();
        },
        tooltip: 'Crear Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}