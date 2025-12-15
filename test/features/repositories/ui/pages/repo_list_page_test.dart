import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_top_repos/features/repositories/ui/pages/repo_list_page.dart';
import 'package:github_top_repos/features/repositories/controllers/repo_controller.dart';
import 'package:github_top_repos/features/repositories/models/github_repository.dart';

// Fake controller that immediately returns test data
class FakeRepoController extends RepoController {
  final List<GitHubRepository> testData;

  FakeRepoController(this.testData);

  @override
  Future<List<GitHubRepository>> build() async {
    return testData;
  }
}

void main() {
  final testRepo = GitHubRepository(
    id: 0,
    name: 'flutter_repo',
    ownerName: 'owner',
    ownerAvatarUrl: 'https://avatar.url',
    description: 'A test repo',
    stars: 100,
    updatedAt: DateTime.now(),
    repoUrl: 'https://github.com/test/repo',
  );

  testWidgets('RepoListPage loads correctly', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repoControllerProvider.overrideWith(
            () => FakeRepoController([testRepo]),
          ),
        ],
        child: MaterialApp(home: RepoListPage()),
      ),
    );

    await tester.pump(); // Just pump once, don't use pumpAndSettle()

    expect(find.text('flutter_repo'), findsOneWidget);
    expect(find.text('A test repo'), findsOneWidget);
    expect(find.text('⭐ 100'), findsOneWidget);
  });
}
