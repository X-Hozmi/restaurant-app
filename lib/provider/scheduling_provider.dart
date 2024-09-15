import 'dart:developer';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/date_time_helper.dart';
import 'package:flutter/material.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      log('Penjadwalan Restoran Aktif');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(
          hours: 24,
        ),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      log('Penjadwalan Restoran Dibatalkan');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
