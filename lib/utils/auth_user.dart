import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseURL = "http://13.203.231.29:5000";

class AuthUser {

  /// ==============================
  /// GET STORED USER DATA
  /// ==============================
  Future<Map<String, dynamic>?> getMemberData() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('user_data');

    if (stored != null) {
      return jsonDecode(stored);
    }
    return null;
  }

  /// ==============================
  /// GET TOKEN FROM STORAGE
  /// ==============================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// ==============================
  /// MAIN API CALL FUNCTION
  /// ==============================
  Future<dynamic> callApi({
    required String method,
    required String api,
    Map<String, dynamic> data = const {},
    Function(double progress)? onUploadProgress,
  }) async {

    final memberData = await getMemberData();
    final token = await getToken();

    Map<String, String> defaultHeaders = {};
    Map<String, dynamic> finalData = {...data};
    Map<String, dynamic> queryParams = {};

    /// ==============================
    /// ADD AUTH HEADER IF TOKEN EXISTS
    /// ==============================
    if (token != null && token.isNotEmpty) {
      defaultHeaders["Authorization"] = "Bearer $token";
    }

    /// ==============================
    /// OPTIONAL USER ID IN QUERY PARAM
    /// ==============================
    if (memberData != null && memberData["id"] != null) {
      queryParams = {
        "user_id": memberData["id"].toString(),
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_id", memberData["id"].toString());
    }

    /// ==============================
    /// BUILD FINAL URL
    /// ==============================
    final Uri finalURL =
        Uri.parse("$baseURL$api").replace(queryParameters: {
      ...queryParams,
      if (method == "GET") ...finalData,
    }.map((key, value) => MapEntry(key, value.toString())));

    try {
      http.Response response;

      switch (method) {

        case "GET":
          response = await http.get(
            finalURL,
            headers: {
              ...defaultHeaders,
              "Content-Type": "application/json",
            },
          );
          break;

        case "POST":
          response = await http.post(
            finalURL,
            headers: {
              ...defaultHeaders,
              "Content-Type": "application/json",
            },
            body: jsonEncode(finalData),
          );
          break;

        case "CUSTOM_POST":
          var request = http.MultipartRequest("POST", finalURL);
          request.headers.addAll(defaultHeaders);

          for (var key in finalData.keys) {
            request.fields[key] = finalData[key].toString();
          }

          var streamedResponse = await request.send();

          if (onUploadProgress != null) {
            streamedResponse.stream.listen((_) {
              onUploadProgress(1.0);
            });
          }

          response = await http.Response.fromStream(streamedResponse);
          break;

        case "DELETE":
          response = await http.delete(
            finalURL,
            headers: {
              ...defaultHeaders,
              "Content-Type": "application/json",
            },
          );
          break;

        default:
          throw Exception("Unsupported HTTP method");
      }

      print("========== API DEBUG ==========");
      print("URL: $finalURL");
      print("Method: $method");
      print("Request Body: $finalData");
      print("Headers: $defaultHeaders");
      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");
      print("================================");

      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Empty response from server"};
      }

    } catch (error) {
      print("API call failed: $error");
      return {"error": error.toString()};
    }
  }
}
