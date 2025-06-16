import 'dart:convert';
import 'package:http/http.dart' as http;

const String oneSignalAppId = "YOUR_ONESIGNAL_APP_ID";
const String oneSignalRestApiKey = "YOUR_ONESIGNAL_REST_API_KEY";

Future<void> sendPushNotification({
  required String userId,
  required String templateId,
  required DateTime scheduledTime,
}) async {
  // Convert time to UTC format
  String scheduledTimeUtc = scheduledTime.toUtc().toIso8601String();

  // OneSignal API Endpoint
  const String oneSignalUrl = "https://onesignal.com/api/v1/notifications";

  // Headers
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Basic $oneSignalRestApiKey",
  };

  // Request Body
  Map<String, dynamic> body = {
    "app_id": oneSignalAppId,
    "include_external_user_ids": [userId],
    "template_id": templateId,
    "send_after": scheduledTimeUtc,
  };

  try {
    // Send HTTP request
    final response = await http.post(
      Uri.parse(oneSignalUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    // Handle response
    if (response.statusCode == 200) {
      print("✅ Notification scheduled successfully!");
    } else {
      print("❌ Failed to schedule notification: ${response.body}");
    }
  } catch (e) {
    print("❌ Error sending notification: $e");
  }
}