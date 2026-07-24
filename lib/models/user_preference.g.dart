// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserPreferenceCollection on Isar {
  IsarCollection<UserPreference> get userPreferences => this.collection();
}

const UserPreferenceSchema = CollectionSchema(
  name: r'UserPreference',
  id: 916664336621196308,
  properties: {
    r'customNoEscape': PropertySchema(
      id: 0,
      name: r'customNoEscape',
      type: IsarType.double,
    ),
    r'customPeaceful': PropertySchema(
      id: 1,
      name: r'customPeaceful',
      type: IsarType.double,
    ),
    r'customReality': PropertySchema(
      id: 2,
      name: r'customReality',
      type: IsarType.double,
    ),
    r'customSomeday': PropertySchema(
      id: 3,
      name: r'customSomeday',
      type: IsarType.double,
    ),
    r'firstLaunchAt': PropertySchema(
      id: 4,
      name: r'firstLaunchAt',
      type: IsarType.dateTime,
    ),
    r'isThresholdsUnlocked': PropertySchema(
      id: 5,
      name: r'isThresholdsUnlocked',
      type: IsarType.bool,
    ),
    r'lastPurchaseId': PropertySchema(
      id: 6,
      name: r'lastPurchaseId',
      type: IsarType.string,
    ),
    r'nudgeShownCountRaw': PropertySchema(
      id: 7,
      name: r'nudgeShownCountRaw',
      type: IsarType.long,
    ),
    r'useCustomThresholds': PropertySchema(
      id: 8,
      name: r'useCustomThresholds',
      type: IsarType.bool,
    )
  },
  estimateSize: _userPreferenceEstimateSize,
  serialize: _userPreferenceSerialize,
  deserialize: _userPreferenceDeserialize,
  deserializeProp: _userPreferenceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userPreferenceGetId,
  getLinks: _userPreferenceGetLinks,
  attach: _userPreferenceAttach,
  version: '3.1.0+1',
);

int _userPreferenceEstimateSize(
  UserPreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lastPurchaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _userPreferenceSerialize(
  UserPreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.customNoEscape);
  writer.writeDouble(offsets[1], object.customPeaceful);
  writer.writeDouble(offsets[2], object.customReality);
  writer.writeDouble(offsets[3], object.customSomeday);
  writer.writeDateTime(offsets[4], object.firstLaunchAt);
  writer.writeBool(offsets[5], object.isThresholdsUnlocked);
  writer.writeString(offsets[6], object.lastPurchaseId);
  writer.writeLong(offsets[7], object.nudgeShownCountRaw);
  writer.writeBool(offsets[8], object.useCustomThresholds);
}

UserPreference _userPreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserPreference();
  object.customNoEscape = reader.readDoubleOrNull(offsets[0]);
  object.customPeaceful = reader.readDoubleOrNull(offsets[1]);
  object.customReality = reader.readDoubleOrNull(offsets[2]);
  object.customSomeday = reader.readDoubleOrNull(offsets[3]);
  object.firstLaunchAt = reader.readDateTimeOrNull(offsets[4]);
  object.id = id;
  object.isThresholdsUnlocked = reader.readBool(offsets[5]);
  object.lastPurchaseId = reader.readStringOrNull(offsets[6]);
  object.nudgeShownCountRaw = reader.readLongOrNull(offsets[7]);
  object.useCustomThresholds = reader.readBool(offsets[8]);
  return object;
}

P _userPreferenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userPreferenceGetId(UserPreference object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userPreferenceGetLinks(UserPreference object) {
  return [];
}

void _userPreferenceAttach(
    IsarCollection<dynamic> col, Id id, UserPreference object) {
  object.id = id;
}

extension UserPreferenceQueryWhereSort
    on QueryBuilder<UserPreference, UserPreference, QWhere> {
  QueryBuilder<UserPreference, UserPreference, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserPreferenceQueryWhere
    on QueryBuilder<UserPreference, UserPreference, QWhereClause> {
  QueryBuilder<UserPreference, UserPreference, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<UserPreference, UserPreference, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserPreferenceQueryFilter
    on QueryBuilder<UserPreference, UserPreference, QFilterCondition> {
  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customNoEscapeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customNoEscape',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customNoEscapeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customNoEscape',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customNoEscapeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customNoEscape',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customNoEscapeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customNoEscape',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customNoEscapeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customNoEscape',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customNoEscapeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customNoEscape',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customPeacefulIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customPeaceful',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customPeacefulIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customPeaceful',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customPeacefulEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customPeaceful',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customPeacefulGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customPeaceful',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customPeacefulLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customPeaceful',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customPeacefulBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customPeaceful',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customRealityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customReality',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customRealityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customReality',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customRealityEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customReality',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customRealityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customReality',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customRealityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customReality',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customRealityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customReality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customSomedayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customSomeday',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customSomedayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customSomeday',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customSomedayEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customSomeday',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customSomedayGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customSomeday',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customSomedayLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customSomeday',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      customSomedayBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customSomeday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      firstLaunchAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstLaunchAt',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      firstLaunchAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firstLaunchAt',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      firstLaunchAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstLaunchAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      firstLaunchAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstLaunchAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      firstLaunchAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstLaunchAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      firstLaunchAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstLaunchAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      isThresholdsUnlockedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isThresholdsUnlocked',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastPurchaseId',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastPurchaseId',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPurchaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastPurchaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastPurchaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastPurchaseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastPurchaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastPurchaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastPurchaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastPurchaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPurchaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      lastPurchaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastPurchaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      nudgeShownCountRawIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nudgeShownCountRaw',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      nudgeShownCountRawIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nudgeShownCountRaw',
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      nudgeShownCountRawEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nudgeShownCountRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      nudgeShownCountRawGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nudgeShownCountRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      nudgeShownCountRawLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nudgeShownCountRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      nudgeShownCountRawBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nudgeShownCountRaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
      useCustomThresholdsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useCustomThresholds',
        value: value,
      ));
    });
  }
}

