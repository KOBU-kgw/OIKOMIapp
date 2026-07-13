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
    r'isPremiumActive': PropertySchema(
      id: 0,
      name: r'isPremiumActive',
      type: IsarType.bool,
    ),
    r'lastPremiumCheckAt': PropertySchema(
      id: 1,
      name: r'lastPremiumCheckAt',
      type: IsarType.dateTime,
    ),
    r'lastPurchaseId': PropertySchema(
      id: 2,
      name: r'lastPurchaseId',
      type: IsarType.string,
    ),
    r'subscriptionExpiryDate': PropertySchema(
      id: 3,
      name: r'subscriptionExpiryDate',
      type: IsarType.dateTime,
    ),
    r'thresholdNoEscape': PropertySchema(
      id: 4,
      name: r'thresholdNoEscape',
      type: IsarType.double,
    ),
    r'thresholdPeaceful': PropertySchema(
      id: 5,
      name: r'thresholdPeaceful',
      type: IsarType.double,
    ),
    r'thresholdReality': PropertySchema(
      id: 6,
      name: r'thresholdReality',
      type: IsarType.double,
    ),
    r'thresholdSomeday': PropertySchema(
      id: 7,
      name: r'thresholdSomeday',
      type: IsarType.double,
    ),
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
  version: '3.3.2',
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
  writer.writeBool(offsets[0], object.isPremiumActive);
  writer.writeDateTime(offsets[1], object.lastPremiumCheckAt);
  writer.writeString(offsets[2], object.lastPurchaseId);
  writer.writeDateTime(offsets[3], object.subscriptionExpiryDate);
  writer.writeDouble(offsets[4], object.thresholdNoEscape);
  writer.writeDouble(offsets[5], object.thresholdPeaceful);
  writer.writeDouble(offsets[6], object.thresholdReality);
  writer.writeDouble(offsets[7], object.thresholdSomeday);
}

UserPreference _userPreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserPreference();
  object.id = id;
  object.isPremiumActive = reader.readBool(offsets[0]);
  object.lastPremiumCheckAt = reader.readDateTimeOrNull(offsets[1]);
  object.lastPurchaseId = reader.readStringOrNull(offsets[2]);
  object.subscriptionExpiryDate = reader.readDateTimeOrNull(offsets[3]);
  object.thresholdNoEscape = reader.readDoubleOrNull(offsets[4]);
  object.thresholdPeaceful = reader.readDoubleOrNull(offsets[5]);
  object.thresholdReality = reader.readDoubleOrNull(offsets[6]);
  object.thresholdSomeday = reader.readDoubleOrNull(offsets[7]);
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
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
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
  IsarCollection<dynamic> col,
  Id id,
  UserPreference object,
) {
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
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<UserPreference, UserPreference, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
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
}

extension UserPreferenceQueryFilter
    on QueryBuilder<UserPreference, UserPreference, QFilterCondition> {
  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  isPremiumActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isPremiumActive', value: value),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPremiumCheckAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastPremiumCheckAt'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPremiumCheckAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastPremiumCheckAt'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPremiumCheckAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastPremiumCheckAt', value: value),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPremiumCheckAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastPremiumCheckAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPremiumCheckAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastPremiumCheckAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPremiumCheckAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastPremiumCheckAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastPurchaseId'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastPurchaseId'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastPurchaseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastPurchaseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastPurchaseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastPurchaseId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastPurchaseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastPurchaseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastPurchaseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastPurchaseId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastPurchaseId', value: ''),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  lastPurchaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lastPurchaseId', value: ''),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  subscriptionExpiryDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'subscriptionExpiryDate'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  subscriptionExpiryDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'subscriptionExpiryDate'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  subscriptionExpiryDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'subscriptionExpiryDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  subscriptionExpiryDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'subscriptionExpiryDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  subscriptionExpiryDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'subscriptionExpiryDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  subscriptionExpiryDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'subscriptionExpiryDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdNoEscapeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'thresholdNoEscape'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdNoEscapeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'thresholdNoEscape'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdNoEscapeEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'thresholdNoEscape',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdNoEscapeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'thresholdNoEscape',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdNoEscapeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'thresholdNoEscape',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdNoEscapeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'thresholdNoEscape',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdPeacefulIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'thresholdPeaceful'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdPeacefulIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'thresholdPeaceful'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdPeacefulEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'thresholdPeaceful',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdPeacefulGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'thresholdPeaceful',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdPeacefulLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'thresholdPeaceful',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdPeacefulBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'thresholdPeaceful',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdRealityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'thresholdReality'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdRealityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'thresholdReality'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdRealityEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'thresholdReality',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdRealityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'thresholdReality',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdRealityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'thresholdReality',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdRealityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'thresholdReality',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdSomedayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'thresholdSomeday'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdSomedayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'thresholdSomeday'),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdSomedayEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'thresholdSomeday',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdSomedayGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'thresholdSomeday',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdSomedayLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'thresholdSomeday',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterFilterCondition>
  thresholdSomedayBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'thresholdSomeday',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
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
  sortByIsPremiumActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremiumActive', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByIsPremiumActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremiumActive', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByLastPremiumCheckAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPremiumCheckAt', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByLastPremiumCheckAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPremiumCheckAt', Sort.desc);
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
  sortBySubscriptionExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionExpiryDate', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortBySubscriptionExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionExpiryDate', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByThresholdNoEscape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdNoEscape', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByThresholdNoEscapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdNoEscape', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByThresholdPeaceful() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdPeaceful', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByThresholdPeacefulDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdPeaceful', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByThresholdReality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdReality', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByThresholdRealityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdReality', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByThresholdSomeday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdSomeday', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  sortByThresholdSomedayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdSomeday', Sort.desc);
    });
  }
}

