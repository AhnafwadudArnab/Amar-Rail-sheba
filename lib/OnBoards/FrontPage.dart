import 'package:flutter/material.dart';
import 'package:trackers/Login&Signup/sign_up.dart';
import 'package:trackers/utils/responsive.dart';
import 'Big_Contents_models.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int _currentIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (_, i) => _buildPage(context, r, i),
              ),
            ),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (i) => _buildDot(r, i),
              ),
            ),
            SizedBox(height: r.sp20),

            // Next / Start button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.isPhone ? r.sp24 : r.isTablet ? 80 : 120,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SizedBox(
                  width: double.infinity,
                  height: r.btnH,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(r.sp32),
                      ),
                    ),
                    onPressed: () {
                      if (_currentIndex == contents.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUp()),
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      _currentIndex == contents.length - 1 ? 'Get Started' : 'Next',
                      style: TextStyle(
                          fontSize: r.fs16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: r.sp32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, R r, int i) {
    // Image takes ~55% of available height, rest is text
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.isPhone ? r.sp20 : r.isTablet ? 60 : 100,
        vertical: r.sp16,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                contents[i].Image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: r.sp20),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  contents[i].title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: r.fs22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: r.sp10),
                Text(
                  contents[i].description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: r.fs14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(R r, int index) {
    final selected = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: r.sp8,
      width: selected ? r.sp20 : r.sp8,
      margin: EdgeInsets.only(right: r.sp6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r.sp6),
        color: selected ? Colors.redAccent : Colors.grey[300],
      ),
    );
  }
}
