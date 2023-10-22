class Duration {
  late int totalDuration;
  late int transitTime;
  late int walkingTime;
  late int waitingTime;

  Duration({
    required String totalDuration,
    required String transitTime,
    required String walkingTime,
    required String waitingTime,
  }) {
    this.totalDuration = int.parse(totalDuration);
    this.transitTime = int.parse(transitTime);
    this.walkingTime = int.parse(walkingTime);
    this.waitingTime = int.parse(waitingTime);
  }

  static int convertDurationToMin(int duration) {
    return (duration / 60).truncate();
  }

  // consider implementing getter and setters
}
