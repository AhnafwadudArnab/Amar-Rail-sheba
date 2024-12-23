class PNR {
  String pnrNumber;
  String passengerName;
  String trainNumber;
  String journeyDate;
  String sourceStation;
  String destinationStation;
  String seatNumber;
  String coachNumber;

  PNR({
    required this.pnrNumber,
    required this.passengerName,
    required this.trainNumber,
    required this.journeyDate,
    required this.sourceStation,
    required this.destinationStation,
    required this.seatNumber,
    required this.coachNumber,
  });

  factory PNR.fromJson(Map<String, dynamic> json) {
    return PNR(
      pnrNumber: json['pnrNumber'],
      passengerName: json['passengerName'],
      trainNumber: json['trainNumber'],
      journeyDate: json['journeyDate'],
      sourceStation: json['sourceStation'],
      destinationStation: json['destinationStation'],
      seatNumber: json['seatNumber'],
      coachNumber: json['coachNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pnrNumber': pnrNumber,
      'passengerName': passengerName,
      'trainNumber': trainNumber,
      'journeyDate': journeyDate,
      'sourceStation': sourceStation,
      'destinationStation': destinationStation,
      'seatNumber': seatNumber,
      'coachNumber': coachNumber,
    };
  }
}