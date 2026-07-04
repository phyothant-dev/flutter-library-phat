import 'package:flutter/material.dart';

class Link {
  final IconData icon;
  final String label;
  final String url;

  const Link({
    required this.icon,
    required this.label,
    required this.url,
  });
}

class Credit {
  final String initials;
  final String name;
  final String role;
  final String about;
  final String topics;
  final List<Link> links;

  const Credit({
    required this.initials,
    required this.name,
    required this.role,
    required this.about,
    required this.topics,
    required this.links,
  });
}
