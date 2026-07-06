import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/credit.dart';

class CreditDetailPage extends StatelessWidget {
  final Credit credit;

  const CreditDetailPage({super.key, required this.credit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: theme.colorScheme.surfaceTint,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 56),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: credit.imageUrl.isNotEmpty
                            ? (credit.imageUrl.startsWith('assets/')
                                ? Image.asset(credit.imageUrl, fit: BoxFit.cover)
                                : CachedNetworkImage(
                                    imageUrl: credit.imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Center(
                                      child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => Center(
                                      child: Text(
                                        credit.initials,
                                        style: GoogleFonts.ebGaramond(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.onSecondaryContainer,
                                        ),
                                      ),
                                    ),
                                  ))
                            : Center(
                                child: Text(
                                  credit.initials,
                                  style: GoogleFonts.ebGaramond(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        credit.name,
                        style: GoogleFonts.ebGaramond(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        credit.role,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.05,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildSection(
                    theme,
                    'About',
                    credit.about,
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    theme,
                    'Topics',
                    credit.topics,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Connect',
                    style: GoogleFonts.ebGaramond(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 28 / 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...credit.links.map(
                    (link) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildLinkRow(theme, link.icon, link.label, link.url),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Made with ❤️ for the developer community',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 13,
                        color: theme.colorScheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.ebGaramond(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 28 / 20,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkRow(ThemeData theme, IconData icon, String label, String url) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.open_in_new_rounded,
              size: 16,
              color: theme.colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
