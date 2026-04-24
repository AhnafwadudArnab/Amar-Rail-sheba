import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/utils/responsive.dart';

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
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Announcement', style: TextStyle(fontSize: r.fs16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.to(() => const MainHomeScreen()),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              _buildSearchBar(r),
              _buildCategoryTabs(r),
              _buildPinnedSection(r),
              Expanded(child: _buildAnnouncementList(r)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(R r) {
    return Padding(
      padding: EdgeInsets.all(r.sp8),
      child: TextField(
        style: TextStyle(fontSize: r.fs13),
        decoration: InputDecoration(
          hintText: 'Search announcements...',
          hintStyle: TextStyle(fontSize: r.fs13),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.symmetric(vertical: r.sp10),
        ),
        onChanged: (value) => setState(() => searchQuery = value),
      ),
    );
  }

  Widget _buildCategoryTabs(R r) {
    final categories = ['All', 'Schedule Updates', 'Promotions', 'Safety Alerts', 'Service Enhancements'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: r.sp8),
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: EdgeInsets.only(right: r.sp6),
            child: ChoiceChip(
              label: Text(category, style: TextStyle(fontSize: r.fs12)),
              selected: selectedCategory == category,
              onSelected: (_) => setState(() => selectedCategory = category),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPinnedSection(R r) {
    final pinned = Announcement(
      title: 'Emergency Alert',
      description: 'This is a critical update.',
      timestamp: 'Just now',
      category: 'Safety Alerts',
    );
    return Card(
      margin: EdgeInsets.symmetric(horizontal: r.sp8, vertical: r.sp4),
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp10),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            SizedBox(width: r.sp10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pinned.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: r.fs13)),
                  Text(pinned.description,
                      style: TextStyle(color: Colors.white70, fontSize: r.fs12)),
                ],
              ),
            ),
            SizedBox(width: r.sp8),
            Text(pinned.timestamp,
                style: TextStyle(color: Colors.white70, fontSize: r.fs11)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementList(R r) {
    final filtered = announcements.where((a) {
      final matchCat = selectedCategory == 'All' || a.category == selectedCategory;
      final matchSearch = a.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          a.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: r.sp8),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final a = filtered[index];
        final isRead = readAnnouncements.contains(a);
        final isSaved = savedAnnouncements.contains(a);
        return Card(
          margin: EdgeInsets.only(bottom: r.sp8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Icon(_getIconForCategory(a.category), size: r.fs20),
            title: Text(a.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: r.fs13,
                    color: isRead ? Colors.grey : Colors.black)),
            subtitle: Text(a.description, style: TextStyle(fontSize: r.fs12)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, size: r.fs18),
                  onPressed: () => setState(() {
                    isSaved ? savedAnnouncements.remove(a) : savedAnnouncements.add(a);
                  }),
                ),
                IconButton(
                  icon: Icon(isRead ? Icons.mark_email_read : Icons.mark_email_unread, size: r.fs18),
                  onPressed: () => setState(() {
                    isRead ? readAnnouncements.remove(a) : readAnnouncements.add(a);
                  }),
                ),
              ],
            ),
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
