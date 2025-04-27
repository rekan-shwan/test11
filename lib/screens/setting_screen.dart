// this just for demonstration purpose, it does not contain any real functionality
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String appVersion = "1.0.0";
  String buildNumber = "1";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('System Information'),
                _buildInfoCard(),
                const SizedBox(height: 24),
                _buildSectionHeader('Appearance'),
                _buildAppearanceSettings(),
                const SizedBox(height: 24),
                _buildSectionHeader('Data Management'),
                _buildDataSettings(),
                const SizedBox(height: 24),
                _buildSectionHeader('Notifications'),
                _buildNotificationSettings(),
                const SizedBox(height: 24),
                _buildSectionHeader('Security'),
                _buildSecuritySettings(),
                const SizedBox(height: 24),
                _buildSectionHeader('Support'),
                _buildSupportCard(),
              ],
            ),
          );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Patient Management System',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'v$appVersion',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Build: $buildNumber'),
            const SizedBox(height: 4),
            const Text('© 2025 Leap agency'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSettings() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                 
                });
              },
            ),
          ),
          _buildListTile('Theme Color', Icons.color_lens),
          _buildListTile('Text Size', Icons.text_fields),
          _buildListTile('Language', Icons.language),
        ],
      ),
    );
  }

  Widget _buildDataSettings() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          _buildListTile('Backup Data', Icons.backup),
          _buildListTile('Restore Data', Icons.restore),
          _buildListTile('Export Patient Records', Icons.cloud_download),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          _buildListTile('Appointment Reminders', Icons.notifications_active),
          _buildListTile('Follow-up Alerts', Icons.event_note),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          _buildListTile('Change Password', Icons.password),
          _buildListTile('Privacy Settings', Icons.security),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          _buildListTile('Help Center', Icons.help_outline),
          _buildListTile('Contact Support', Icons.contact_support),
          _buildListTile('Send Feedback', Icons.rate_review),
          _buildListTile('Terms & Conditions', Icons.description),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showComingSoonSnackbar();
      },
    );
  }

  void _showComingSoonSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon! This feature is under development.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
