import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:localstorage/localstorage.dart';

import '../../src/notification_screen/data/models/notification_model.dart';
import '../blocs/generic_cubit/generic_cubit.dart';

class NotificationHelper {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static List<NotificationModel> notifications = [];
  static GenericCubit<List<NotificationModel>> notificationsCubit =
      GenericCubit([]);

  static final LocalStorage notificationStorage =
      LocalStorage('notification.json');
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('fCMToken:$fCMToken');
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('firebaseMessagingBackgroundHandler');
    notificationHandler(
        messageId: message.messageId!,
        messageTitle: message.notification!.title!,
        messageBody: message.notification!.body!,
        seen: false);
  }

  static Future<void> foregroundFcm() async {
    FirebaseMessaging.onMessage.listen((event) {
      print('foregroundFcm');
      if (event.notification != null) {
        notificationHandler(
            messageId: event.messageId!,
            messageTitle: event.notification!.title!,
            messageBody: event.notification!.body!,
            seen: false);
      }
    });
  }

  static Future<void> clickOnNotification() async {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('clickOnNotification');
      if (event.notification != null) {
        notificationHandler(
            messageId: event.messageId!,
            messageTitle: event.notification!.title!,
            messageBody: event.notification!.body!,
            seen: false);
      }
    });
  }

  static void notificationHandler({
    required String messageId,
    required String messageTitle,
    required String messageBody,
    required bool seen,
  }) {
    NotificationModel notification = NotificationModel(
      messageId: messageId,
      messageTitle: messageTitle,
      messageBody: messageBody,
      seen: false,
    );
    notificationsCubit.onLoadingState();
    if (!notifications
        .any((element) => element.messageId == notification.messageId)) {
      notifications.add(notification);
      notificationStorage.setItem(
          'notifications',
          notifications.map((item) {
            return item.toJson();
          }).toList());
      notificationsCubit.onUpdateData(notifications);
    }
  }

  static void changeNotificationStatus() {
    notificationsCubit.onLoadingState();
    for (var element in notifications) {
      element.seen = true;
    }
    notificationStorage.setItem(
        'notifications',
        notifications.map((item) {
          return item.toJson();
        }).toList());
    notificationsCubit.onUpdateData(notifications);
  }
}
