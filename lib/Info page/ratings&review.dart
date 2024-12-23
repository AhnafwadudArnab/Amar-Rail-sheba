
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../booking.dart';

class RatingsReviewsPage extends StatelessWidget {
  const RatingsReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      title: const Text('Ratings & Reviews'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
        Get.offAll(()=>const MainHomeScreen());
        },
      ),
      ),
      body: const Center(
        child: Text('Ratings & Reviews'),
      ),
    );
      
  }
}