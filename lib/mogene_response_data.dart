/// [MogeneResponse] is a class that represents the response of the Mogene API.
class MogeneResponseData {
  final String? comment;
  final List<RelatedIndustry>? relatedIndustry;

  MogeneResponseData({ this.comment, this.relatedIndustry});

  factory MogeneResponseData.fromJson(Map<String, dynamic> json) => MogeneResponseData(
    comment: json['comment'],
    relatedIndustry: (json['related_sectors'] as List) // 추후 related_sector -> related_industry 변경 필요
        .map((i) => RelatedIndustry.fromJson(i))
        .toList(),
  );
}


/// [RelatedIndustry] is a class that represents the related industry by user message.
class RelatedIndustry {
  final String industry;
  final String summary;

  RelatedIndustry({required this.industry, required this.summary});

  factory RelatedIndustry.fromJson(Map<String, dynamic> json) => RelatedIndustry(
    industry: json['sector'], // 우쒸.. json['sector'] -> json['industry'] 변경 필요
    summary: json['summary'],
  );
}
/// Find[MogeneResponseData]: /lib/dash_bot/model/mogene_response_model.dart