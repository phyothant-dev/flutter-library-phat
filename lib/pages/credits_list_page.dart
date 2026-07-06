import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/credit.dart';
import '../providers/credits_provider.dart';
import 'credit_detail_page.dart';

class CreditsListPage extends ConsumerWidget {
  const CreditsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final creditsAsync = ref.watch(creditsProvider);

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
      body: creditsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off_rounded, size: 48,
                    color: theme.colorScheme.outline),
                const SizedBox(height: 12),
                Text(
                  'Could not load credits',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(creditsProvider),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (credits) {
          if (credits.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 48,
                      color: theme.colorScheme.outline),
                  const SizedBox(height: 12),
                  Text(
                    'No credits yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            itemCount: credits.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final credit = credits[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                leading: Container(
                  width: 44,
                  height: 44,
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
                                  width: 18,
                                  height: 18,
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme
                                        .onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ))
                      : Center(
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
          );
        },
      ),
    );
  }
}
