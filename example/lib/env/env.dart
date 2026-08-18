// lib/env/env.dart
import 'dart:io';

abstract class Env {
  static String apiKey = Platform.environment["API_KEY"]!;
  static String model = Platform.environment["AI_MODEL"]!;
}
