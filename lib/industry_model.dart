class IndustryModel {
  final String sector;
  final String industry;
  final String ticker;
  final double score;

  IndustryModel({
    required this.sector,
    required this.industry,
    required this.ticker,
    required this.score,
  });

  factory IndustryModel.fromJson(Map<String, dynamic> json) {
    return IndustryModel(
      sector: json['sector'],
      industry: json['industry'],
      ticker: json['ticker'],
      score: json['score'].toDouble(),
    );
  }
}
/// Find[IndustryInfo]: /lib/dash_bot/model/industry_info.dart