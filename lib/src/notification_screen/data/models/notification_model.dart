class NotificationModel {
  String? messageId;
  String? messageTitle;
  String? messageBody;
  bool? seen;
  NotificationModel({
    this.messageId,
    this.messageTitle,
    this.messageBody,
    this.seen,
  });
  toJson() {
    Map<String, dynamic> data = {};

    data['messageId'] = messageId;
    data['messageTitle'] = messageTitle;
    data['messageBody'] = messageBody;
    data['seen'] = seen;

    return data;
  }
}
