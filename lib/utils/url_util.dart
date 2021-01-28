class UrlUtil {
  static RegExp HTTP_PROTOCOL_REGEX = new RegExp(r'^(http|https)://');

  static String getBaseUrl(String url) {
    return hasProtocolPrefix(url) ? url : 'https://$url';
  }

  static String getIP(String url) {
    return hasProtocolPrefix(url) ? url.replaceAll(HTTP_PROTOCOL_REGEX, '') : url;
  }

  static bool hasProtocolPrefix(String url) {
    return url.startsWith(HTTP_PROTOCOL_REGEX);
  }
}