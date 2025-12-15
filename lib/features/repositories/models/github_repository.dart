class GitHubRepository {
  final int id;
  final String name;
  final String? description;
  final int stars;
  final DateTime updatedAt;
  final String ownerName;
  final String ownerAvatarUrl;
  final String repoUrl;

  const GitHubRepository({
    required this.id,
    required this.name,
    required this.description,
    required this.stars,
    required this.updatedAt,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.repoUrl,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      stars: json['stargazers_count'] as int,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      ownerName: json['owner']['login'] as String,
      ownerAvatarUrl: json['owner']['avatar_url'] as String,
      repoUrl: json['html_url'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'stargazers_count': stars,
      'updated_at': updatedAt.toIso8601String(),
      'owner': {'login': ownerName, 'avatar_url': ownerAvatarUrl},
      'html_url': repoUrl,
    };
  }

  GitHubRepository copyWith({
    int? id,
    String? name,
    String? description,
    int? stars,
    DateTime? updatedAt,
    String? ownerName,
    String? ownerAvatarUrl,
    String? repoUrl,
  }) {
    return GitHubRepository(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      stars: stars ?? this.stars,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerName: ownerName ?? this.ownerName,
      ownerAvatarUrl: ownerAvatarUrl ?? this.ownerAvatarUrl,
      repoUrl: repoUrl ?? this.repoUrl,
    );
  }
}
