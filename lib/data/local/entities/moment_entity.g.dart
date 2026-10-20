// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetMomentEntityCollection on Isar {
  IsarCollection<MomentEntity> get momentEntitys => this.collection();
}

const MomentEntitySchema = CollectionSchema(
  name: r'MomentEntity',
  id: 9124311753671512954,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdByDeviceId': PropertySchema(
      id: 1,
      name: r'createdByDeviceId',
      type: IsarType.string,
    ),
    r'deletedAt': PropertySchema(
      id: 2,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'dirty': PropertySchema(id: 3, name: r'dirty', type: IsarType.bool),
    r'groupId': PropertySchema(id: 4, name: r'groupId', type: IsarType.string),
    r'lastSyncedAt': PropertySchema(
      id: 5,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'latitude': PropertySchema(
      id: 6,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'localImagePaths': PropertySchema(
      id: 7,
      name: r'localImagePaths',
      type: IsarType.stringList,
    ),
    r'longitude': PropertySchema(
      id: 8,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'placeName': PropertySchema(
      id: 9,
      name: r'placeName',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 10,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'remoteImageUrls': PropertySchema(
      id: 11,
      name: r'remoteImageUrls',
      type: IsarType.stringList,
    ),
    r'text': PropertySchema(id: 12, name: r'text', type: IsarType.string),
    r'uploadProgress': PropertySchema(
      id: 13,
      name: r'uploadProgress',
      type: IsarType.double,
    ),
    r'version': PropertySchema(id: 14, name: r'version', type: IsarType.long),
  },

  estimateSize: _momentEntityEstimateSize,
  serialize: _momentEntitySerialize,
  deserialize: _momentEntityDeserialize,
  deserializeProp: _momentEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
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
    r'dirty': IndexSchema(
      id: 624608328996418504,
      name: r'dirty',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dirty',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _momentEntityGetId,
  getLinks: _momentEntityGetLinks,
  attach: _momentEntityAttach,
  version: '3.4.1',
);

int _momentEntityEstimateSize(
  MomentEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.createdByDeviceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.groupId.length * 3;
  bytesCount += 3 + object.localImagePaths.length * 3;
  {
    for (var i = 0; i < object.localImagePaths.length; i++) {
      final value = object.localImagePaths[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.placeName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.remoteId.length * 3;
  bytesCount += 3 + object.remoteImageUrls.length * 3;
  {
    for (var i = 0; i < object.remoteImageUrls.length; i++) {
      final value = object.remoteImageUrls[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _momentEntitySerialize(
  MomentEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.createdByDeviceId);
  writer.writeDateTime(offsets[2], object.deletedAt);
  writer.writeBool(offsets[3], object.dirty);
  writer.writeString(offsets[4], object.groupId);
  writer.writeDateTime(offsets[5], object.lastSyncedAt);
  writer.writeDouble(offsets[6], object.latitude);
  writer.writeStringList(offsets[7], object.localImagePaths);
  writer.writeDouble(offsets[8], object.longitude);
  writer.writeString(offsets[9], object.placeName);
  writer.writeString(offsets[10], object.remoteId);
  writer.writeStringList(offsets[11], object.remoteImageUrls);
  writer.writeString(offsets[12], object.text);
  writer.writeDouble(offsets[13], object.uploadProgress);
  writer.writeLong(offsets[14], object.version);
}

MomentEntity _momentEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MomentEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.createdByDeviceId = reader.readStringOrNull(offsets[1]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[2]);
  object.dirty = reader.readBool(offsets[3]);
  object.groupId = reader.readString(offsets[4]);
  object.id = id;
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[5]);
  object.latitude = reader.readDoubleOrNull(offsets[6]);
  object.localImagePaths = reader.readStringList(offsets[7]) ?? [];
  object.longitude = reader.readDoubleOrNull(offsets[8]);
  object.placeName = reader.readStringOrNull(offsets[9]);
  object.remoteId = reader.readString(offsets[10]);
  object.remoteImageUrls = reader.readStringList(offsets[11]) ?? [];
  object.text = reader.readStringOrNull(offsets[12]);
  object.uploadProgress = reader.readDouble(offsets[13]);
  object.version = reader.readLong(offsets[14]);
  return object;
}

P _momentEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readStringList(offset) ?? []) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _momentEntityGetId(MomentEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _momentEntityGetLinks(MomentEntity object) {
  return [];
}

void _momentEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  MomentEntity object,
) {
  object.id = id;
}

extension MomentEntityByIndex on IsarCollection<MomentEntity> {
  Future<MomentEntity?> getByRemoteId(String remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  MomentEntity? getByRemoteIdSync(String remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(String remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(String remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<MomentEntity?>> getAllByRemoteId(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<MomentEntity?> getAllByRemoteIdSync(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(MomentEntity object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(MomentEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<MomentEntity> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(
    List<MomentEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension MomentEntityQueryWhereSort
    on QueryBuilder<MomentEntity, MomentEntity, QWhere> {
  QueryBuilder<MomentEntity, MomentEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhere> anyDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dirty'),
      );
    });
  }
}

extension MomentEntityQueryWhere
    on QueryBuilder<MomentEntity, MomentEntity, QWhereClause> {
  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> remoteIdEqualTo(
    String remoteId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'remoteId', value: [remoteId]),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause>
  remoteIdNotEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [],
                upper: [remoteId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [remoteId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [remoteId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'remoteId',
                lower: [],
                upper: [remoteId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> groupIdEqualTo(
    String groupId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'groupId', value: [groupId]),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> groupIdNotEqualTo(
    String groupId,
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> dirtyEqualTo(
    bool dirty,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dirty', value: [dirty]),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterWhereClause> dirtyNotEqualTo(
    bool dirty,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dirty',
                lower: [],
                upper: [dirty],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dirty',
                lower: [dirty],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dirty',
                lower: [dirty],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dirty',
                lower: [],
                upper: [dirty],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension MomentEntityQueryFilter
    on QueryBuilder<MomentEntity, MomentEntity, QFilterCondition> {
  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'createdByDeviceId'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'createdByDeviceId'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'createdByDeviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdByDeviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdByDeviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdByDeviceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'createdByDeviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'createdByDeviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'createdByDeviceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'createdByDeviceId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdByDeviceId', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  createdByDeviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'createdByDeviceId', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'deletedAt'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deletedAt', value: value),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  deletedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deletedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  deletedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deletedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deletedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> dirtyEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dirty', value: value),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  groupIdEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  groupIdGreaterThan(
    String value, {
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  groupIdLessThan(
    String value, {
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  groupIdBetween(
    String lower,
    String upper, {
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'groupId', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'groupId', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSyncedAt'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSyncedAt'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSyncedAt', value: value),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  lastSyncedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSyncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  lastSyncedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSyncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSyncedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'latitude'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  latitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'latitude'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  latitudeEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'latitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  latitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'latitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  latitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'latitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  latitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'latitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localImagePaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localImagePaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localImagePaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localImagePaths',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'localImagePaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'localImagePaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'localImagePaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'localImagePaths',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'localImagePaths', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'localImagePaths', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'localImagePaths', length, true, length, true);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'localImagePaths', 0, true, 0, true);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'localImagePaths', 0, false, 999999, true);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'localImagePaths', 0, true, length, include);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localImagePaths',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  localImagePathsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localImagePaths',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'longitude'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  longitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'longitude'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  longitudeEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'longitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  longitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'longitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  longitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'longitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  longitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'longitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'placeName'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'placeName'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'placeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'placeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'placeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'placeName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'placeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'placeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'placeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'placeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'placeName', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  placeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'placeName', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'remoteId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'remoteId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'remoteId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'remoteId', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'remoteId', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'remoteImageUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'remoteImageUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'remoteImageUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'remoteImageUrls',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'remoteImageUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'remoteImageUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'remoteImageUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'remoteImageUrls',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'remoteImageUrls', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'remoteImageUrls', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'remoteImageUrls', length, true, length, true);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'remoteImageUrls', 0, true, 0, true);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'remoteImageUrls', 0, false, 999999, true);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'remoteImageUrls', 0, true, length, include);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'remoteImageUrls',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  remoteImageUrlsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'remoteImageUrls',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'text'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'text'),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> textEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'text',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  textStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> textContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition> textMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'text',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  uploadProgressEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uploadProgress',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  uploadProgressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uploadProgress',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  uploadProgressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uploadProgress',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  uploadProgressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uploadProgress',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'version', value: value),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  versionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  versionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterFilterCondition>
  versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'version',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MomentEntityQueryObject
    on QueryBuilder<MomentEntity, MomentEntity, QFilterCondition> {}

extension MomentEntityQueryLinks
    on QueryBuilder<MomentEntity, MomentEntity, QFilterCondition> {}

extension MomentEntityQuerySortBy
    on QueryBuilder<MomentEntity, MomentEntity, QSortBy> {
  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  sortByCreatedByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdByDeviceId', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  sortByCreatedByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdByDeviceId', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByPlaceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeName', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByPlaceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeName', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  sortByUploadProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadProgress', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  sortByUploadProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadProgress', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension MomentEntityQuerySortThenBy
    on QueryBuilder<MomentEntity, MomentEntity, QSortThenBy> {
  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  thenByCreatedByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdByDeviceId', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  thenByCreatedByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdByDeviceId', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByPlaceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeName', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByPlaceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeName', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  thenByUploadProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadProgress', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy>
  thenByUploadProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadProgress', Sort.desc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension MomentEntityQueryWhereDistinct
    on QueryBuilder<MomentEntity, MomentEntity, QDistinct> {
  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct>
  distinctByCreatedByDeviceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'createdByDeviceId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dirty');
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByGroupId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct>
  distinctByLocalImagePaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localImagePaths');
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByPlaceName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'placeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByRemoteId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct>
  distinctByRemoteImageUrls() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteImageUrls');
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct>
  distinctByUploadProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uploadProgress');
    });
  }

  QueryBuilder<MomentEntity, MomentEntity, QDistinct> distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension MomentEntityQueryProperty
    on QueryBuilder<MomentEntity, MomentEntity, QQueryProperty> {
  QueryBuilder<MomentEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MomentEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MomentEntity, String?, QQueryOperations>
  createdByDeviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdByDeviceId');
    });
  }

  QueryBuilder<MomentEntity, DateTime?, QQueryOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<MomentEntity, bool, QQueryOperations> dirtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dirty');
    });
  }

  QueryBuilder<MomentEntity, String, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<MomentEntity, DateTime?, QQueryOperations>
  lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<MomentEntity, double?, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<MomentEntity, List<String>, QQueryOperations>
  localImagePathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localImagePaths');
    });
  }

  QueryBuilder<MomentEntity, double?, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<MomentEntity, String?, QQueryOperations> placeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'placeName');
    });
  }

  QueryBuilder<MomentEntity, String, QQueryOperations> remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<MomentEntity, List<String>, QQueryOperations>
  remoteImageUrlsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteImageUrls');
    });
  }

  QueryBuilder<MomentEntity, String?, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<MomentEntity, double, QQueryOperations>
  uploadProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uploadProgress');
    });
  }

  QueryBuilder<MomentEntity, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
