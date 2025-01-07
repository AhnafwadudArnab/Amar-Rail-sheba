class Train {
  final String trainName;
  final String departureCity;
  final String arrivalCity;
  final String departureTime;
  final String arrivalTime;
  final String duration;

  Train({
    required this.trainName,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      trainName: json['train_name'],
      departureCity: json['departure_city'],
      arrivalCity: json['arrival_city'],
      departureTime: json['departure_time'],
      arrivalTime: json['arrival_time'],
      duration: json['duration'],
    );
  }
}


