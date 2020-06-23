class AvailableTime {
  String availableTime;

  AvailableTime({this.availableTime});

  factory AvailableTime.fromJson(Map<String, dynamic> json){
    return AvailableTime(
        availableTime : json['regular_Time']
    );
  }
}