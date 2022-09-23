// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'influItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

influList _$influListFromJson(Map<String, dynamic> json) => influList(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => influItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$influListToJson(influList instance) => <String, dynamic>{
      'list': instance.list,
    };

influItem _$influItemFromJson(Map<String, dynamic> json) => influItem(
      image: json['image'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$influItemToJson(influItem instance) => <String, dynamic>{
      'image': instance.image,
      'name': instance.name,
    };
