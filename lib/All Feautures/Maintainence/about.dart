import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../booking.dart';
class DeveloperInfoDialog extends StatelessWidget {
  const DeveloperInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/trainBackgrong/profile.jpg'), // Replace with your image asset
            ),
            SizedBox(height: 16),
            // Developer Name
            Text(
              "Ahnaf Wadud Arnab",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Job Title
            /*Text(
              "A Front-End Developer",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),*/
            SizedBox(height: 16),
            // Contact Information
            Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Contact Information:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text("Ahananfwadudarnongmail.com"),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text("Dhaka, Bangladesh"),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Social Links
            Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Social Links:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            LinkRow(icon: Icons.code, label: "GitHub", url: "https://github.com/AhnafwadudArnab"),
            LinkRow(icon: Icons.link, label: "LinkedIn", url: "https://www.linkedin.com/in/ahnaf-wadud-arnab-b17b5a26b/"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {

            Get.to(()=>const MainHomeScreen());
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}

class LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const LinkRow({super.key, 
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Open the link (use url_launcher package)
      },
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $url",
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

void showDeveloperInfo(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const DeveloperInfoDialog(),
  );
}
