import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketCard extends StatelessWidget {
  final double width;
  final double height;
  final Widget header;
  final Widget leftSection;
  final Widget rightSection;
  final Widget rightSectionWithPrice;
  final Widget footer;

  const TicketCard({
    super.key,
    required this.width,
    required this.height,
    required this.header,
    required this.leftSection,
    required this.rightSection,
    required this.rightSectionWithPrice,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const Divider(thickness: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 2, child: leftSection),
                Expanded(flex: 2, child: rightSection),
                Expanded(flex: 1, child: rightSectionWithPrice),
              ],
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          footer,
        ],
      ),
    );
  }
}

class TicketFooter extends StatelessWidget {
  final String qrData;

  const TicketFooter({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 80.0,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "321654687",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class TicketHeader extends StatelessWidget {
  const TicketHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ticket Detail",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("From: Dhaka", style: TextStyle(fontSize: 16)),
            Icon(Icons.train, color: Colors.blue),
            Text("To: B.baria", style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}

class TicketLeftSection extends StatelessWidget {
  const TicketLeftSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("From City: Dhaka"),
        SizedBox(height: 4),
        Text("Date: 24 Aug 2024"),
      ],
    );
  }
}

class TicketRightSection extends StatelessWidget {
  const TicketRightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("To City: Los Angeles"),
        SizedBox(height: 4),
        Text("Time: 12:54"),
      ],
    );
  }
}

class TicketRightSectionWithPrice extends StatelessWidget {
  const TicketRightSectionWithPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Class: Business"),
        SizedBox(height: 4),
        Text("Price: \$682.4"),
      ],
    );
  }
}

class TicketDetailPage extends StatelessWidget {
  const TicketDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/trainBackgrong/rail-min.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Main ticket body
                  const TicketCard(
                    width: double.infinity,
                    height: 350,
                    header: TicketHeader(),
                    leftSection: TicketLeftSection(),
                    rightSection: TicketRightSection(),
                    rightSectionWithPrice: TicketRightSectionWithPrice(),
                    footer:
                        TicketFooter(qrData: "Your QR Code Data Here"),
                  ),
                  const SizedBox(height: 16),
                  // Download button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Action to download the ticket
                    },
                    child: const Text(
                      "Download Ticket",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultipleTicketsPage extends StatelessWidget {
  const MultipleTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/trainBackgrong/rail-min.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // List of tickets
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          3, // Change this to the number of tickets you need
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: TicketCard(
                            width: double.infinity,
                            height: 350,
                            header: TicketHeader(),
                            leftSection: TicketLeftSection(),
                            rightSection: TicketRightSection(),
                            rightSectionWithPrice:
                                TicketRightSectionWithPrice(),
                            footer: TicketFooter(
                                qrData: "Your QR Code Data Here"),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Download button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Action to download the tickets
                    },
                    child: const Text(
                      "Download Tickets",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketPage extends StatelessWidget {
  const TicketPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TicketCard(
                width: 700,
                height: 250,
                header: TicketHeader(),
                leftSection: TicketLeftSection(),
                rightSection: TicketRightSection(),
                rightSectionWithPrice: TicketRightSectionWithPrice(),
                footer: TicketFooter(qrData: "Your QR Code Data Here"),
              ),
              SizedBox(height: 20),
              TicketCard(
                width: 700,
                height: 250,
                header: TicketHeader(),
                leftSection: TicketLeftSection(),
                rightSection: TicketRightSection(),
                rightSectionWithPrice: TicketRightSectionWithPrice(),
                footer: TicketFooter(qrData: "Your QR Code Data Here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
