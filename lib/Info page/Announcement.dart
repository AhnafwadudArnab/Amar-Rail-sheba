import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../All Feautures/firstpage/booking.dart';
class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final List<Announcement> announcements = [
    Announcement(
      title: 'Upcoming Train Schedule Changes',
      description: 'Notify users about updates in train schedules due to maintenance, weather conditions, or operational changes.',
      timestamp: '2 hours ago',
      category: 'Schedule Updates',
    ),
    // Add more announcements here
  ];

  String selectedCategory = 'All';
  String searchQuery = '';
  final Set<Announcement> savedAnnouncements = {};
  final Set<Announcement> readAnnouncements = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Announcement'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => const MainHomeScreen());
          },
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryTabs(),
          _buildPinnedSection(),
          Expanded(child: _buildAnnouncementList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search announcements...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['All', 'Schedule Updates', 'Promotions', 'Safety Alerts', 'Service Enhancements'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return ChoiceChip(
            label: Text(category),
            selected: selectedCategory == category,
            onSelected: (selected) {
              setState(() {
                selectedCategory = category;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPinnedSection() {
    // Example pinned announcement
    final pinnedAnnouncement = Announcement(
      title: 'Emergency Alert',
      description: 'This is a critical update.',
      timestamp: 'Just now',
      category: 'Safety Alerts',
    );

    return Card(
      color: Colors.redAccent,
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.white),
        title: Text(pinnedAnnouncement.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(pinnedAnnouncement.description, style: const TextStyle(color: Colors.white)),
        trailing: Text(pinnedAnnouncement.timestamp, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildAnnouncementList() {
    final filteredAnnouncements = announcements.where((announcement) {
      final matchesCategory = selectedCategory == 'All' || announcement.category == selectedCategory;
      final matchesSearch = announcement.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          announcement.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return ListView.builder(
      itemCount: filteredAnnouncements.length,
      itemBuilder: (context, index) {
        final announcement = filteredAnnouncements[index];
        final isRead = readAnnouncements.contains(announcement);
        final isSaved = savedAnnouncements.contains(announcement);

        return Card(
          child: ListTile(
            leading: Icon(_getIconForCategory(announcement.category)),
            title: Text(
              announcement.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isRead ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Text(announcement.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                  onPressed: () {
                    setState(() {
                      if (isSaved) {
                        savedAnnouncements.remove(announcement);
                      } else {
                        savedAnnouncements.add(announcement);
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(isRead ? Icons.mark_email_read : Icons.mark_email_unread),
                  onPressed: () {
                    setState(() {
                      if (isRead) {
                        readAnnouncements.remove(announcement);
                      } else {
                        readAnnouncements.add(announcement);
                      }
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              // Optional: Expand card to show full details
            },
          ),
        );
      },
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Schedule Updates':
        return Icons.train;
      case 'Promotions':
        return Icons.star;
      case 'Safety Alerts':
        return Icons.security;
      case 'Service Enhancements':
        return Icons.build;
      default:
        return Icons.info;
    }
  }
}

class Announcement {
  final String title;
  final String description;
  final String timestamp;
  final String category;

  Announcement({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
  });
}
