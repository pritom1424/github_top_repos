import 'package:github_top_repos/core/api/github_api.dart';

import '../models/github_repository.dart';

class RepoRemoteService {
  final GitHubApi _api;

  RepoRemoteService(this._api);

  Future<List<GitHubRepository>> fetchRepositories({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _api.searchFlutterRepositories(
      page: page,
      perPage: perPage,
    );

    final items = response.data['items'] as List;

    return items
        .map((json) => GitHubRepository.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
