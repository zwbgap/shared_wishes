// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetDeviceEntityCollection on Isar {
  IsarCollection<DeviceEntity> get deviceEntitys => this.collection();
}

const DeviceEntitySchema = CollectionSchema(
  name: r'DeviceEntity',
  id: 6626679775157521336,
  properties: {
    r'avatarEmoji': PropertySchema(
      id: 0,
      name: r'avatarEmoji',
      type: IsarType.string,
    ),
    r'deviceId': PropertySchema(
      id: 1,
      name: r'deviceId',
      type: IsarType.string,
    ),
    r'groupId': PropertySchema(id: 2, name: r'groupId', type: IsarType.string),
    r'isMe': PropertySchema(id: 3, name: r'isMe', type: IsarType.bool),
    r'lastActiveAt': PropertySchema(
      id: 4,
      name: r'lastActiveAt',
      type: IsarType.dateTime,
    ),
    r'modelName': PropertySchema(
      id: 5,
      name: r'modelName',
      type: IsarType.string,
    ),
    r'nickname': PropertySchema(
      id: 6,
      name: r'nickname',
      type: IsarType.string,
    ),
    r'platform': PropertySchema(
      id: 7,
      name: r'platform',
      type: IsarType.string,
    ),
  },

  estimateSize: _deviceEntityEstimateSize,
  serialize: _deviceEntitySerialize,
  deserialize: _deviceEntityDeserialize,
  deserializeProp: _deviceEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'deviceId': IndexSchema(
      id: 4442814072367132509,
      name: r'deviceId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'deviceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'groupId': IndexSchema(
      id: -8523216633229774932,
      name: r'groupId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'groupId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _deviceEntityGetId,
  getLinks: _deviceEntityGetLinks,
  attach: _deviceEntityAttach,
  version: '3.4.1',
);

int _deviceEntityEstimateSize(
  DeviceEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.avatarEmoji;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.deviceId.length * 3;
  {
    final value = object.groupId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.modelName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nickname;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.platform;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _deviceEntitySerialize(
  DeviceEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.avatarEmoji);
  writer.writeString(offsets[1], object.deviceId);
  writer.writeString(offsets[2], object.groupId);
  writer.writeBool(offsets[3], object.isMe);
  writer.writeDateTime(offsets[4], object.lastActiveAt);
  writer.writeString(offsets[5], object.modelName);
  writer.writeString(offsets[6], object.nickname);
  writer.writeString(offsets[7], object.platform);
}

DeviceEntity _deviceEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DeviceEntity();
  object.avatarEmoji = reader.readStringOrNull(offsets[0]);
  object.deviceId = reader.readString(offsets[1]);
  object.groupId = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.isMe = reader.readBool(offsets[3]);
  object.lastActiveAt = reader.readDateTimeOrNull(offsets[4]);
  object.modelName = reader.readStringOrNull(offsets[5]);
  object.nickname = reader.readStringOrNull(offsets[6]);
  object.platform = reader.readStringOrNull(offsets[7]);
  return object;
}

P _deviceEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _deviceEntityGetId(DeviceEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _deviceEntityGetLinks(DeviceEntity object) {
  return [];
}

void _deviceEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  DeviceEntity object,
) {
  object.id = id;
}

extension DeviceEntityByIndex on IsarCollection<DeviceEntity> {
  Future<DeviceEntity?> getByDeviceId(String deviceId) {
    return getByIndex(r'deviceId', [deviceId]);
  }

  DeviceEntity? getByDeviceIdSync(String deviceId) {
    return getByIndexSync(r'deviceId', [deviceId]);
  }

  Future<bool> deleteByDeviceId(String deviceId) {
    return deleteByIndex(r'deviceId', [deviceId]);
  }

  bool deleteByDeviceIdSync(String deviceId) {
    return deleteByIndexSync(r'deviceId', [deviceId]);
  }

  Future<List<DeviceEntity?>> getAllByDeviceId(List<String> deviceIdValues) {
    final values = deviceIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'deviceId', values);
  }

  List<DeviceEntity?> getAllByDeviceIdSync(List<String> deviceIdValues) {
    final values = deviceIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'deviceId', values);
  }

  Future<int> deleteAllByDeviceId(List<String> deviceIdValues) {
    final values = deviceIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'deviceId', values);
  }

  int deleteAllByDeviceIdSync(List<String> deviceIdValues) {
    final values = deviceIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'deviceId', values);
  }

  Future<Id> putByDeviceId(DeviceEntity object) {
    return putByIndex(r'deviceId', object);
  }

  Id putByDeviceIdSync(DeviceEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'deviceId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDeviceId(List<DeviceEntity> objects) {
    return putAllByIndex(r'deviceId', objects);
  }

  List<Id> putAllByDeviceIdSync(
    List<DeviceEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'deviceId', objects, saveLinks: saveLinks);
  }
}

