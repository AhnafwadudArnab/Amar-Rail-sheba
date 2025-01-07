import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/booking.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Privacy Policy'),
        //back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offAll(() =>const MainHomeScreen());
            },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy for Amar Rail-Sheba',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Effective Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your privacy is important to us. This Privacy Policy explains how we collect, use, share, and protect your information when you use the Railway System App ("the App"). By using the App, you agree to the practices outlined in this policy.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('1. Information We Collect'),
            _buildSectionContent(
              'We collect the following types of information:\n\n'
              '#. Personal Information\n\n'
              'Name, email address, phone number, and other contact details.\n\n'
              'Identification details (e.g., national ID, passport number) for booking verification.\n\n'
              '#. Travel Information\n\n'
              'Train routes, schedules, and booking history.\n\n'
              'Seat preferences and travel class.\n\n'
              '#. Payment Information\n\n'
              'Payment method details (e.g., credit/debit card information). Note: Payment details are processed securely by third-party payment gateways and are not stored by the App.\n\n'
              '#. Device and App Usage Information\n\n'
              'Device type, operating system, and unique device identifiers.\n\n'
              'IP address, browser type, and app usage statistics.\n\n'
              'Location data (if enabled).\n\n'
              '#. Cookies and Tracking Technologies\n\n'
              'Cookies and similar technologies to improve functionality, track usage, and personalize your experience.',
            ),
            _buildSectionTitle('2. How We Use Your Information'),
            _buildSectionContent(
              'We use your information for the following purposes:\n\n'
              '#. To Provide Services\n\n'
              'Facilitate ticket bookings, cancellations, and refunds.\n\n'
              'Provide real-time updates (e.g., train delays, cancellations).\n\n'
              'Enable in-app purchases and secure payment processing.\n\n'
              '#. To Improve User Experience\n\n'
              'Analyze usage patterns to enhance app features.\n\n'
              'Provide personalized recommendations and offers.\n\n'
              '#. For Communication\n\n'
              'Send booking confirmations, travel alerts, and customer support responses.\n\n'
              'Notify users of promotions, special offers, or policy updates.\n\n'
              '#. Legal and Compliance\n\n'
              'Comply with legal obligations and government regulations.',
            ),
            _buildSectionTitle('3. Sharing Your Information'),
            _buildSectionContent(
              'We do not sell your data. However, we may share your information with:\n\n'
              '#. Service Providers\n\n'
              'Third-party providers for payment processing, analytics, and customer support.\n\n'
              '#. Government Authorities\n\n'
              'As required by law, to comply with legal or regulatory obligations.\n\n'
              '#. Business Transfers\n\n'
              'In the event of a merger, acquisition, or sale of assets, your information may be transferred to the new entity.',
            ),
            _buildSectionTitle('4. Data Security'),
            _buildSectionContent(
              'We prioritize the security of your data by implementing:\n\n'
              'Encryption of sensitive information during transmission.\n\n'
              'Secure servers and restricted access to personal data.\n\n'
              'Regular monitoring for vulnerabilities and security breaches.\n\n'
              'However, no method of electronic storage or transmission is completely secure. While we strive to protect your data, we cannot guarantee its absolute security.',
            ),
            _buildSectionTitle('5. Your Rights'),
            _buildSectionContent(
              'As a user, you have the following rights:\n\n'
              '#. Access and Update\n\n'
              'Access and update your personal information through the app settings.\n\n'
              '#. Deletion\n\n'
              'Request deletion of your personal data. Note: Some information may be retained to comply with legal obligations.\n\n'
              '#. Opt-Out\n\n'
              'Opt-out of marketing communications by adjusting your preferences in the app or contacting customer support.\n\n'
              '#. Data Portability\n\n'
              'Request a copy of your personal data in a machine-readable format.',
            ),
            _buildSectionTitle('6. Cookies and Tracking Technologies'),
            _buildSectionContent(
              'We use cookies and similar technologies to:\n\n'
              'Remember user preferences.\n\n'
              'Analyze app performance and usage.\n\n'
              'Deliver personalized advertisements and promotions.\n\n'
              'You can manage cookie preferences through your device settings.',
            ),
            _buildSectionTitle('7. Retention of Data'),
            _buildSectionContent(
              'We retain your personal information for as long as necessary to:\n\n'
              'Provide services and fulfill transactions.\n\n'
              'Comply with legal and regulatory obligations.',
            ),
            _buildSectionTitle('8. Third-Party Links'),
            _buildSectionContent(
              'The App may contain links to third-party websites or services. We are not responsible for their privacy practices or content. Please review the privacy policies of these third parties.',
            ),
            _buildSectionTitle('9. Updates to This Policy'),
            _buildSectionContent(
              'We may update this Privacy Policy periodically to reflect changes in our practices or legal requirements. Significant changes will be communicated through the App or via email.',
            ),
            _buildSectionTitle('10. Contact Us'),
            _buildSectionContent(
              'If you have questions or concerns about this Privacy Policy, please contact us:\n\n'
              'Email: [aarnab222126@bscse.uiu.ac.bd]\n\n'
              'Phone: [01840658317 ]\n\n'
              'Address: [Dhaka- 1212]\n\n'
              'By using the Railway System App, you agree to this Privacy Policy. Please read it carefully and contact us if you have any questions.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 16),
    );
  }
}