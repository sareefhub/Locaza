class ApiConfig {
  static const String baseUrl = "http://10.0.2.2:8000/api/v1";
  static const String hostUrl = "http://10.0.2.2:8000";

  static String fixUrl(String? url) {
    if (url == null || url.isEmpty) return "";
    if (url.startsWith("/")) {
      return "$hostUrl$url";
    }
    return url.replaceFirst("http://localhost:8000", hostUrl);
  }
}