extension DeviceEntityQueryWhereSort
    on QueryBuilder<DeviceEntity, DeviceEntity, QWhere> {
  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DeviceEntityQueryWhere
    on QueryBuilder<DeviceEntity, DeviceEntity, QWhereClause> {
  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause> deviceIdEqualTo(
    String deviceId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'deviceId', value: [deviceId]),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause>
  deviceIdNotEqualTo(String deviceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId',
                lower: [],
                upper: [deviceId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId',
                lower: [deviceId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId',
                lower: [deviceId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deviceId',
                lower: [],
                upper: [deviceId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause> groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'groupId', value: [null]),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause>
  groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'groupId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause> groupIdEqualTo(
    String? groupId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'groupId', value: [groupId]),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterWhereClause> groupIdNotEqualTo(
    String? groupId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'groupId',
                lower: [],
                upper: [groupId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'groupId',
                lower: [groupId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'groupId',
                lower: [groupId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'groupId',
                lower: [],
                upper: [groupId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DeviceEntityQueryFilter
    on QueryBuilder<DeviceEntity, DeviceEntity, QFilterCondition> {
  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'avatarEmoji'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'avatarEmoji'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'avatarEmoji',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'avatarEmoji',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'avatarEmoji',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'avatarEmoji',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'avatarEmoji',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'avatarEmoji',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'avatarEmoji',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'avatarEmoji',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'avatarEmoji', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  avatarEmojiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'avatarEmoji', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deviceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'deviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'deviceId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deviceId', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  deviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'deviceId', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'groupId'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'groupId'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'groupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'groupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'groupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'groupId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'groupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'groupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'groupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'groupId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'groupId', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'groupId', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition> isMeEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isMe', value: value),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  lastActiveAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastActiveAt'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  lastActiveAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastActiveAt'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  lastActiveAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastActiveAt', value: value),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  lastActiveAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastActiveAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  lastActiveAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastActiveAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  lastActiveAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastActiveAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'modelName'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'modelName'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'modelName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'modelName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'modelName', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  modelNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'modelName', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nickname'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nickname'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nickname',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nickname',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nickname', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  nicknameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nickname', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'platform'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'platform'),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'platform',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'platform',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'platform', value: ''),
      );
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterFilterCondition>
  platformIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'platform', value: ''),
      );
    });
  }
}

extension DeviceEntityQueryObject
    on QueryBuilder<DeviceEntity, DeviceEntity, QFilterCondition> {}

extension DeviceEntityQueryLinks
    on QueryBuilder<DeviceEntity, DeviceEntity, QFilterCondition> {}

extension DeviceEntityQuerySortBy
    on QueryBuilder<DeviceEntity, DeviceEntity, QSortBy> {
  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByAvatarEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarEmoji', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy>
  sortByAvatarEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarEmoji', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByIsMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMe', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByIsMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMe', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByLastActiveAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveAt', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy>
  sortByLastActiveAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveAt', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByModelName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByModelNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> sortByPlatformDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.desc);
    });
  }
}

extension DeviceEntityQuerySortThenBy
    on QueryBuilder<DeviceEntity, DeviceEntity, QSortThenBy> {
  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByAvatarEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarEmoji', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy>
  thenByAvatarEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarEmoji', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByIsMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMe', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByIsMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMe', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByLastActiveAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveAt', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy>
  thenByLastActiveAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveAt', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByModelName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByModelNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.asc);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QAfterSortBy> thenByPlatformDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.desc);
    });
  }
}

extension DeviceEntityQueryWhereDistinct
    on QueryBuilder<DeviceEntity, DeviceEntity, QDistinct> {
  QueryBuilder<DeviceEntity, DeviceEntity, QDistinct> distinctByAvatarEmoji({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarEmoji', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QDistinct> distinctByDeviceId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QDistinct> distinctByGroupId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QDistinct> distinctByIsMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMe');
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QDistinct> distinctByLastActiveAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastActiveAt');
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QDistinct> distinctByModelName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QDistinct> distinctByNickname({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nickname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DeviceEntity, DeviceEntity, QDistinct> distinctByPlatform({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platform', caseSensitive: caseSensitive);
    });
  }
}

extension DeviceEntityQueryProperty
    on QueryBuilder<DeviceEntity, DeviceEntity, QQueryProperty> {
  QueryBuilder<DeviceEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DeviceEntity, String?, QQueryOperations> avatarEmojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarEmoji');
    });
  }

  QueryBuilder<DeviceEntity, String, QQueryOperations> deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceId');
    });
  }

  QueryBuilder<DeviceEntity, String?, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<DeviceEntity, bool, QQueryOperations> isMeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMe');
    });
  }

  QueryBuilder<DeviceEntity, DateTime?, QQueryOperations>
  lastActiveAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastActiveAt');
    });
  }

  QueryBuilder<DeviceEntity, String?, QQueryOperations> modelNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelName');
    });
  }

  QueryBuilder<DeviceEntity, String?, QQueryOperations> nicknameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nickname');
    });
  }

  QueryBuilder<DeviceEntity, String?, QQueryOperations> platformProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platform');
    });
  }
}
