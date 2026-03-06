import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';
import '../../provider/reminder_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final reminderProvider = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable dark theme"),
            value: themeProvider.isDarkTheme,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme(value);
            },
          ),

          const Divider(),

          SwitchListTile(
            title: const Text("Daily Lunch Reminder"),
            subtitle: const Text("Notification at 11:00 AM"),
            value: reminderProvider.isReminderActive,
            onChanged: (value) {
              context.read<ReminderProvider>().toggleReminder(value);
            },
          ),
        ],
      ),
    );
  }
}
