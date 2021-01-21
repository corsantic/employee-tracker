// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation-request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationRequest _$VacationRequestFromJson(Map<String, dynamic> json) {
  return VacationRequest(
    id: json['id'] as int,
    userId: json['userId'] as int,
    status: _$enumDecode(_$VacationStatusEnumMap, json['status']),
    description: json['description'] as String,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
  );
}

Map<String, dynamic> _$VacationRequestToJson(VacationRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': _$VacationStatusEnumMap[instance.status],
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$VacationStatusEnumMap = {
  VacationStatus.none: 'none',
  VacationStatus.InProgress: 'InProgress',
  VacationStatus.Approved: 'Approved',
  VacationStatus.Declined: 'Declined',
};
