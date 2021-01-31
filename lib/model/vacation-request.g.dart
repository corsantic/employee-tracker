// GENERATED CODE - DO NOT MODIFY BY HAND i modified  ahaahahahahah

part of 'vacation-request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationRequest _$VacationRequestFromJson(Map<String, dynamic> json) {
  return VacationRequest(
    id: json['id'] as int,
    userId: json['userId'] as int,
    status: VacationStatus.values[json['status']],
    description: json['description'] as String,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
    user: User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VacationRequestToJson(VacationRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': instance.status.index,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'user': instance.user,
    };
