class UnboardingContent{
  String Image;
  String title;
  String description;

  UnboardingContent({required this.description, required this.Image,required this.title });
}
List<UnboardingContent> contents =[
   UnboardingContent(
      title: "Easy and Online Booking",
      description: "  Book your tickets online Secure\n        and fast payment options",
      Image: "assets/trainBackgrong/155555.jpg"),
  UnboardingContent(
      title: "Select Your Train",
      description: "Choose from a variety of trains\n        More options available",
      Image: "assets/trainBackgrong/45454545.png"),
 
  UnboardingContent(
      title: "Quick and Comfortable Journey",
      description: "Experience a comfortable journey\n     with our top-notch services",
      Image: "assets/trainBackgrong/125466.png"),
];