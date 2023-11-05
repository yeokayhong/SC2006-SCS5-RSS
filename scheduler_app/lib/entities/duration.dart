class Duration {
  late int totalDuration;
  late int transitTime;
  late int walkingTime;
  late int waitingTime;

  Duration({
    required this.totalDuration,
    required this.transitTime,
    required this.walkingTime,
    required this.waitingTime,
  });

  static int convertDurationToMin(int duration) {
    return (duration / 60).truncate();
  }

  static String formatDuration(int duration) {
    int minutes = convertDurationToMin(duration);
    int hours = (minutes / 60).truncate();
    minutes = minutes % 60;

    String formattedDuration = "";
    if (hours > 0) {
      formattedDuration += "${hours}h ";
    }
    formattedDuration += "${minutes}m";

    return formattedDuration;
  }

  // consider implementing getter and setters
}
