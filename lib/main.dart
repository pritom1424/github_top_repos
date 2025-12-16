import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_top_repos/core/theme/app_theme.dart';
import 'package:github_top_repos/features/repositories/controllers/app_theme_controller.dart';
import 'package:github_top_repos/features/repositories/ui/pages/repo_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeProvider);
    return MaterialApp(
      title: 'GitHub Top Flutter Repos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      themeMode: themeMode,
      darkTheme: AppTheme.dark(),
      home: const RepoListPage(),
    );
  }
}
