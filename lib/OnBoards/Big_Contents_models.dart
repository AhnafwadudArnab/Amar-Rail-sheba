class UnboardingContent {
  final String image;
  final String title;
  final String description;

  const UnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

const List<UnboardingContent> contents = [
  UnboardingContent(
    title: 'Easy and Online Booking',
    description: 'Book your tickets online with secure and fast payment options.',
    image: 'assets/trainBackgrong/155555.jpg',
  ),
  UnboardingContent(
    title: 'Select Your Train',
    description: 'Choose from a variety of trains and travel classes across Bangladesh.',
    image: 'assets/trainBackgrong/45454545.png',
  ),
  UnboardingContent(
    title: 'Quick and Comfortable Journey',
    description: 'Experience a comfortable journey with real-time tracking and top-notch services.',
    image: 'assets/trainBackgrong/125466.png',
  ),
];