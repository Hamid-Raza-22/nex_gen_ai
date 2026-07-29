import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../auth/application/auth_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.mid,
                child: Icon(Icons.person, color: AppColors.lightest),
              ),
              title: Text(user?.name ?? 'Guest'),
              subtitle: Text(user?.email ?? ''),
            ),
          ),
          const SizedBox(height: 16),
          const _SettingsTile(
            icon: Icons.workspace_premium_outlined,
            title: 'Subscription & Credits',
          ),
          const _SettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
          ),
          const _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms & Privacy',
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () =>
                ref.read(authControllerProvider.notifier).logout(),
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.light),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: AppColors.mid),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coming soon')),
          );
        },
      ),
    );
  }
}
