class BookedList{
  //"bookedTeacher"=>$row[0], "bookedBranch"=>$row[1], "bookedStartDate"=>$row[2],
  // "bookedEndDate" => $row[3], "status" => $row[4]

  String bookedTeacher;
  String bookedBranch;
  String bookedStartDate;
  String bookedEndDate;
  String status;

  BookedList({this.bookedTeacher, this.bookedBranch, this.bookedStartDate,
      this.bookedEndDate, this.status});

  factory BookedList.fromJson(Map<String, dynamic> json){
    return BookedList(
      bookedTeacher: json['bookedTeacher'],
      bookedBranch: json['bookedBranch'],
      bookedStartDate: json['bookedStartDate'],
      bookedEndDate: json['bookedEndDate'],
      status: json['status']
    );
  }
}
