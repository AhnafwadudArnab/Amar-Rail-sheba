import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/utils/responsive.dart';
import 'package:amarRailSheba/All%20Feautures/firstpage/booking.dart';

class RatingsReviewsPage extends StatefulWidget {
  const RatingsReviewsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RatingsReviewsPageState createState() => _RatingsReviewsPageState();
}

class _RatingsReviewsPageState extends State<RatingsReviewsPage> {
  final List<String> _reviews = [];

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Ratings & Reviews', style: TextStyle(fontSize: r.fs16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.to(() => const MainHomeScreen()),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(r.sp16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _buildContent(r),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOverallRatingsOverview(r),
        SizedBox(height: r.sp20),
        _buildRecentReviewsSection(r),
        SizedBox(height: r.sp20),
        _buildWriteReviewButton(r),
      ],
    );
  }

  Widget _buildOverallRatingsOverview(R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overall Ratings',
            style: TextStyle(fontSize: r.fs16, fontWeight: FontWeight.bold)),
        SizedBox(height: r.sp10),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: r.fs28),
            SizedBox(width: r.sp6),
            Text('4.9/5',
                style: TextStyle(fontSize: r.fs22, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: r.sp10),
        Text('Rating Distribution:', style: TextStyle(fontSize: r.fs13)),
        SizedBox(height: r.sp8),
        Text('222126 reviews', style: TextStyle(fontSize: r.fs13, color: Colors.grey)),
      ],
    );
  }

  Widget _buildRecentReviewsSection(R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Reviews',
            style: TextStyle(fontSize: r.fs16, fontWeight: FontWeight.bold)),
        SizedBox(height: r.sp10),
        ..._reviews.map((review) => ReviewCard(review: review, userName: 'Anonymous')),
      ],
    );
  }

  Widget _buildWriteReviewButton(R r) {
    return Center(
      child: SizedBox(
        height: r.btnH,
        child: ElevatedButton(
          onPressed: () async {
            final result = await Get.to(() => WriteReviewPage());
            if (result != null && result is String) {
              setState(() => _reviews.add(result));
            }
          },
          child: Text('Write a Review', style: TextStyle(fontSize: r.fs14)),
        ),
      ),
    );
  }
}

class WriteReviewPage extends StatelessWidget {
  final TextEditingController _reviewController = TextEditingController();

  WriteReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Write a Review', style: TextStyle(fontSize: r.fs16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: EdgeInsets.all(r.sp16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Review',
                    style: TextStyle(fontSize: r.fs16, fontWeight: FontWeight.bold)),
                SizedBox(height: r.sp10),
                TextField(
                  controller: _reviewController,
                  maxLines: 5,
                  style: TextStyle(fontSize: r.fs13),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: 'Write your review here...',
                    hintStyle: TextStyle(fontSize: r.fs13),
                  ),
                ),
                SizedBox(height: r.sp20),
                Center(
                  child: SizedBox(
                    height: r.btnH,
                    child: ElevatedButton(
                      onPressed: () {
                        final review = _reviewController.text;
                        if (review.isNotEmpty) {
                          Get.back(result: review);
                        } else {
                          Get.snackbar('Error', 'Please write a review before submitting.');
                        }
                      },
                      child: Text('Submit Review', style: TextStyle(fontSize: r.fs14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    final r = R.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: r.sp12),
      padding: EdgeInsets.all(r.sp14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(188, 207, 197, 197),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userName,
              style: TextStyle(fontSize: r.fs14, fontWeight: FontWeight.bold)),
          SizedBox(height: r.sp6),
          Text(review, style: TextStyle(fontSize: r.fs13)),
        ],
      ),
    );
  }
}

