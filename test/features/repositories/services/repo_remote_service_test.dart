import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:github_top_repos/features/repositories/services/repo_remote_service.dart';
import 'package:github_top_repos/core/api/github_api.dart';
import 'package:github_top_repos/features/repositories/models/github_repository.dart';

class MockGitHubApi extends Mock implements GitHubApi {}

void main() {
  late MockGitHubApi mockApi;
  late RepoRemoteService service;

  final repoJson = {
    'id': 1,
    'name': 'flutter_repo',
    'owner': {'login': 'owner', 'avatar_url': 'https://avatar.url'},
    'description': 'A test repo',
    'stargazers_count': 100,
    'updated_at': DateTime.now().toIso8601String(),
    'html_url': 'https://github.com/test/repo',
  };

  setUp(() {
    mockApi = MockGitHubApi();
    service = RepoRemoteService(mockApi);
  });

  test('fetchRepositories returns list of GitHubRepository', () async {
    when(() => mockApi.searchFlutterRepositories()).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          'items': [repoJson],
        },
        statusCode: 200,
      ),
    );

    final repos = await service.fetchRepositories();

    expect(repos, isA<List<GitHubRepository>>());
    expect(repos.first.name, 'flutter_repo');
  });
}
