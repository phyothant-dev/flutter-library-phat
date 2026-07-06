import 'package:flutter/material.dart';

IconData _iconFromString(String name) {
  switch (name) {
    case 'language_rounded':
      return Icons.language_rounded;
    case 'business_rounded':
      return Icons.business_rounded;
    case 'code_rounded':
      return Icons.code_rounded;
    case 'facebook_rounded':
      return Icons.facebook_rounded;
    case 'alternate_email_rounded':
      return Icons.alternate_email_rounded;
    default:
      return Icons.link_rounded;
  }
}

String _iconToString(IconData icon) {
  if (icon == Icons.language_rounded) return 'language_rounded';
  if (icon == Icons.business_rounded) return 'business_rounded';
  if (icon == Icons.code_rounded) return 'code_rounded';
  if (icon == Icons.facebook_rounded) return 'facebook_rounded';
  if (icon == Icons.alternate_email_rounded) return 'alternate_email_rounded';
  return 'link_rounded';
}

class Link {
  final IconData icon;
  final String label;
  final String url;

  const Link({
    required this.icon,
    required this.label,
    required this.url,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      icon: _iconFromString(json['icon'] as String? ?? 'link_rounded'),
      label: json['label'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'icon': _iconToString(icon),
        'label': label,
        'url': url,
      };
}

class Credit {
  final String initials;
  final String name;
  final String role;
  final String about;
  final String topics;
  final String imageUrl;
  final List<Link> links;

  const Credit({
    required this.initials,
    required this.name,
    required this.role,
    required this.about,
    required this.topics,
    this.imageUrl = '',
    required this.links,
  });

  factory Credit.fromJson(Map<String, dynamic> json) {
    final linksRaw = json['links'];
    final links = linksRaw is List
        ? linksRaw
            .map((e) => Link.fromJson(e as Map<String, dynamic>))
            .toList()
        : <Link>[];

    final name = json['name'] as String? ?? '';
    final words = name.split(' ');
    final initials = words.length >= 2
        ? '${words.first[0]}${words.last[0]}'.toUpperCase()
        : name.isNotEmpty
            ? name.substring(0, 2).toUpperCase()
            : '??';

    return Credit(
      initials: initials,
      name: name,
      role: json['role'] as String? ?? '',
      about: json['about'] as String? ?? '',
      topics: json['topics'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      links: links,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'role': role,
        'about': about,
        'topics': topics,
        'image_url': imageUrl,
        'links': links.map((l) => l.toJson()).toList(),
      };
}
