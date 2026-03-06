import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/notification_service.dart';

class ReminderProvider extends ChangeNotifier {
  static const String _reminderKey = "daily_reminder";

  bool _isReminderActive = false;
  String? _errorMessage;

  bool get isReminderActive => _isReminderActive;
  String? get errorMessage => _errorMessage;

  ReminderProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadReminder();
    await _initializeNotificationService();
  }

  Future<void> _initializeNotificationService() async {
    try {
      await NotificationService.init();
    } catch (e) {
      _errorMessage = 'Gagal menginisialisasi notifikasi: $e';
      debugPrint('Error initializing notification service: $e');
    }
  }

  Future<void> toggleReminder(bool value) async {
    if (_isReminderActive == value) return;

    _isReminderActive = value;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_reminderKey, value);

      if (value) {
        await NotificationService.scheduleDailyReminder();
        debugPrint('Daily reminder diaktifkan');
      } else {
        await NotificationService.cancelReminder();
        debugPrint('Daily reminder dimatikan');
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Gagal mengubah status reminder: $e';
      debugPrint('Error toggling reminder: $e');

      _isReminderActive = !value;
      notifyListeners();
    }
  }

  Future<void> _loadReminder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedValue = prefs.getBool(_reminderKey) ?? false;

      _isReminderActive = savedValue;

      if (_isReminderActive) {
        try {
          await NotificationService.scheduleDailyReminder();
          debugPrint('Daily reminder dijadwalkan ulang saat load');
        } catch (e) {
          _errorMessage = 'Gagal menjadwalkan reminder: $e';
          debugPrint('Error scheduling reminder on load: $e');
        }
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat status reminder: $e';
      debugPrint('Error loading reminder: $e');
    }
  }

  Future<bool> getReminderStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_reminderKey) ?? false;
    } catch (e) {
      debugPrint('Error getting reminder status: $e');
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> checkAndRescheduleReminder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isActive = prefs.getBool(_reminderKey) ?? false;

      if (isActive && !_isReminderActive) {
        _isReminderActive = true;
        await NotificationService.scheduleDailyReminder();
        notifyListeners();
        debugPrint('Reminder disinkronkan dan dijadwalkan ulang');
      } else if (isActive && _isReminderActive) {
        await NotificationService.scheduleDailyReminder();
        debugPrint('Reminder dipastikan terjadwal');
      }
    } catch (e) {
      debugPrint('Error checking and rescheduling reminder: $e');
    }
  }

  Future<void> updateReminderTime({
    required int hour,
    required int minute,
  }) async {
    if (!_isReminderActive) return;

    try {
      await NotificationService.scheduleCustomReminder(
        id: 0,
        title: 'Lunch Reminder 🍽️',
        body:
            'Sudah jam ${_formatTime(hour, minute)}! Jangan lupa makan siang ya 😊',
        hour: hour,
        minute: minute,
      );
      debugPrint('Waktu reminder diupdate ke $hour:$minute');
    } catch (e) {
      _errorMessage = 'Gagal mengupdate waktu reminder: $e';
      debugPrint('Error updating reminder time: $e');
      notifyListeners();
    }
  }

  String _formatTime(int hour, int minute) {
    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour > 12 ? hour - 12 : hour;
    displayHour = displayHour == 0 ? 12 : displayHour;
    String displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  String getUserFriendlyErrorMessage() {
    if (_errorMessage == null) return '';

    if (_errorMessage!.contains('notification_sound')) {
      return 'File suara notifikasi tidak ditemukan. Pastikan file notification_sound sudah ditambahkan ke folder android/app/src/main/res/raw/';
    } else if (_errorMessage!.contains('permission')) {
      return 'Izin notifikasi tidak diberikan. Silakan berikan izin di pengaturan.';
    } else {
      return 'Terjadi kesalahan: $_errorMessage';
    }
  }
}
