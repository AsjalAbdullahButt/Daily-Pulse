"""
Daily Pulse - Main entry point with routing and providers
"""
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_client.dart';
import 'services/chat_service.dart';
import 'services/logs_service.dart';
import 'services/habits_service.dart';
import 'providers/connection_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/logs_provider.dart';
import 'providers/habits_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/running_screen.dart';
import 'screens/habits_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/profile_screen.dart';

void main() => runApp(const DailyPulseApp());

class DailyPulseApp extends StatelessWidget {
  const DailyPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wraps app so connection state is available everywhere.
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiClient()),
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProxyProvider<ApiClient, AuthProvider>(
          create: (_) => AuthProvider(ApiClient()),
          update: (_, api, auth) => auth!,
        ),
        ChangeNotifierProxyProvider<ApiClient, ChatProvider>(
          create: (ctx) => ChatProvider(ChatService(ctx.read<ApiClient>())),
          update: (_, api, chat) {
            chat!._updateService(ChatService(api));
            return chat;
          },
        ),
        ChangeNotifierProxyProvider<ApiClient, LogsProvider>(
          create: (ctx) => LogsProvider(LogsService(ctx.read<ApiClient>())),
          update: (_, api, logs) {
            logs!._updateService(LogsService(api));
            return logs;
          },
        ),
        ChangeNotifierProxyProvider<ApiClient, HabitsProvider>(
          create: (ctx) => HabitsProvider(HabitsService(ctx.read<ApiClient>())),
          update: (_, api, habits) {
            habits!._updateService(HabitsService(api));
            return habits;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Daily Pulse',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/dashboard': (_) => const DashboardScreen(),
          '/chat': (_) => const ChatScreen(),
          '/running': (_) => const RunningScreen(),
          '/habits': (_) => const HabitsScreen(),
          '/insights': (_) => const InsightsScreen(),
          '/profile': (_) => const ProfileScreen(),
        },
      ),
    );
  }
}
