class ApiConfig {
  static const String baseUrl = "http://10.0.2.2:8000/api/v1";

  static String fixUrl(String? url) {
    if (url == null || url.isEmpty) return "";
    return url.replaceFirst("http://localhost:8000", "http://10.0.2.2:8000");
  }
}
