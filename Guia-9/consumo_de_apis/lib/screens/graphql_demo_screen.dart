import 'package:flutter/material.dart';
import '../services/graphql_service.dart';

class GraphqlDemoScreen extends StatefulWidget {
  const GraphqlDemoScreen({super.key});

  @override
  State<GraphqlDemoScreen> createState() => _GraphqlDemoScreenState();
}

class _GraphqlDemoScreenState extends State<GraphqlDemoScreen> {
  final _service = GraphqlService();
  late Future<List<Map<String, dynamic>>> _countriesFuture;

  @override
  void initState() {
    super.initState();
    _countriesFuture = _service.getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GraphQL - Países'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _countriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final countries = snapshot.data!;
          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return ListTile(
                leading: Text(
                  country['emoji'] ?? '',
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(country['name'] ?? ''),
                subtitle: Text(
                  '${country['capital'] ?? 'Sin capital'} • ${country['continent']?['name'] ?? ''}',
                ),
                trailing: Text(country['code'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}