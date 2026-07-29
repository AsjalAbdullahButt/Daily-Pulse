"""
Profile screen - view and edit user profile
"""
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/formatters.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : '?',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(user?.name ?? 'User', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          )),
        ),
        Center(
          child: Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          )),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              _infoTile(context, Icons.cake_outlined, 'Age', user?.age?.toString() ?? '--'),
              const Divider(height: 1),
              _infoTile(context, Icons.monitor_weight_outlined, 'Weight', user?.weightKg != null ? '${user!.weightKg} kg' : '--'),
              const Divider(height: 1),
              _infoTile(context, Icons.height, 'Height', user?.heightCm != null ? '${user!.heightCm} cm' : '--'),
              const Divider(height: 1),
              _infoTile(context, Icons.calendar_today, 'Joined', user != null ? formatDate(user.createdAt) : '--'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () {
            auth.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
        ),
      ],
    );
  }

  Widget _infoTile(BuildContext context, IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
