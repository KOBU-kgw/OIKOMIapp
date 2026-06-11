import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_version.dart';
import '../l10n/app_localizations.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../widgets/adaptive/adaptive_app_bar.dart';

const _privacyUrl = 'https://kobu-kgw.github.io/OIKOMIapp/privacy.html';
const _termsUrl = 'https://kobu-kgw.github.io/OIKOMIapp/terms.html';
const _supportUrl = 'https://kobu-kgw.github.io/OIKOMIapp/support.html';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
  }

  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() => _notificationsEnabled = value);

    if (value) {
      final tasks = await DatabaseService.getAllIncompleteTasks();
      await NotificationService.rescheduleAllNotifications(tasks);
    } else {
      await NotificationService.cancelAllNotifications();
    }
  }

  Future<void> _launchUrl(String url) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(l.settingsUrlError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: adaptiveAppBar(title: l.settingsTitle),
      body: ListView(
        children: [
          // ─── 一般 ───────────────────────────────────────────────
          _SectionHeader(l.settingsSectionGeneral),
          _SettingsCard(
            children: [
              SwitchListTile.adaptive(
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
                title: Text(l.settingsNotifications),
                activeTrackColor: Colors.blue,
              ),
              const Divider(height: 1, indent: 16),
              ListTile(
                title: Text(l.settingsLanguage),
                trailing: Text(
                  l.settingsLanguageValue,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ),
            ],
          ),

          // ─── 情報 ────────────────────────────────────────────────
          _SectionHeader(l.settingsSectionInfo),
          _SettingsCard(
            children: [
              ListTile(
                title: Text(l.settingsVersion),
                trailing: Text(
                  kCurrentVersion,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const Divider(height: 1, indent: 16),
              ListTile(
                title: Text(l.settingsPrivacyPolicy),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => _launchUrl(_privacyUrl),
              ),
              const Divider(height: 1, indent: 16),
              ListTile(
                title: Text(l.settingsTermsOfService),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => _launchUrl(_termsUrl),
              ),
              const Divider(height: 1, indent: 16),
              ListTile(
                title: Text(l.settingsSupport),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => _launchUrl(_supportUrl),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }
}
