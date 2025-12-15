import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:github_top_repos/features/repositories/ui/widgets/description_section.dart';
import 'package:github_top_repos/features/repositories/ui/widgets/header_section.dart';
import 'package:github_top_repos/features/repositories/ui/widgets/info_row.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/github_repository.dart';
import 'package:intl/intl.dart';

class RepoDetailsPage extends StatelessWidget {
  final GitHubRepository repository;

  const RepoDetailsPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'MM-dd-yyyy HH:mm',
    ).format(repository.updatedAt);

    Future<void> launchInAppWithBrowserOptions(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(showTitle: true),
      )) {
        throw Exception('Could not launch $url');
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Repository Details")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          launchInAppWithBrowserOptions(Uri.parse(repository.repoUrl));
        },
        icon: const Icon(Icons.open_in_new),
        label: const Text('Open on GitHub'),
      ),

      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                HeaderSection(repo: repository),
                const SizedBox(height: 12),

                InfoRow(formattedDate: formattedDate, stars: repository.stars),
                const SizedBox(height: 20),

                CollapsibleDescription(
                  text: repository.description ?? 'No description available',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
