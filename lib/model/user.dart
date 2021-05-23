class User{
  String FIRSTNAME;
  String LASTNAME;
  String PHONE;
  String PASSWORD;
  String EMAIL;
  String REFERREDBY;

  User({required this.FIRSTNAME, required this.LASTNAME, required this.PHONE, required this.EMAIL, required this.PASSWORD, required this.REFERREDBY});

  User.fromJson(Map<String, dynamic> json): FIRSTNAME = json['FIRSTNAME'], LASTNAME = json['LASTNAME'], PHONE = json['PHONE'],
  EMAIL = json['EMAIL'], PASSWORD = json['PASSWORD'], REFERREDBY = json['REFERREDBY'];

  Map<String, dynamic> toJson() => {
    "FIRSTNAME": FIRSTNAME,
    "LASTNAME": LASTNAME,
    "PHONE": PHONE,
    "EMAIL": EMAIL,
    "PASSWORD": PASSWORD
  };
}

class Message{
  String message;
  String status;

  Message({required this.message, required this.status});

  Message.fromJson(Map<String, dynamic> json) : message = json['message'], status = json['status'];

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status
  };
}

class Points{
  String EMAIL;
  String TOTALPOINTS;

  Points({required this.EMAIL, required this.TOTALPOINTS});

  Points.fromJson(Map<String, dynamic> json) :  EMAIL = json['EMAIL'], TOTALPOINTS = json['TOTALPOINTS'];

  Map<String, dynamic> toJson() => {
    "EMAIL": EMAIL,
    "TOTALPOINTS": TOTALPOINTS
  };
}

class AllNotifications{
  String EMAIL;
  String NOTIFICATIONS;
  String Date;

  AllNotifications({required this.EMAIL, required this.Date, required this.NOTIFICATIONS});

  AllNotifications.fromJson(Map<String, dynamic> json): EMAIL = json['EMAIL'], NOTIFICATIONS = json['NOTIFICATIONS'], Date = json['DATE'];
}

class AllTransactions{
  String EMAIL;
  String MESSAGE;
  String DATE;

  AllTransactions({required this.EMAIL, required this.DATE, required this.MESSAGE});

  AllTransactions.fromJson(Map<String, dynamic> json): EMAIL = json['EMAIL'], MESSAGE = json['MESSAGE'], DATE = json['DATE'];
}

class RedeemedUsersData{
  String EMAIL;
  String POINTS;

  RedeemedUsersData({required this.EMAIL, required this.POINTS});

  RedeemedUsersData.fromJson(Map<String, dynamic> json) : EMAIL = json['EMAIL'], POINTS = json['POINTS'];

}
