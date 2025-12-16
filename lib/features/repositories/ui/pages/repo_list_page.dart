import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_top_repos/core/constants/app_constatnts.dart';
import 'package:github_top_repos/core/constants/app_file_paths.dart';
import 'package:github_top_repos/features/repositories/controllers/app_theme_controller.dart';
import 'package:github_top_repos/features/repositories/controllers/repo_controller.dart';
import 'package:github_top_repos/features/repositories/ui/pages/repo_details_page.dart';

class RepoListPage extends ConsumerStatefulWidget {
  const RepoListPage({super.key});

  @override
  ConsumerState<RepoListPage> createState() => _RepoListPageState();
}

class _RepoListPageState extends ConsumerState<RepoListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(repoControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reposAsync = ref.watch(repoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
              child: Image.asset(AppFilePaths.iconPath, scale: 14),
            ),
            const SizedBox(width: 10),
            const Text('Repositories'),
          ],
        ),
        elevation: 2,
        /*    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.surface, */
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final themeMode = ref.watch(appThemeProvider);

              return IconButton(
                tooltip: themeMode == ThemeMode.dark
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons
                            .light_mode // ☀️ Sun
                      : Icons.dark_mode, // 🌙 Moon
                ),
                onPressed: () {
                  ref.read(appThemeProvider.notifier).toggleTheme();
                },
              );
            },
          ),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (option) => ref
                .read(repoControllerProvider.notifier)
                .sortRepositories(option),
            itemBuilder: (ctx) => const [
              PopupMenuItem(
                value: SortOption.stars,
                child: Text("Sort by Stars"),
              ),
              PopupMenuItem(
                value: SortOption.updatedAt,
                child: Text('Sort by Last Updated'),
              ),
            ],
          ),
        ],
      ),
      body: reposAsync.when(
        data: (repos) => ListView.builder(
          controller: _scrollController,
          itemCount: repos.length + 1, // extra item for loading indicator
          itemBuilder: (context, index) {
            if (index == repos.length) {
              final isLoadingMore = ref
                  .read(repoControllerProvider.notifier)
                  .isLoadingMore;
              return isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink();
            }

            final repo = repos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: repo.ownerAvatarUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person),
                ),
                title: Text(repo.name),
                subtitle: Text(
                  repo.description ?? 'No description',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text('⭐ ${repo.stars}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RepoDetailsPage(repository: repo),
                    ),
                  );
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text(AppConstatnts.NO_INTERNET_CONNECTION)),
      ),
    );
  }
}