extension UserPreferenceQuerySortThenBy
    on QueryBuilder<UserPreference, UserPreference, QSortThenBy> {
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
  thenByIsPremiumActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremiumActive', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByIsPremiumActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPremiumActive', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByLastPremiumCheckAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPremiumCheckAt', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByLastPremiumCheckAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPremiumCheckAt', Sort.desc);
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
  thenBySubscriptionExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionExpiryDate', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenBySubscriptionExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionExpiryDate', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByThresholdNoEscape() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdNoEscape', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByThresholdNoEscapeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdNoEscape', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByThresholdPeaceful() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdPeaceful', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByThresholdPeacefulDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdPeaceful', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByThresholdReality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdReality', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByThresholdRealityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdReality', Sort.desc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByThresholdSomeday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdSomeday', Sort.asc);
    });
  }

  QueryBuilder<UserPreference, UserPreference, QAfterSortBy>
  thenByThresholdSomedayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thresholdSomeday', Sort.desc);
    });
  }
}

extension UserPreferenceQueryWhereDistinct
    on QueryBuilder<UserPreference, UserPreference, QDistinct> {
  QueryBuilder<UserPreference, UserPreference, QDistinct>
  distinctByIsPremiumActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPremiumActive');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
  distinctByLastPremiumCheckAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPremiumCheckAt');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
  distinctByLastPurchaseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastPurchaseId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
  distinctBySubscriptionExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionExpiryDate');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
  distinctByThresholdNoEscape() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thresholdNoEscape');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
  distinctByThresholdPeaceful() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thresholdPeaceful');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
  distinctByThresholdReality() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thresholdReality');
    });
  }

  QueryBuilder<UserPreference, UserPreference, QDistinct>
  distinctByThresholdSomeday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thresholdSomeday');
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

  QueryBuilder<UserPreference, bool, QQueryOperations>
  isPremiumActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPremiumActive');
    });
  }

  QueryBuilder<UserPreference, DateTime?, QQueryOperations>
  lastPremiumCheckAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPremiumCheckAt');
    });
  }

  QueryBuilder<UserPreference, String?, QQueryOperations>
  lastPurchaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPurchaseId');
    });
  }

  QueryBuilder<UserPreference, DateTime?, QQueryOperations>
  subscriptionExpiryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionExpiryDate');
    });
  }

  QueryBuilder<UserPreference, double?, QQueryOperations>
  thresholdNoEscapeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thresholdNoEscape');
    });
  }

  QueryBuilder<UserPreference, double?, QQueryOperations>
  thresholdPeacefulProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thresholdPeaceful');
    });
  }

  QueryBuilder<UserPreference, double?, QQueryOperations>
  thresholdRealityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thresholdReality');
    });
  }

  QueryBuilder<UserPreference, double?, QQueryOperations>
  thresholdSomedayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thresholdSomeday');
    });
  }
}
