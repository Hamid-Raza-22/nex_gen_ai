import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../data/billing_repository.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(packagesProvider);
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Subscription & Credits')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(packagesProvider);
          ref.invalidate(transactionsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Plans', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            packages.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => _ErrorCard(message: '$e'),
              data: (list) => list.isEmpty
                  ? const _EmptyCard(message: 'No plans available right now.')
                  : Column(
                      children: [
                        for (final pkg in list) _PackageCard(package: pkg),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            Text('Transactions',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            transactions.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => _ErrorCard(message: '$e'),
              data: (list) => list.isEmpty
                  ? const _EmptyCard(message: 'No transactions yet.')
                  : Column(
                      children: [
                        for (final tx in list)
                          Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(tx.packageName ?? 'Purchase'),
                              subtitle: Text(
                                tx.createdAt
                                        ?.toLocal()
                                        .toString()
                                        .split('.')
                                        .first ??
                                    '',
                                style: const TextStyle(
                                  color: AppColors.light,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Text(
                                '\$${tx.amount}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final CreditPackage package;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    package.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '\$${package.amount}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
            if (package.description != null) ...[
              const SizedBox(height: 6),
              Text(
                package.description!,
                style: const TextStyle(color: AppColors.light, fontSize: 13),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              children: [
                if (package.numOfWords != null)
                  _Metric(
                    icon: Icons.text_fields,
                    label: '${package.numOfWords} words',
                  ),
                if (package.numOfTokens != null)
                  _Metric(
                    icon: Icons.image_outlined,
                    label: '${package.numOfTokens} images',
                  ),
              ],
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () {
                // Store policies require in-app purchase for digital goods.
                // Wire RevenueCat / StoreKit here before release.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('In-app purchase setup required'),
                  ),
                );
              },
              child: const Text('Choose Plan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.neonCyan),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: const TextStyle(color: AppColors.light),
        ),
      ),
    );
  }
}
