class AnalysisModel {
  final String summary;
  final String reason;

  AnalysisModel({
    required this.summary,
    required this.reason,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      summary: json['summary'] ?? '',
      reason: json['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'reason': reason,
    };
  }
}
