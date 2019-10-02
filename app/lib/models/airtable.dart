part of models;

class AirtableResponse extends BaseModel {
  final List<AirtableRecord> records;
  AirtableResponse({
    this.records,
  }) : super([records]);

  factory AirtableResponse.fromJson(Map<String, dynamic> res) {
    final List<AirtableRecord> records = List.from(
      res['records'].map(
        (r) => AirtableRecord.fromJson(r),
      ),
    );

    return AirtableResponse(records: records);
  }

  @override
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> recs = records
        .map(
          (r) => r.toJson(),
        )
        .toList();

    return {'records': recs};
  }
}

class AirtableRecord extends BaseModel {
  final String id;
  final DateTime createdTime;
  final AirtableFields fields;
  final bool deleted;

  AirtableRecord({
    this.id,
    this.createdTime,
    this.fields,
    this.deleted,
  }) : super([
          id,
          createdTime,
          fields,
          deleted,
        ]);

  factory AirtableRecord.fromJson(Map<String, dynamic> res) {
    final DateTime createdTime = res['createdTime'] != null
        ? DateTime.tryParse(res['createdTime']) //
        : null;
    final AirtableFields fields = res['fields'] != null
        ? AirtableFields.fromJson(res['fields']) //
        : null;

    return AirtableRecord(
        id: res['id'],
        createdTime: createdTime,
        fields: fields,
        deleted: res['deleted']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'createdTime': createdTime?.toIso8601String(),
        'fields': fields?.toJson(),
      };
}

class AirtableFields extends BaseModel {
  final String userId;
  final Map<String, List> items;
  final DateTime dateCreated;
  final int classCategoryHash;

  AirtableFields({
    this.userId,
    this.items,
    this.dateCreated,
    this.classCategoryHash,
  }) : super([
          userId,
          items,
          dateCreated,
          classCategoryHash,
        ]);

  factory AirtableFields.fromJson(Map<String, dynamic> res) => AirtableFields(
        userId: res['userId'],
        items: res['items'],
        dateCreated: DateTime.tryParse(res['dateCreated']),
        classCategoryHash: res['classCategoryHash'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'items': items,
        'dateCreated': dateCreated.toIso8601String(),
        'classCategoryHash': classCategoryHash,
      };
}
