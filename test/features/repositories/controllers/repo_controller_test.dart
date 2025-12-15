import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:github_top_repos/features/repositories/controllers/repo_controller.dart';
import 'package:github_top_repos/features/repositories/models/github_repository.dart';
import 'package:github_top_repos/features/repositories/services/repo_remote_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock RepoRemoteService
class MockRepoRemoteService extends Mock implements RepoRemoteService {}

void main() {
  late MockRepoRemoteService mockService;
  late ProviderContainer container;
  TestWidgetsFlutterBinding.ensureInitialized();

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

  setUp(() {
    mockService = MockRepoRemoteService();
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer(
      overrides: [repoRemoteServiceProvider.overrideWithValue(mockService)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('RepoController initial fetch returns repos', () async {
    when(
      () => mockService.fetchRepositories(),
    ).thenAnswer((_) async => [testRepo]);

    final controller = container.read(repoControllerProvider.notifier);
    final result = await controller.refresh();

    expect(result, isA<List<GitHubRepository>>());
    expect(result.length, 1);
    expect(result[0].name, 'flutter_repo');
  });

  test('RepoController sorts by stars', () async {
    final repo2 = testRepo.copyWith(stars: 200);
    when(
      () => mockService.fetchRepositories(),
    ).thenAnswer((_) async => [testRepo, repo2]);

    final controller = container.read(repoControllerProvider.notifier);
    await controller.refresh();

    await controller.sortRepositories(SortOption.stars);

    final sorted = container.read(repoControllerProvider);
    expect(sorted.value!.first.stars, 200);
  });
}
