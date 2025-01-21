import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart';

class RatingsReviewsPage extends StatefulWidget {
  const RatingsReviewsPage({super.key});

  @override
  _RatingsReviewsPageState createState() => _RatingsReviewsPageState();
}

class _RatingsReviewsPageState extends State<RatingsReviewsPage> {
  final List<String> _reviews = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ratings & Reviews'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(() => const MainHomeScreen());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOverallRatingsOverview(),
        const SizedBox(height: 20),
        _buildRecentReviewsSection(),
        const SizedBox(height: 20),
        _buildWriteReviewButton(),
      ],
    );
  }

  Widget _buildOverallRatingsOverview() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Ratings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 30),
            SizedBox(width: 5),
            Text(
              '4.9/5',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text('Rating Distribution:'),
        SizedBox(height: 10),
        Text('222126 reviews'),
      ],
    );
  }

  Widget _buildFilterSortOptions() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter & Sort Options',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('Filters:'),
        SizedBox(height: 10),
        Text('Sort Options:'),
      ],
    );
  }
  Widget _buildRecentReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Reviews',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ..._reviews.map((review) => ReviewCard(
              review: review,
              userName: 'Anonymous', // Replace with actual user name if available
            )),
      ],
    );
  }

  Widget _buildWriteReviewButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final result = await Get.to(() => WriteReviewPage());
          if (result != null && result is String) {
            setState(() {
              _reviews.add(result);
            });
          }
        },
        child: const Text('Write a Review'),
      ),
    );
  }
}

class WriteReviewPage extends StatelessWidget {
  final TextEditingController _reviewController = TextEditingController();

  WriteReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Write a Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Review',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your review here...',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String review = _reviewController.text;
                  if (review.isNotEmpty) {
                    Get.back(result: review);
                  } else {
                    Get.snackbar('Error', 'Please write a review before submitting.');
                  }
                },
                child: const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String review;
  final String userName;

  const ReviewCard({required this.review, required this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Set the height
      width: double.infinity,
      color: const Color.fromARGB(188, 207, 197, 197),
      margin: const EdgeInsets.symmetric(vertical: 26),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(review),
          ],
        ),
      ),
    );
  }
}