extension UserPreferenceQueryObject
    on QueryBuilder<UserPreference, UserPreference, QFilterCondition> {}

extension UserPreferenceQueryLinks
    on QueryBuilder<UserPreference, UserPreference, QFilterCondition> {}

extension UserPreferenceQuerySortBy
    on QueryBuilder<UserPreference, UserPreference, QSortBy> {
  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByCustomNoEscape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNoEscape', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByCustomNoEscapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNoEscape', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByCustomPeaceful() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customPeaceful', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByCustomPeacefulDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customPeaceful', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByCustomReality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customReality', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByCustomRealityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customReality', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByCustomSomeday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customSomeday', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByCustomSomedayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customSomeday', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByFirstLaunchAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstLaunchAt', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByFirstLaunchAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstLaunchAt', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByIsThresholdsUnlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isThresholdsUnlocked', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByIsThresholdsUnlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isThresholdsUnlocked', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByLastPurchaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPurchaseId', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByLastPurchaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPurchaseId', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByNudgeShownCountRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nudgeShownCountRaw', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByNudgeShownCountRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nudgeShownCountRaw', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByUseCustomThresholds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useCustomThresholds', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      sortByUseCustomThresholdsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useCustomThresholds', Sort.desc);
    });
  }
}

extension UserPreferenceQuerySortThenBy
    on QueryBuilder<UserPreference, UserPreference, QSortThenBy> {
  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByCustomNoEscape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNoEscape', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByCustomNoEscapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNoEscape', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByCustomPeaceful() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customPeaceful', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByCustomPeacefulDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customPeaceful', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByCustomReality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customReality', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByCustomRealityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customReality', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByCustomSomeday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customSomeday', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByCustomSomedayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customSomeday', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByFirstLaunchAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstLaunchAt', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByFirstLaunchAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstLaunchAt', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByIsThresholdsUnlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isThresholdsUnlocked', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByIsThresholdsUnlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isThresholdsUnlocked', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByLastPurchaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPurchaseId', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByLastPurchaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPurchaseId', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByNudgeShownCountRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nudgeShownCountRaw', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByNudgeShownCountRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nudgeShownCountRaw', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByUseCustomThresholds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useCustomThresholds', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
      thenByUseCustomThresholdsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useCustomThresholds', Sort.desc);
    });
  }
}

extension UserPreferenceQueryWhereDistinct
    on QueryBuilder<UserPreference, UserPreference, QDistinct> {
  QueryBuilder<UserPreference, UserPreference, QDistinct>
      distinctByCustomNoEscape() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customNoEscape');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
      distinctByCustomPeaceful() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customPeaceful');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
      distinctByCustomReality() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customReality');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
      distinctByCustomSomeday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customSomeday');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
      distinctByFirstLaunchAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstLaunchAt');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
      distinctByIsThresholdsUnlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isThresholdsUnlocked');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
      distinctByLastPurchaseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPurchaseId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
      distinctByNudgeShownCountRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nudgeShownCountRaw');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
      distinctByUseCustomThresholds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useCustomThresholds');
    });
  }
}

extension UserPreferenceQueryProperty
    on QueryBuilder<UserPreference, UserPreference, QQueryProperty> {
  QueryBuilder<UserPreference, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserPreference, double?, QQueryOperations>
      customNoEscapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customNoEscape');
    });
  }

  QueryBuilder<UserPreference, double?, QQueryOperations>
      customPeacefulProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customPeaceful');
    });
  }

  QueryBuilder<UserPreference, double?, QQueryOperations>
      customRealityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customReality');
    });
  }

  QueryBuilder<UserPreference, double?, QQueryOperations>
      customSomedayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customSomeday');
    });
  }

  QueryBuilder<UserPreference, DateTime?, QQueryOperations>
      firstLaunchAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstLaunchAt');
    });
  }

  QueryBuilder<UserPreference, bool, QQueryOperations>
      isThresholdsUnlockedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isThresholdsUnlocked');
    });
  }

  QueryBuilder<UserPreference, String?, QQueryOperations>
      lastPurchaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPurchaseId');
    });
  }

  QueryBuilder<UserPreference, int?, QQueryOperations>
      nudgeShownCountRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nudgeShownCountRaw');
    });
  }

  QueryBuilder<UserPreference, bool, QQueryOperations>
      useCustomThresholdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useCustomThresholds');
    });
  }
}
