import 'package:flutter_test/flutter_test.dart';
import 'package:github_top_repos/core/storage/local_storage_service.dart';
import 'package:github_top_repos/features/repositories/models/github_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("Local Storage Service", () {
    late LocalStorageService localStorageService;
    setUp(() {
      localStorageService = LocalStorageService();
      SharedPreferences.setMockInitialValues({});
    });

    test("save and load repos", () async {
      final dummyRepos = [
        GitHubRepository(
          id: 1,
          name: 'Flutter Repo 1',
          description: 'Test repo 1',
          stars: 100,
          updatedAt: DateTime.now(),
          ownerName: 'Alice',
          ownerAvatarUrl: 'https://via.placeholder.com/150',
          repoUrl: 'https://github.com/alice/flutter1',
        ),
        GitHubRepository(
          id: 2,
          name: 'Flutter Repo 2',
          description: 'Test repo 2',
          stars: 200,
          updatedAt: DateTime.now(),
          ownerName: 'Bob',
          ownerAvatarUrl: 'https://via.placeholder.com/150',
          repoUrl: 'https://github.com/bob/flutter2',
        ),
      ];
      //save in local storage
      await localStorageService.saveRepositories(dummyRepos);
      //get from local storage
      final loadRepos = await localStorageService.getRepositories();

      expect(loadRepos.length, 2);
      expect(loadRepos[0].name, "Flutter Repo 1");
      expect(loadRepos[1].name, 'Flutter Repo 2');
    });
  });
}
