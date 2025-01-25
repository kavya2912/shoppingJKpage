import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://your-supabase-url.supabase.co'; // Replace with your Supabase URL
  static const String supabaseAnonKey = 'your-anon-key'; // Replace with your Supabase anon key

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: "https://abzfxumvaxosymrwlyvt.supabase.co",
      anonKey:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiemZ4dW12YXhvc3ltcndseXZ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY3NTQ4MTgsImV4cCI6MjA1MjMzMDgxOH0.RHaiUIFUnd4NusTYpBGNdbWZ76XdgToSt3g8Uw79WpQ",
    );
  }
}
