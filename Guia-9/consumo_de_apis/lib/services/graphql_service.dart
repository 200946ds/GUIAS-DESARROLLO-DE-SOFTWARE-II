import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlService {
  static final HttpLink _httpLink = HttpLink(
    'https://countries.trevorblades.com/',
  );

  static final GraphQLClient client = GraphQLClient(
    link: _httpLink,
    cache: GraphQLCache(),
  );

  // Consulta: obtener lista de países
  static const String getCountriesQuery = r'''
    query {
      countries {
        code
        name
        capital
        emoji
        continent {
          name
        }
      }
    }
  ''';

  // Consulta: obtener un país por código
  static const String getCountryByCodeQuery = r'''
    query GetCountry($code: ID!) {
      country(code: $code) {
        code
        name
        capital
        emoji
        currency
        phone
        continent {
          name
        }
        languages {
          name
        }
      }
    }
  ''';

  Future<List<Map<String, dynamic>>> getCountries() async {
    final result = await client.query(
      QueryOptions(document: gql(getCountriesQuery)),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List countries = result.data?['countries'] ?? [];
    return countries.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getCountryByCode(String code) async {
    final result = await client.query(
      QueryOptions(
        document: gql(getCountryByCodeQuery),
        variables: {'code': code},
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data?['country'];
  }
}