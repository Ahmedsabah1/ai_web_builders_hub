import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/providers.dart';
import '../../../core/constants/app_constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // User Profile Section
          if (currentUser != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            currentUser.email[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser.displayName ?? 'User',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                currentUser.email,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Appearance Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle between light and dark theme'),
                    value: isDarkMode,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).state = value;
                    },
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // App Info Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('App Version'),
                    subtitle: const Text(AppConstants.appVersion),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('About AI Web Builders Hub'),
                    subtitle: const Text(AppConstants.appDescription),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_outline),
                    title: const Text('Rate the App'),
                    subtitle: const Text('Help us improve with your feedback'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      // TODO: Implement app rating
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Rating feature coming soon'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      // TODO: Show privacy policy
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Privacy policy coming soon'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.gavel_outlined),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      // TODO: Show terms of service
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Terms of service coming soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Support Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & FAQ'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      // TODO: Show help screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Help section coming soon'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bug_report_outlined),
                    title: const Text('Report a Bug'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      // TODO: Show bug report
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bug report feature coming soon'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Contact Us'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      // TODO: Open email or contact form
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contact feature coming soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sign Out Button
          if (currentUser != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final shouldSignOut = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );

                  if (shouldSignOut == true) {
                    try {
                      final authRepository = ref.read(authRepositoryProvider);
                      await authRepository.signOut();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error signing out: ${e.toString()}'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sign Out'),
              ),
            ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}