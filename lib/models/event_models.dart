class Event {
  String? eventID;
  String? title;
  // String? orgID;
  String? location;
  String? startDate;
  String? endDate;
  String? description;
  bool? studentOnly;
  bool? foodDrinks;
  bool? feeRequired;
  List<String>? tags;



  Event({
    this.title,
    //this.orgID,
    this.location,
    this.startDate,
    this.endDate,
    this.description,
    this.studentOnly,
    this.foodDrinks,
    this.feeRequired,
    this.tags
  });

  factory Event.fromJson(json){
    return Event(
      // Not sure what to put here yet
    );
  } 
}
