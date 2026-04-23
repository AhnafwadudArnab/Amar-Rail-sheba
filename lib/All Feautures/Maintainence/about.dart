import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full-page About / Developer Info screen
class DeveloperInfoPage extends StatelessWidget {
  const DeveloperInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // App logo / icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1628),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.train, size: 56, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Amar Rail Sheba',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bangladesh Railway Ticket Booking App',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                // Developer card
                _DeveloperCard(
                  name: 'Ahnaf Wadud Arnab',
                  role: 'Lead Developer',
                  email: 'aarnab222126@bscse.uiu.ac.bd',
                  location: 'Dhaka, Bangladesh',
                  github: 'https://github.com/AhnafwadudArnab',
                  linkedin: 'https://www.linkedin.com/in/ahnaf-wadud-arnab-b17b5a26b/',
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                // App info
                _InfoTile(Icons.info_outline, 'Version', '1.0.0'),
                _InfoTile(Icons.school_outlined, 'Institution', 'United International University'),
                _InfoTile(Icons.group_outlined, 'Group', 'Group 05 — DBMS Project'),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String location;
  final String github;
  final String linkedin;

  const _DeveloperCard({
    required this.name,
    required this.role,
    required this.email,
    required this.location,
    required this.github,
    required this.linkedin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF0A1628),
              child: Icon(Icons.person, size: 44, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(role,
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _ContactRow(Icons.email_outlined, email,
                onTap: () => _launch('mailto:$email')),
            const SizedBox(height: 8),
            _ContactRow(Icons.location_on_outlined, location),
            const SizedBox(height: 8),
            _ContactRow(Icons.code, 'GitHub',
                onTap: () => _launch(github)),
            const SizedBox(height: 8),
            _ContactRow(Icons.link, 'LinkedIn',
                onTap: () => _launch(linkedin)),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ContactRow(this.icon, this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1A3A6B)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: onTap != null ? Colors.blue[700] : Colors.black87,
                decoration: onTap != null ? TextDecoration.underline : null,
              ),
            ),
          ),
          if (onTap != null)
            const Icon(Icons.open_in_new, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1A3A6B)),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Spacer(),
          Text(value,
              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }
}

// ── Legacy alias so existing code using DeveloperInfoDialog still compiles ──
class DeveloperInfoDialog extends StatelessWidget {
  const DeveloperInfoDialog({super.key});
  @override
  Widget build(BuildContext context) => const DeveloperInfoPage();
}

// Legacy helper
class LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const LinkRow({super.key, required this.icon, required this.label, required this.url});
  @override
  Widget build(BuildContext context) {
    return _ContactRow(icon, '$label: $url');
  }
}

void showDeveloperInfo(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const DeveloperInfoPage()),
  );
}
