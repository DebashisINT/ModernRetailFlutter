class AppMessage {
  static final AppMessage _instance = AppMessage._internal();
  factory AppMessage() {
    return _instance;
  }
  AppMessage._internal();

  final String wrong = "Something went wrong.";
  final String no_internet = "Please connect to internet.";

}