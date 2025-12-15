import 'dart:convert';
import 'package:github_top_repos/features/repositories/controllers/repo_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/repositories/models/github_repository.dart';

class LocalStorageService {
  static const String _cachedReposKey = 'cached_repos';
  static const String _sortOptionKey = 'sort_option';

  Future<void> saveSortOption(SortOption option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sortOptionKey, option.index);
  }

  Future<SortOption> getSortOption() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_sortOptionKey) ?? 0;
    return SortOption.values[index];
  }

  Future<void> saveRepositories(List<GitHubRepository> repos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(repos.map((r) => r.toJson()).toList());
    await prefs.setString(_cachedReposKey, jsonString);
  }

  Future<List<GitHubRepository>> getRepositories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cachedReposKey);

    if (jsonString == null) return [];

    final list = jsonDecode(jsonString) as List;
    return list
        .map((e) => GitHubRepository.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
