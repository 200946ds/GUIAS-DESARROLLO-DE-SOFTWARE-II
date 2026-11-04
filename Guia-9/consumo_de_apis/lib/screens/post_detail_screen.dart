import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../services/api_service.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  final ApiService _apiService = ApiService();

  PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post #${post.id}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              post.body,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 40),
            Text(
              'Comentarios',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Comment>>(
              future: _apiService.getCommentsByPost(post.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error cargando comentarios: ${snapshot.error}');
                }

                final comments = snapshot.data!;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      title: Text(
                        comment.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.email,
                            style: const TextStyle(color: Colors.blue),
                          ),
                          const SizedBox(height: 4),
                          Text(comment.body),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}