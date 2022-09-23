import 'package:json_annotation/json_annotation.dart';

part 'influItem.g.dart';

@JsonSerializable()
class influList {
  List<influItem>? list;

  influList({
    required this.list,
  });

  factory influList.fromJson(Map<String, dynamic> json) =>
      _$influListFromJson(json);

  Map<String, dynamic> toJson() => _$influListToJson(this);
}


@JsonSerializable()
class influItem {
  String? image;
  String? name;

  influItem({
    required this.image,
    required this.name,
  });

  factory influItem.fromJson(Map<String, dynamic> json) =>
      _$influItemFromJson(json);

  Map<String, dynamic> toJson() => _$influItemToJson(this);
}
