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

  // consider implementing getter and setters
}
