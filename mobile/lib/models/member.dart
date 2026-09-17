// [S1] Identity, Family & Consent.
class Member {
  const Member({
    required this.id,
    required this.displayName,
    required this.relationshipLabel,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json['id'] as String,
    displayName: (json['displayName'] ?? json['name']) as String,
    relationshipLabel:
        (json['relationshipLabel'] ?? json['relationship'] ?? json['role'] ?? 'Member')
            as String,
  );

  final String id;
  final String displayName;
  final String relationshipLabel;
}
