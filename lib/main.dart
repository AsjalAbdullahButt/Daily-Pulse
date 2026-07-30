// Daily Pulse - Main entry point with routing and providers
// Starts with SplashScreen, then HomeShell
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
import 'screens/splash_screen.dart';
import 'screens/home_shell.dart';

void main() => runApp(const DailyPulseApp());

class DailyPulseApp extends StatelessWidget {
  const DailyPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          update: (_, api, chat) => chat!,
        ),
        ChangeNotifierProxyProvider<ApiClient, LogsProvider>(
          create: (ctx) => LogsProvider(LogsService(ctx.read<ApiClient>())),
          update: (_, api, logs) => logs!,
        ),
        ChangeNotifierProxyProvider<ApiClient, HabitsProvider>(
          create: (ctx) => HabitsProvider(HabitsService(ctx.read<ApiClient>())),
          update: (_, api, habits) => habits!,
        ),
      ],
      child: MaterialApp(
        title: 'Daily Pulse',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/home': (_) => const HomeShell(),
        },
      ),
    );
  }
}
