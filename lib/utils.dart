import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_4/firebase_options.dart';
import 'package:quiz_4/services/auth.dart';
import 'package:quiz_4/services/media.dart';
import 'package:quiz_4/services/storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> setupSupabase() async {
  await Supabase.initialize(
      url: 'https://zrkvgohbukhnexnqupca.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpya3Znb2hidWtobmV4bnF1cGNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU4NTAyMjgsImV4cCI6MjAzMTQyNjIyOH0.2ZAL44rV5924i0u0ZmvsK0SM9ju3FdiN_12MPWgQBFc');
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );

  getIt.registerSingleton<MediaServices>(
    MediaServices(),
  );

  getIt.registerSingleton<StorageService>(
    StorageService(),
  );
}
