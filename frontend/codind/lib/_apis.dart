const env = "dev";

String apiRoute = env == "dev" ? "http://192.168.50.75:15234/" : "";

// ignore: constant_identifier_names
const Map<String, String> Apis = {
  "getQR": "qr",
  "getVal": "get?name=",
  "login": "login?"
};
