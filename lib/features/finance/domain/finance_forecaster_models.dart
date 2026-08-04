
class CashFlowForecast {
  final List<ForecastPoint> dailyBalances;
  final List<UpcomingEvent> upcomingEvents;
  final List<ForecastInsight> insights;
  final double currentLiquidity;
  final double predictedEndOfMonthBalance;

  CashFlowForecast({
    required this.dailyBalances,
    required this.upcomingEvents,
    required this.insights,
    required this.currentLiquidity,
    required this.predictedEndOfMonthBalance,
  });
}

class ForecastPoint {
  final DateTime date;
  final double predictedBalance;
  final double confidence;

  ForecastPoint({
    required this.date,
    required this.predictedBalance,
    required this.confidence,
  });
}

class UpcomingEvent {
  final String title;
  final DateTime date;
  final double amount;
  final bool isRecurring;
  final String category;
  final String confidenceReason;

  UpcomingEvent({
    required this.title,
    required this.date,
    required this.amount,
    required this.isRecurring,
    required this.category,
    required this.confidenceReason,
  });
}

class ForecastInsight {
  final String title;
  final String message;
  final String evidence;
  final double confidence;
  final String reasoning;
  final bool isAlert;

  ForecastInsight({
    required this.title,
    required this.message,
    required this.evidence,
    required this.confidence,
    required this.reasoning,
    this.isAlert = false,
  });
}
