import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/data/supabase_client_provider.dart';
import 'app/synor_app.dart';
import 'core/notifications/flutter_notification_scheduler.dart';
import 'core/notifications/notification_scheduler.dart';
import 'core/persistence/shared_preferences_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Initialize notifications
  final notificationScheduler = FlutterNotificationScheduler();
  try {
    await notificationScheduler.initialize();
  } catch (e) {
    debugPrint('Notification initialization failed: $e');
  }

  final supabaseConfig = SynorSupabaseConfig.fromEnvironment();
  SupabaseClient? supabaseClient;
  Object? bootstrapError;
  StackTrace? bootstrapStackTrace;
  try {
    supabaseClient = await initializeSynorSupabase(supabaseConfig);
  } catch (error, stackTrace) {
    bootstrapError = error;
    bootstrapStackTrace = stackTrace;
    debugPrint('Synor startup bootstrap failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        synorSupabaseConfigProvider.overrideWithValue(supabaseConfig),
        if (supabaseClient != null)
          supabaseClientProvider.overrideWithValue(supabaseClient),
      ],
      child: SynorApp(
        bootstrapError: bootstrapError,
        bootstrapStackTrace: bootstrapStackTrace,
      ),
    ),
  );
}
