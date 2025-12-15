import 'package:dio/dio.dart';
import 'package:github_top_repos/core/constants/api_urls.dart';

class GitHubApi {
  final Dio _dio;

  GitHubApi({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiUrls.baseApiUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  Future<Response> searchFlutterRepositories({
    int page = 1,
    int perPage = 20,
  }) async {
    return _dio.get(
      '/search/repositories',
      queryParameters: {
        'q': 'Flutter',
        'sort': 'stars',
        'order': 'desc',
        'page': page,
        'per_page': perPage,
      },
    );
  }
}
