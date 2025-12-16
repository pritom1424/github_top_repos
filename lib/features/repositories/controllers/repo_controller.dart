import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_top_repos/core/api/github_api.dart';
import 'package:github_top_repos/core/storage/local_storage_service.dart';
import '../models/github_repository.dart';
import '../services/repo_remote_service.dart';

enum SortOption { stars, updatedAt }

final repoRemoteServiceProvider = Provider<RepoRemoteService>(
  (ref) => RepoRemoteService(GitHubApi()),
);

final repoControllerProvider =
    AsyncNotifierProvider<RepoController, List<GitHubRepository>>(
      () => RepoController(),
    );

class RepoController extends AsyncNotifier<List<GitHubRepository>> {
  final LocalStorageService _localStorage = LocalStorageService();
  SortOption currentSort = SortOption.stars;

  int _currentPage = 1;
  final int _perPage = 10;
  bool isLoadingMore = false;
  final int _total = 50;

  List<GitHubRepository> allRepos = [];

  @override
  Future<List<GitHubRepository>> build() async {
    currentSort = await _localStorage.getSortOption();
    final cached = await _localStorage.getRepositories();
    if (cached.isNotEmpty) {
      allRepos = cached;
      await sortRepositories(currentSort, list: cached);
      return allRepos;
    }

    return await _fetchFromApi();
  }

  Future<List<GitHubRepository>> refresh() async {
    state = const AsyncValue.loading();
    _currentPage = 1;
    isLoadingMore = false;
    allRepos.clear();
    return await _fetchFromApi();
  }

  Future<List<GitHubRepository>> loadMore() async {
    if (allRepos.length > _total) {
      return allRepos;
    }

    isLoadingMore = true;
    _currentPage++;
    await _fetchFromApi(page: _currentPage);
    isLoadingMore = false;
    return allRepos;
  }

  Future<List<GitHubRepository>> _fetchFromApi({int page = 1}) async {
    try {
      final apiService = ref.read(repoRemoteServiceProvider);
      final repos = await apiService.fetchRepositories(
        page: page,
        perPage: _perPage,
      );

      if (page == 1) {
        allRepos = repos;
      } else {
        allRepos.addAll(repos);
      }

      // Save loaded all page to local storage

      await _localStorage.saveRepositories(allRepos);

      await sortRepositories(currentSort, list: allRepos);

      return allRepos;
    } catch (e, st) {
      if (allRepos.isNotEmpty) {
        state = AsyncValue.data(allRepos);
        return allRepos;
      } else {
        state = AsyncValue.error(e, st);
        rethrow;
      }
    }
  }

  Future<void> sortRepositories(
    SortOption option, {
    List<GitHubRepository>? list,
  }) async {
    currentSort = option;
    await _localStorage.saveSortOption(option);

    final currentList = list ?? allRepos;

    List<GitHubRepository> sortedList = List.from(currentList);
    if (option == SortOption.stars) {
      sortedList.sort((a, b) => b.stars.compareTo(a.stars));
    } else if (option == SortOption.updatedAt) {
      sortedList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    allRepos = sortedList;
    state = AsyncValue.data(allRepos);
  }
}
