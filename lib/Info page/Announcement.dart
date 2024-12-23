import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/booking.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      title: const Text('Announcement'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
        Get.offAll(()=>const MainHomeScreen());
        },
      ),
      ),
      body: const Center(
        child: Text('Announcement Page'),
      ),
    );
  }
}
