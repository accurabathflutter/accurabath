class FCMNotificationRequest {
  String to;
  Notification notification;
  Data data;

  FCMNotificationRequest({this.to, this.notification, this.data});

  FCMNotificationRequest.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to'] = this.to;
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Notification {
  String body;
  String title;

  Notification({this.body, this.title});

  Notification.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    return data;
  }
}

class Data {
  String body;
  String title;
  String clickAction;

  Data({this.body, this.title, this.clickAction});

  Data.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
    clickAction = json['click_action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    data['click_action'] = this.clickAction;
    return data;
  }
}
