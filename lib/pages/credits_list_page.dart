import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/credit.dart';
import 'credit_detail_page.dart';

const _credits = [
  Credit(
    initials: 'EM',
    name: 'Ei Maung',
    role: 'Web Developer & Author',
    about: 'Professional web developer since 2006. Co-founder of Fairway Technology. '
        'Author of 18 books on web development, programming, DevOps, AI, and fiction. '
        'Passionate about sharing knowledge with the Burmese developer community.',
    topics: 'Agentic Coding · n8n · OpenClaw · Vibe Coding · '
        'Rockstar Developer · Professional Web Developer · '
        'JavaScript · PHP · Laravel · React · Bootstrap · '
        'API Design · Bitcoin · Ubuntu Linux · '
        'Programming for Kids · Lyra and Silent Frequency',
    links: [
      Link(icon: Icons.language_rounded, label: 'eimaung.com', url: 'https://eimaung.com'),
      Link(icon: Icons.business_rounded, label: 'Fairway Technology', url: 'https://fairwayweb.com'),
      Link(icon: Icons.code_rounded, label: 'GitHub', url: 'https://github.com/eimg'),
      Link(icon: Icons.facebook_rounded, label: 'Facebook', url: 'https://www.facebook.com/sayar.ei.maung'),
    ],
  ),
  Credit(
    initials: 'LM',
    name: 'Lwin Moe Paing',
    role: 'Frontend Developer & Author',
    about: 'Frontend developer and community builder. '
        'Author of beginner-friendly books on HTML & CSS, TypeScript, and Figma for developers. '
        'Passionate about helping young developers start their web development journey.',
    topics: 'HTML & CSS · TypeScript · Figma · Frontend Development · Web Development',
    links: [
      Link(icon: Icons.language_rounded, label: 'lwinmoepaing.com', url: 'https://lwinmoepaing.com'),
      Link(icon: Icons.code_rounded, label: 'GitHub', url: 'https://github.com/lwinmoepaing'),
      Link(icon: Icons.alternate_email_rounded, label: 'Twitter / X', url: 'https://x.com/LwinMoePaingDev'),
    ],
  ),
];

class CreditsListPage extends StatelessWidget {
  const CreditsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(
          'Credits',
          style: GoogleFonts.ebGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        itemCount: _credits.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final credit = _credits[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  credit.initials,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ),
            title: Text(
              credit.name,
              style: GoogleFonts.ebGaramond(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.outline,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreditDetailPage(credit: credit),
              ),
            ),
          );
        },
      ),
    );
  }
}
