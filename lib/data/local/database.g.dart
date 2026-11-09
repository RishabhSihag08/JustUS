// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fcmTokenMeta = const VerificationMeta(
    'fcmToken',
  );
  @override
  late final GeneratedColumn<String> fcmToken = GeneratedColumn<String>(
    'fcm_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOnlineMeta = const VerificationMeta(
    'isOnline',
  );
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
    'is_online',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_online" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    role,
    pinHash,
    displayName,
    avatarUrl,
    fcmToken,
    lastSeenAt,
    isOnline,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('fcm_token')) {
      context.handle(
        _fcmTokenMeta,
        fcmToken.isAcceptableOrUnknown(data['fcm_token']!, _fcmTokenMeta),
      );
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    }
    if (data.containsKey('is_online')) {
      context.handle(
        _isOnlineMeta,
        isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      fcmToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fcm_token'],
      ),
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      ),
      isOnline: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_online'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UsersTableData extends DataClass implements Insertable<UsersTableData> {
  final String id;
  final String role;
  final String pinHash;
  final String? displayName;
  final String? avatarUrl;
  final String? fcmToken;
  final DateTime? lastSeenAt;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UsersTableData({
    required this.id,
    required this.role,
    required this.pinHash,
    this.displayName,
    this.avatarUrl,
    this.fcmToken,
    this.lastSeenAt,
    required this.isOnline,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['role'] = Variable<String>(role);
    map['pin_hash'] = Variable<String>(pinHash);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || fcmToken != null) {
      map['fcm_token'] = Variable<String>(fcmToken);
    }
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    }
    map['is_online'] = Variable<bool>(isOnline);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      role: Value(role),
      pinHash: Value(pinHash),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      fcmToken: fcmToken == null && nullToAbsent
          ? const Value.absent()
          : Value(fcmToken),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenAt),
      isOnline: Value(isOnline),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UsersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersTableData(
      id: serializer.fromJson<String>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      fcmToken: serializer.fromJson<String?>(json['fcmToken']),
      lastSeenAt: serializer.fromJson<DateTime?>(json['lastSeenAt']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String>(role),
      'pinHash': serializer.toJson<String>(pinHash),
      'displayName': serializer.toJson<String?>(displayName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'fcmToken': serializer.toJson<String?>(fcmToken),
      'lastSeenAt': serializer.toJson<DateTime?>(lastSeenAt),
      'isOnline': serializer.toJson<bool>(isOnline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UsersTableData copyWith({
    String? id,
    String? role,
    String? pinHash,
    Value<String?> displayName = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    Value<String?> fcmToken = const Value.absent(),
    Value<DateTime?> lastSeenAt = const Value.absent(),
    bool? isOnline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UsersTableData(
    id: id ?? this.id,
    role: role ?? this.role,
    pinHash: pinHash ?? this.pinHash,
    displayName: displayName.present ? displayName.value : this.displayName,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    fcmToken: fcmToken.present ? fcmToken.value : this.fcmToken,
    lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
    isOnline: isOnline ?? this.isOnline,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UsersTableData copyWithCompanion(UsersTableCompanion data) {
    return UsersTableData(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      fcmToken: data.fcmToken.present ? data.fcmToken.value : this.fcmToken,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableData(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('fcmToken: $fcmToken, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('isOnline: $isOnline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    role,
    pinHash,
    displayName,
    avatarUrl,
    fcmToken,
    lastSeenAt,
    isOnline,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersTableData &&
          other.id == this.id &&
          other.role == this.role &&
          other.pinHash == this.pinHash &&
          other.displayName == this.displayName &&
          other.avatarUrl == this.avatarUrl &&
          other.fcmToken == this.fcmToken &&
          other.lastSeenAt == this.lastSeenAt &&
          other.isOnline == this.isOnline &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersTableCompanion extends UpdateCompanion<UsersTableData> {
  final Value<String> id;
  final Value<String> role;
  final Value<String> pinHash;
  final Value<String?> displayName;
  final Value<String?> avatarUrl;
  final Value<String?> fcmToken;
  final Value<DateTime?> lastSeenAt;
  final Value<bool> isOnline;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.fcmToken = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    required String role,
    required String pinHash,
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.fcmToken = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       role = Value(role),
       pinHash = Value(pinHash);
  static Insertable<UsersTableData> custom({
    Expression<String>? id,
    Expression<String>? role,
    Expression<String>? pinHash,
    Expression<String>? displayName,
    Expression<String>? avatarUrl,
    Expression<String>? fcmToken,
    Expression<DateTime>? lastSeenAt,
    Expression<bool>? isOnline,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (pinHash != null) 'pin_hash': pinHash,
      if (displayName != null) 'display_name': displayName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (fcmToken != null) 'fcm_token': fcmToken,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (isOnline != null) 'is_online': isOnline,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? role,
    Value<String>? pinHash,
    Value<String?>? displayName,
    Value<String?>? avatarUrl,
    Value<String?>? fcmToken,
    Value<DateTime?>? lastSeenAt,
    Value<bool>? isOnline,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersTableCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (fcmToken.present) {
      map['fcm_token'] = Variable<String>(fcmToken.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('fcmToken: $fcmToken, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('isOnline: $isOnline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConversationsTableTable extends ConversationsTable
    with TableInfo<$ConversationsTableTable, ConversationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _user1IdMeta = const VerificationMeta(
    'user1Id',
  );
  @override
  late final GeneratedColumn<String> user1Id = GeneratedColumn<String>(
    'user1_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users_table (id)',
    ),
  );
  static const VerificationMeta _user2IdMeta = const VerificationMeta(
    'user2Id',
  );
  @override
  late final GeneratedColumn<String> user2Id = GeneratedColumn<String>(
    'user2_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users_table (id)',
    ),
  );
  static const VerificationMeta _disappearingTimerMeta = const VerificationMeta(
    'disappearingTimer',
  );
  @override
  late final GeneratedColumn<int> disappearingTimer = GeneratedColumn<int>(
    'disappearing_timer',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _viewOnceEnabledMeta = const VerificationMeta(
    'viewOnceEnabled',
  );
  @override
  late final GeneratedColumn<bool> viewOnceEnabled = GeneratedColumn<bool>(
    'view_once_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("view_once_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    user1Id,
    user2Id,
    disappearingTimer,
    viewOnceEnabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConversationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user1_id')) {
      context.handle(
        _user1IdMeta,
        user1Id.isAcceptableOrUnknown(data['user1_id']!, _user1IdMeta),
      );
    } else if (isInserting) {
      context.missing(_user1IdMeta);
    }
    if (data.containsKey('user2_id')) {
      context.handle(
        _user2IdMeta,
        user2Id.isAcceptableOrUnknown(data['user2_id']!, _user2IdMeta),
      );
    } else if (isInserting) {
      context.missing(_user2IdMeta);
    }
    if (data.containsKey('disappearing_timer')) {
      context.handle(
        _disappearingTimerMeta,
        disappearingTimer.isAcceptableOrUnknown(
          data['disappearing_timer']!,
          _disappearingTimerMeta,
        ),
      );
    }
    if (data.containsKey('view_once_enabled')) {
      context.handle(
        _viewOnceEnabledMeta,
        viewOnceEnabled.isAcceptableOrUnknown(
          data['view_once_enabled']!,
          _viewOnceEnabledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {user1Id, user2Id},
  ];
  @override
  ConversationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      user1Id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user1_id'],
      )!,
      user2Id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user2_id'],
      )!,
      disappearingTimer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disappearing_timer'],
      ),
      viewOnceEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}view_once_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ConversationsTableTable createAlias(String alias) {
    return $ConversationsTableTable(attachedDatabase, alias);
  }
}

class ConversationsTableData extends DataClass
    implements Insertable<ConversationsTableData> {
  final String id;
  final String user1Id;
  final String user2Id;
  final int? disappearingTimer;
  final bool viewOnceEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ConversationsTableData({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.disappearingTimer,
    required this.viewOnceEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user1_id'] = Variable<String>(user1Id);
    map['user2_id'] = Variable<String>(user2Id);
    if (!nullToAbsent || disappearingTimer != null) {
      map['disappearing_timer'] = Variable<int>(disappearingTimer);
    }
    map['view_once_enabled'] = Variable<bool>(viewOnceEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConversationsTableCompanion toCompanion(bool nullToAbsent) {
    return ConversationsTableCompanion(
      id: Value(id),
      user1Id: Value(user1Id),
      user2Id: Value(user2Id),
      disappearingTimer: disappearingTimer == null && nullToAbsent
          ? const Value.absent()
          : Value(disappearingTimer),
      viewOnceEnabled: Value(viewOnceEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ConversationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationsTableData(
      id: serializer.fromJson<String>(json['id']),
      user1Id: serializer.fromJson<String>(json['user1Id']),
      user2Id: serializer.fromJson<String>(json['user2Id']),
      disappearingTimer: serializer.fromJson<int?>(json['disappearingTimer']),
      viewOnceEnabled: serializer.fromJson<bool>(json['viewOnceEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'user1Id': serializer.toJson<String>(user1Id),
      'user2Id': serializer.toJson<String>(user2Id),
      'disappearingTimer': serializer.toJson<int?>(disappearingTimer),
      'viewOnceEnabled': serializer.toJson<bool>(viewOnceEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ConversationsTableData copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    Value<int?> disappearingTimer = const Value.absent(),
    bool? viewOnceEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ConversationsTableData(
    id: id ?? this.id,
    user1Id: user1Id ?? this.user1Id,
    user2Id: user2Id ?? this.user2Id,
    disappearingTimer: disappearingTimer.present
        ? disappearingTimer.value
        : this.disappearingTimer,
    viewOnceEnabled: viewOnceEnabled ?? this.viewOnceEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ConversationsTableData copyWithCompanion(ConversationsTableCompanion data) {
    return ConversationsTableData(
      id: data.id.present ? data.id.value : this.id,
      user1Id: data.user1Id.present ? data.user1Id.value : this.user1Id,
      user2Id: data.user2Id.present ? data.user2Id.value : this.user2Id,
      disappearingTimer: data.disappearingTimer.present
          ? data.disappearingTimer.value
          : this.disappearingTimer,
      viewOnceEnabled: data.viewOnceEnabled.present
          ? data.viewOnceEnabled.value
          : this.viewOnceEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsTableData(')
          ..write('id: $id, ')
          ..write('user1Id: $user1Id, ')
          ..write('user2Id: $user2Id, ')
          ..write('disappearingTimer: $disappearingTimer, ')
          ..write('viewOnceEnabled: $viewOnceEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    user1Id,
    user2Id,
    disappearingTimer,
    viewOnceEnabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationsTableData &&
          other.id == this.id &&
          other.user1Id == this.user1Id &&
          other.user2Id == this.user2Id &&
          other.disappearingTimer == this.disappearingTimer &&
          other.viewOnceEnabled == this.viewOnceEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConversationsTableCompanion
    extends UpdateCompanion<ConversationsTableData> {
  final Value<String> id;
  final Value<String> user1Id;
  final Value<String> user2Id;
  final Value<int?> disappearingTimer;
  final Value<bool> viewOnceEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ConversationsTableCompanion({
    this.id = const Value.absent(),
    this.user1Id = const Value.absent(),
    this.user2Id = const Value.absent(),
    this.disappearingTimer = const Value.absent(),
    this.viewOnceEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsTableCompanion.insert({
    required String id,
    required String user1Id,
    required String user2Id,
    this.disappearingTimer = const Value.absent(),
    this.viewOnceEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       user1Id = Value(user1Id),
       user2Id = Value(user2Id);
  static Insertable<ConversationsTableData> custom({
    Expression<String>? id,
    Expression<String>? user1Id,
    Expression<String>? user2Id,
    Expression<int>? disappearingTimer,
    Expression<bool>? viewOnceEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (user1Id != null) 'user1_id': user1Id,
      if (user2Id != null) 'user2_id': user2Id,
      if (disappearingTimer != null) 'disappearing_timer': disappearingTimer,
      if (viewOnceEnabled != null) 'view_once_enabled': viewOnceEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? user1Id,
    Value<String>? user2Id,
    Value<int?>? disappearingTimer,
    Value<bool>? viewOnceEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ConversationsTableCompanion(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      disappearingTimer: disappearingTimer ?? this.disappearingTimer,
      viewOnceEnabled: viewOnceEnabled ?? this.viewOnceEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (user1Id.present) {
      map['user1_id'] = Variable<String>(user1Id.value);
    }
    if (user2Id.present) {
      map['user2_id'] = Variable<String>(user2Id.value);
    }
    if (disappearingTimer.present) {
      map['disappearing_timer'] = Variable<int>(disappearingTimer.value);
    }
    if (viewOnceEnabled.present) {
      map['view_once_enabled'] = Variable<bool>(viewOnceEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsTableCompanion(')
          ..write('id: $id, ')
          ..write('user1Id: $user1Id, ')
          ..write('user2Id: $user2Id, ')
          ..write('disappearingTimer: $disappearingTimer, ')
          ..write('viewOnceEnabled: $viewOnceEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTableTable extends MessagesTable
    with TableInfo<$MessagesTableTable, MessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES conversations_table (id)',
    ),
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users_table (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaUrlMeta = const VerificationMeta(
    'mediaUrl',
  );
  @override
  late final GeneratedColumn<String> mediaUrl = GeneratedColumn<String>(
    'media_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaThumbnailUrlMeta = const VerificationMeta(
    'mediaThumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> mediaThumbnailUrl =
      GeneratedColumn<String>(
        'media_thumbnail_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _mediaDurationMeta = const VerificationMeta(
    'mediaDuration',
  );
  @override
  late final GeneratedColumn<int> mediaDuration = GeneratedColumn<int>(
    'media_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaSizeMeta = const VerificationMeta(
    'mediaSize',
  );
  @override
  late final GeneratedColumn<int> mediaSize = GeneratedColumn<int>(
    'media_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaMimeTypeMeta = const VerificationMeta(
    'mediaMimeType',
  );
  @override
  late final GeneratedColumn<String> mediaMimeType = GeneratedColumn<String>(
    'media_mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replyToIdMeta = const VerificationMeta(
    'replyToId',
  );
  @override
  late final GeneratedColumn<String> replyToId = GeneratedColumn<String>(
    'reply_to_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES messages_table (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _isStarredMeta = const VerificationMeta(
    'isStarred',
  );
  @override
  late final GeneratedColumn<bool> isStarred = GeneratedColumn<bool>(
    'is_starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDisappearingMeta = const VerificationMeta(
    'isDisappearing',
  );
  @override
  late final GeneratedColumn<bool> isDisappearing = GeneratedColumn<bool>(
    'is_disappearing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_disappearing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _viewOnceViewedMeta = const VerificationMeta(
    'viewOnceViewed',
  );
  @override
  late final GeneratedColumn<bool> viewOnceViewed = GeneratedColumn<bool>(
    'view_once_viewed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("view_once_viewed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _viewOnceViewedAtMeta = const VerificationMeta(
    'viewOnceViewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> viewOnceViewedAt =
      GeneratedColumn<DateTime>(
        'view_once_viewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deliveredAtMeta = const VerificationMeta(
    'deliveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
    'delivered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    senderId,
    type,
    content,
    mediaUrl,
    mediaThumbnailUrl,
    mediaDuration,
    mediaSize,
    mediaMimeType,
    replyToId,
    status,
    isStarred,
    isDisappearing,
    expiresAt,
    viewOnceViewed,
    viewOnceViewedAt,
    createdAt,
    updatedAt,
    deliveredAt,
    readAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('media_url')) {
      context.handle(
        _mediaUrlMeta,
        mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta),
      );
    }
    if (data.containsKey('media_thumbnail_url')) {
      context.handle(
        _mediaThumbnailUrlMeta,
        mediaThumbnailUrl.isAcceptableOrUnknown(
          data['media_thumbnail_url']!,
          _mediaThumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('media_duration')) {
      context.handle(
        _mediaDurationMeta,
        mediaDuration.isAcceptableOrUnknown(
          data['media_duration']!,
          _mediaDurationMeta,
        ),
      );
    }
    if (data.containsKey('media_size')) {
      context.handle(
        _mediaSizeMeta,
        mediaSize.isAcceptableOrUnknown(data['media_size']!, _mediaSizeMeta),
      );
    }
    if (data.containsKey('media_mime_type')) {
      context.handle(
        _mediaMimeTypeMeta,
        mediaMimeType.isAcceptableOrUnknown(
          data['media_mime_type']!,
          _mediaMimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('reply_to_id')) {
      context.handle(
        _replyToIdMeta,
        replyToId.isAcceptableOrUnknown(data['reply_to_id']!, _replyToIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_starred')) {
      context.handle(
        _isStarredMeta,
        isStarred.isAcceptableOrUnknown(data['is_starred']!, _isStarredMeta),
      );
    }
    if (data.containsKey('is_disappearing')) {
      context.handle(
        _isDisappearingMeta,
        isDisappearing.isAcceptableOrUnknown(
          data['is_disappearing']!,
          _isDisappearingMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('view_once_viewed')) {
      context.handle(
        _viewOnceViewedMeta,
        viewOnceViewed.isAcceptableOrUnknown(
          data['view_once_viewed']!,
          _viewOnceViewedMeta,
        ),
      );
    }
    if (data.containsKey('view_once_viewed_at')) {
      context.handle(
        _viewOnceViewedAtMeta,
        viewOnceViewedAt.isAcceptableOrUnknown(
          data['view_once_viewed_at']!,
          _viewOnceViewedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
        _deliveredAtMeta,
        deliveredAt.isAcceptableOrUnknown(
          data['delivered_at']!,
          _deliveredAtMeta,
        ),
      );
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      mediaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_url'],
      ),
      mediaThumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_thumbnail_url'],
      ),
      mediaDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_duration'],
      ),
      mediaSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_size'],
      ),
      mediaMimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_mime_type'],
      ),
      replyToId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isStarred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_starred'],
      )!,
      isDisappearing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_disappearing'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      viewOnceViewed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}view_once_viewed'],
      )!,
      viewOnceViewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}view_once_viewed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deliveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}delivered_at'],
      ),
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
    );
  }

  @override
  $MessagesTableTable createAlias(String alias) {
    return $MessagesTableTable(attachedDatabase, alias);
  }
}

class MessagesTableData extends DataClass
    implements Insertable<MessagesTableData> {
  final String id;
  final String conversationId;
  final String senderId;
  final String type;
  final String? content;
  final String? mediaUrl;
  final String? mediaThumbnailUrl;
  final int? mediaDuration;
  final int? mediaSize;
  final String? mediaMimeType;
  final String? replyToId;
  final String status;
  final bool isStarred;
  final bool isDisappearing;
  final DateTime? expiresAt;
  final bool viewOnceViewed;
  final DateTime? viewOnceViewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  const MessagesTableData({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.type,
    this.content,
    this.mediaUrl,
    this.mediaThumbnailUrl,
    this.mediaDuration,
    this.mediaSize,
    this.mediaMimeType,
    this.replyToId,
    required this.status,
    required this.isStarred,
    required this.isDisappearing,
    this.expiresAt,
    required this.viewOnceViewed,
    this.viewOnceViewedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
    this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['sender_id'] = Variable<String>(senderId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || mediaUrl != null) {
      map['media_url'] = Variable<String>(mediaUrl);
    }
    if (!nullToAbsent || mediaThumbnailUrl != null) {
      map['media_thumbnail_url'] = Variable<String>(mediaThumbnailUrl);
    }
    if (!nullToAbsent || mediaDuration != null) {
      map['media_duration'] = Variable<int>(mediaDuration);
    }
    if (!nullToAbsent || mediaSize != null) {
      map['media_size'] = Variable<int>(mediaSize);
    }
    if (!nullToAbsent || mediaMimeType != null) {
      map['media_mime_type'] = Variable<String>(mediaMimeType);
    }
    if (!nullToAbsent || replyToId != null) {
      map['reply_to_id'] = Variable<String>(replyToId);
    }
    map['status'] = Variable<String>(status);
    map['is_starred'] = Variable<bool>(isStarred);
    map['is_disappearing'] = Variable<bool>(isDisappearing);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['view_once_viewed'] = Variable<bool>(viewOnceViewed);
    if (!nullToAbsent || viewOnceViewedAt != null) {
      map['view_once_viewed_at'] = Variable<DateTime>(viewOnceViewedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    return map;
  }

  MessagesTableCompanion toCompanion(bool nullToAbsent) {
    return MessagesTableCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      senderId: Value(senderId),
      type: Value(type),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      mediaUrl: mediaUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaUrl),
      mediaThumbnailUrl: mediaThumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaThumbnailUrl),
      mediaDuration: mediaDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaDuration),
      mediaSize: mediaSize == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaSize),
      mediaMimeType: mediaMimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaMimeType),
      replyToId: replyToId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToId),
      status: Value(status),
      isStarred: Value(isStarred),
      isDisappearing: Value(isDisappearing),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      viewOnceViewed: Value(viewOnceViewed),
      viewOnceViewedAt: viewOnceViewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(viewOnceViewedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
    );
  }

  factory MessagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessagesTableData(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      type: serializer.fromJson<String>(json['type']),
      content: serializer.fromJson<String?>(json['content']),
      mediaUrl: serializer.fromJson<String?>(json['mediaUrl']),
      mediaThumbnailUrl: serializer.fromJson<String?>(
        json['mediaThumbnailUrl'],
      ),
      mediaDuration: serializer.fromJson<int?>(json['mediaDuration']),
      mediaSize: serializer.fromJson<int?>(json['mediaSize']),
      mediaMimeType: serializer.fromJson<String?>(json['mediaMimeType']),
      replyToId: serializer.fromJson<String?>(json['replyToId']),
      status: serializer.fromJson<String>(json['status']),
      isStarred: serializer.fromJson<bool>(json['isStarred']),
      isDisappearing: serializer.fromJson<bool>(json['isDisappearing']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      viewOnceViewed: serializer.fromJson<bool>(json['viewOnceViewed']),
      viewOnceViewedAt: serializer.fromJson<DateTime?>(
        json['viewOnceViewedAt'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'senderId': serializer.toJson<String>(senderId),
      'type': serializer.toJson<String>(type),
      'content': serializer.toJson<String?>(content),
      'mediaUrl': serializer.toJson<String?>(mediaUrl),
      'mediaThumbnailUrl': serializer.toJson<String?>(mediaThumbnailUrl),
      'mediaDuration': serializer.toJson<int?>(mediaDuration),
      'mediaSize': serializer.toJson<int?>(mediaSize),
      'mediaMimeType': serializer.toJson<String?>(mediaMimeType),
      'replyToId': serializer.toJson<String?>(replyToId),
      'status': serializer.toJson<String>(status),
      'isStarred': serializer.toJson<bool>(isStarred),
      'isDisappearing': serializer.toJson<bool>(isDisappearing),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'viewOnceViewed': serializer.toJson<bool>(viewOnceViewed),
      'viewOnceViewedAt': serializer.toJson<DateTime?>(viewOnceViewedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
    };
  }

  MessagesTableData copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? type,
    Value<String?> content = const Value.absent(),
    Value<String?> mediaUrl = const Value.absent(),
    Value<String?> mediaThumbnailUrl = const Value.absent(),
    Value<int?> mediaDuration = const Value.absent(),
    Value<int?> mediaSize = const Value.absent(),
    Value<String?> mediaMimeType = const Value.absent(),
    Value<String?> replyToId = const Value.absent(),
    String? status,
    bool? isStarred,
    bool? isDisappearing,
    Value<DateTime?> expiresAt = const Value.absent(),
    bool? viewOnceViewed,
    Value<DateTime?> viewOnceViewedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deliveredAt = const Value.absent(),
    Value<DateTime?> readAt = const Value.absent(),
  }) => MessagesTableData(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    senderId: senderId ?? this.senderId,
    type: type ?? this.type,
    content: content.present ? content.value : this.content,
    mediaUrl: mediaUrl.present ? mediaUrl.value : this.mediaUrl,
    mediaThumbnailUrl: mediaThumbnailUrl.present
        ? mediaThumbnailUrl.value
        : this.mediaThumbnailUrl,
    mediaDuration: mediaDuration.present
        ? mediaDuration.value
        : this.mediaDuration,
    mediaSize: mediaSize.present ? mediaSize.value : this.mediaSize,
    mediaMimeType: mediaMimeType.present
        ? mediaMimeType.value
        : this.mediaMimeType,
    replyToId: replyToId.present ? replyToId.value : this.replyToId,
    status: status ?? this.status,
    isStarred: isStarred ?? this.isStarred,
    isDisappearing: isDisappearing ?? this.isDisappearing,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    viewOnceViewed: viewOnceViewed ?? this.viewOnceViewed,
    viewOnceViewedAt: viewOnceViewedAt.present
        ? viewOnceViewedAt.value
        : this.viewOnceViewedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
    readAt: readAt.present ? readAt.value : this.readAt,
  );
  MessagesTableData copyWithCompanion(MessagesTableCompanion data) {
    return MessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      type: data.type.present ? data.type.value : this.type,
      content: data.content.present ? data.content.value : this.content,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      mediaThumbnailUrl: data.mediaThumbnailUrl.present
          ? data.mediaThumbnailUrl.value
          : this.mediaThumbnailUrl,
      mediaDuration: data.mediaDuration.present
          ? data.mediaDuration.value
          : this.mediaDuration,
      mediaSize: data.mediaSize.present ? data.mediaSize.value : this.mediaSize,
      mediaMimeType: data.mediaMimeType.present
          ? data.mediaMimeType.value
          : this.mediaMimeType,
      replyToId: data.replyToId.present ? data.replyToId.value : this.replyToId,
      status: data.status.present ? data.status.value : this.status,
      isStarred: data.isStarred.present ? data.isStarred.value : this.isStarred,
      isDisappearing: data.isDisappearing.present
          ? data.isDisappearing.value
          : this.isDisappearing,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      viewOnceViewed: data.viewOnceViewed.present
          ? data.viewOnceViewed.value
          : this.viewOnceViewed,
      viewOnceViewedAt: data.viewOnceViewedAt.present
          ? data.viewOnceViewedAt.value
          : this.viewOnceViewedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deliveredAt: data.deliveredAt.present
          ? data.deliveredAt.value
          : this.deliveredAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessagesTableData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('type: $type, ')
          ..write('content: $content, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('mediaThumbnailUrl: $mediaThumbnailUrl, ')
          ..write('mediaDuration: $mediaDuration, ')
          ..write('mediaSize: $mediaSize, ')
          ..write('mediaMimeType: $mediaMimeType, ')
          ..write('replyToId: $replyToId, ')
          ..write('status: $status, ')
          ..write('isStarred: $isStarred, ')
          ..write('isDisappearing: $isDisappearing, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('viewOnceViewed: $viewOnceViewed, ')
          ..write('viewOnceViewedAt: $viewOnceViewedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    conversationId,
    senderId,
    type,
    content,
    mediaUrl,
    mediaThumbnailUrl,
    mediaDuration,
    mediaSize,
    mediaMimeType,
    replyToId,
    status,
    isStarred,
    isDisappearing,
    expiresAt,
    viewOnceViewed,
    viewOnceViewedAt,
    createdAt,
    updatedAt,
    deliveredAt,
    readAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessagesTableData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.senderId == this.senderId &&
          other.type == this.type &&
          other.content == this.content &&
          other.mediaUrl == this.mediaUrl &&
          other.mediaThumbnailUrl == this.mediaThumbnailUrl &&
          other.mediaDuration == this.mediaDuration &&
          other.mediaSize == this.mediaSize &&
          other.mediaMimeType == this.mediaMimeType &&
          other.replyToId == this.replyToId &&
          other.status == this.status &&
          other.isStarred == this.isStarred &&
          other.isDisappearing == this.isDisappearing &&
          other.expiresAt == this.expiresAt &&
          other.viewOnceViewed == this.viewOnceViewed &&
          other.viewOnceViewedAt == this.viewOnceViewedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deliveredAt == this.deliveredAt &&
          other.readAt == this.readAt);
}

class MessagesTableCompanion extends UpdateCompanion<MessagesTableData> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> senderId;
  final Value<String> type;
  final Value<String?> content;
  final Value<String?> mediaUrl;
  final Value<String?> mediaThumbnailUrl;
  final Value<int?> mediaDuration;
  final Value<int?> mediaSize;
  final Value<String?> mediaMimeType;
  final Value<String?> replyToId;
  final Value<String> status;
  final Value<bool> isStarred;
  final Value<bool> isDisappearing;
  final Value<DateTime?> expiresAt;
  final Value<bool> viewOnceViewed;
  final Value<DateTime?> viewOnceViewedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deliveredAt;
  final Value<DateTime?> readAt;
  final Value<int> rowid;
  const MessagesTableCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.type = const Value.absent(),
    this.content = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.mediaThumbnailUrl = const Value.absent(),
    this.mediaDuration = const Value.absent(),
    this.mediaSize = const Value.absent(),
    this.mediaMimeType = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.status = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.isDisappearing = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.viewOnceViewed = const Value.absent(),
    this.viewOnceViewedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesTableCompanion.insert({
    required String id,
    required String conversationId,
    required String senderId,
    required String type,
    this.content = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.mediaThumbnailUrl = const Value.absent(),
    this.mediaDuration = const Value.absent(),
    this.mediaSize = const Value.absent(),
    this.mediaMimeType = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.status = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.isDisappearing = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.viewOnceViewed = const Value.absent(),
    this.viewOnceViewedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       senderId = Value(senderId),
       type = Value(type);
  static Insertable<MessagesTableData> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? senderId,
    Expression<String>? type,
    Expression<String>? content,
    Expression<String>? mediaUrl,
    Expression<String>? mediaThumbnailUrl,
    Expression<int>? mediaDuration,
    Expression<int>? mediaSize,
    Expression<String>? mediaMimeType,
    Expression<String>? replyToId,
    Expression<String>? status,
    Expression<bool>? isStarred,
    Expression<bool>? isDisappearing,
    Expression<DateTime>? expiresAt,
    Expression<bool>? viewOnceViewed,
    Expression<DateTime>? viewOnceViewedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deliveredAt,
    Expression<DateTime>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (senderId != null) 'sender_id': senderId,
      if (type != null) 'type': type,
      if (content != null) 'content': content,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (mediaThumbnailUrl != null) 'media_thumbnail_url': mediaThumbnailUrl,
      if (mediaDuration != null) 'media_duration': mediaDuration,
      if (mediaSize != null) 'media_size': mediaSize,
      if (mediaMimeType != null) 'media_mime_type': mediaMimeType,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (status != null) 'status': status,
      if (isStarred != null) 'is_starred': isStarred,
      if (isDisappearing != null) 'is_disappearing': isDisappearing,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (viewOnceViewed != null) 'view_once_viewed': viewOnceViewed,
      if (viewOnceViewedAt != null) 'view_once_viewed_at': viewOnceViewedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? senderId,
    Value<String>? type,
    Value<String?>? content,
    Value<String?>? mediaUrl,
    Value<String?>? mediaThumbnailUrl,
    Value<int?>? mediaDuration,
    Value<int?>? mediaSize,
    Value<String?>? mediaMimeType,
    Value<String?>? replyToId,
    Value<String>? status,
    Value<bool>? isStarred,
    Value<bool>? isDisappearing,
    Value<DateTime?>? expiresAt,
    Value<bool>? viewOnceViewed,
    Value<DateTime?>? viewOnceViewedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deliveredAt,
    Value<DateTime?>? readAt,
    Value<int>? rowid,
  }) {
    return MessagesTableCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaThumbnailUrl: mediaThumbnailUrl ?? this.mediaThumbnailUrl,
      mediaDuration: mediaDuration ?? this.mediaDuration,
      mediaSize: mediaSize ?? this.mediaSize,
      mediaMimeType: mediaMimeType ?? this.mediaMimeType,
      replyToId: replyToId ?? this.replyToId,
      status: status ?? this.status,
      isStarred: isStarred ?? this.isStarred,
      isDisappearing: isDisappearing ?? this.isDisappearing,
      expiresAt: expiresAt ?? this.expiresAt,
      viewOnceViewed: viewOnceViewed ?? this.viewOnceViewed,
      viewOnceViewedAt: viewOnceViewedAt ?? this.viewOnceViewedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (mediaThumbnailUrl.present) {
      map['media_thumbnail_url'] = Variable<String>(mediaThumbnailUrl.value);
    }
    if (mediaDuration.present) {
      map['media_duration'] = Variable<int>(mediaDuration.value);
    }
    if (mediaSize.present) {
      map['media_size'] = Variable<int>(mediaSize.value);
    }
    if (mediaMimeType.present) {
      map['media_mime_type'] = Variable<String>(mediaMimeType.value);
    }
    if (replyToId.present) {
      map['reply_to_id'] = Variable<String>(replyToId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isStarred.present) {
      map['is_starred'] = Variable<bool>(isStarred.value);
    }
    if (isDisappearing.present) {
      map['is_disappearing'] = Variable<bool>(isDisappearing.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (viewOnceViewed.present) {
      map['view_once_viewed'] = Variable<bool>(viewOnceViewed.value);
    }
    if (viewOnceViewedAt.present) {
      map['view_once_viewed_at'] = Variable<DateTime>(viewOnceViewedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('type: $type, ')
          ..write('content: $content, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('mediaThumbnailUrl: $mediaThumbnailUrl, ')
          ..write('mediaDuration: $mediaDuration, ')
          ..write('mediaSize: $mediaSize, ')
          ..write('mediaMimeType: $mediaMimeType, ')
          ..write('replyToId: $replyToId, ')
          ..write('status: $status, ')
          ..write('isStarred: $isStarred, ')
          ..write('isDisappearing: $isDisappearing, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('viewOnceViewed: $viewOnceViewed, ')
          ..write('viewOnceViewedAt: $viewOnceViewedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesFtsTableTable extends MessagesFtsTable
    with TableInfo<$MessagesFtsTableTable, MessagesFtsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesFtsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, conversationId, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessagesFtsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  MessagesFtsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessagesFtsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
    );
  }

  @override
  $MessagesFtsTableTable createAlias(String alias) {
    return $MessagesFtsTableTable(attachedDatabase, alias);
  }
}

class MessagesFtsTableData extends DataClass
    implements Insertable<MessagesFtsTableData> {
  final String id;
  final String conversationId;
  final String content;
  const MessagesFtsTableData({
    required this.id,
    required this.conversationId,
    required this.content,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['content'] = Variable<String>(content);
    return map;
  }

  MessagesFtsTableCompanion toCompanion(bool nullToAbsent) {
    return MessagesFtsTableCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      content: Value(content),
    );
  }

  factory MessagesFtsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessagesFtsTableData(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'content': serializer.toJson<String>(content),
    };
  }

  MessagesFtsTableData copyWith({
    String? id,
    String? conversationId,
    String? content,
  }) => MessagesFtsTableData(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    content: content ?? this.content,
  );
  MessagesFtsTableData copyWithCompanion(MessagesFtsTableCompanion data) {
    return MessagesFtsTableData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessagesFtsTableData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, conversationId, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessagesFtsTableData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.content == this.content);
}

class MessagesFtsTableCompanion extends UpdateCompanion<MessagesFtsTableData> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> content;
  final Value<int> rowid;
  const MessagesFtsTableCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.content = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesFtsTableCompanion.insert({
    required String id,
    required String conversationId,
    required String content,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       content = Value(content);
  static Insertable<MessagesFtsTableData> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? content,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (content != null) 'content': content,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesFtsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? content,
    Value<int>? rowid,
  }) {
    return MessagesFtsTableCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesFtsTableCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('content: $content, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReactionsTableTable extends ReactionsTable
    with TableInfo<$ReactionsTableTable, ReactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES messages_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users_table (id)',
    ),
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [messageId, userId, emoji, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reactions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReactionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, userId, emoji};
  @override
  ReactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReactionsTableData(
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReactionsTableTable createAlias(String alias) {
    return $ReactionsTableTable(attachedDatabase, alias);
  }
}

class ReactionsTableData extends DataClass
    implements Insertable<ReactionsTableData> {
  final String messageId;
  final String userId;
  final String emoji;
  final DateTime createdAt;
  const ReactionsTableData({
    required this.messageId,
    required this.userId,
    required this.emoji,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<String>(messageId);
    map['user_id'] = Variable<String>(userId);
    map['emoji'] = Variable<String>(emoji);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReactionsTableCompanion toCompanion(bool nullToAbsent) {
    return ReactionsTableCompanion(
      messageId: Value(messageId),
      userId: Value(userId),
      emoji: Value(emoji),
      createdAt: Value(createdAt),
    );
  }

  factory ReactionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReactionsTableData(
      messageId: serializer.fromJson<String>(json['messageId']),
      userId: serializer.fromJson<String>(json['userId']),
      emoji: serializer.fromJson<String>(json['emoji']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'userId': serializer.toJson<String>(userId),
      'emoji': serializer.toJson<String>(emoji),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReactionsTableData copyWith({
    String? messageId,
    String? userId,
    String? emoji,
    DateTime? createdAt,
  }) => ReactionsTableData(
    messageId: messageId ?? this.messageId,
    userId: userId ?? this.userId,
    emoji: emoji ?? this.emoji,
    createdAt: createdAt ?? this.createdAt,
  );
  ReactionsTableData copyWithCompanion(ReactionsTableCompanion data) {
    return ReactionsTableData(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      userId: data.userId.present ? data.userId.value : this.userId,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReactionsTableData(')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('emoji: $emoji, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(messageId, userId, emoji, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReactionsTableData &&
          other.messageId == this.messageId &&
          other.userId == this.userId &&
          other.emoji == this.emoji &&
          other.createdAt == this.createdAt);
}

class ReactionsTableCompanion extends UpdateCompanion<ReactionsTableData> {
  final Value<String> messageId;
  final Value<String> userId;
  final Value<String> emoji;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReactionsTableCompanion({
    this.messageId = const Value.absent(),
    this.userId = const Value.absent(),
    this.emoji = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReactionsTableCompanion.insert({
    required String messageId,
    required String userId,
    required String emoji,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : messageId = Value(messageId),
       userId = Value(userId),
       emoji = Value(emoji);
  static Insertable<ReactionsTableData> custom({
    Expression<String>? messageId,
    Expression<String>? userId,
    Expression<String>? emoji,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (userId != null) 'user_id': userId,
      if (emoji != null) 'emoji': emoji,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReactionsTableCompanion copyWith({
    Value<String>? messageId,
    Value<String>? userId,
    Value<String>? emoji,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReactionsTableCompanion(
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReactionsTableCompanion(')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('emoji: $emoji, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StarredMessagesTableTable extends StarredMessagesTable
    with TableInfo<$StarredMessagesTableTable, StarredMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StarredMessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES messages_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users_table (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [messageId, userId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'starred_messages_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StarredMessagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, userId};
  @override
  StarredMessagesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StarredMessagesTableData(
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StarredMessagesTableTable createAlias(String alias) {
    return $StarredMessagesTableTable(attachedDatabase, alias);
  }
}

class StarredMessagesTableData extends DataClass
    implements Insertable<StarredMessagesTableData> {
  final String messageId;
  final String userId;
  final DateTime createdAt;
  const StarredMessagesTableData({
    required this.messageId,
    required this.userId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<String>(messageId);
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StarredMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return StarredMessagesTableCompanion(
      messageId: Value(messageId),
      userId: Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory StarredMessagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StarredMessagesTableData(
      messageId: serializer.fromJson<String>(json['messageId']),
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StarredMessagesTableData copyWith({
    String? messageId,
    String? userId,
    DateTime? createdAt,
  }) => StarredMessagesTableData(
    messageId: messageId ?? this.messageId,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
  );
  StarredMessagesTableData copyWithCompanion(
    StarredMessagesTableCompanion data,
  ) {
    return StarredMessagesTableData(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StarredMessagesTableData(')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(messageId, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StarredMessagesTableData &&
          other.messageId == this.messageId &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class StarredMessagesTableCompanion
    extends UpdateCompanion<StarredMessagesTableData> {
  final Value<String> messageId;
  final Value<String> userId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StarredMessagesTableCompanion({
    this.messageId = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StarredMessagesTableCompanion.insert({
    required String messageId,
    required String userId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : messageId = Value(messageId),
       userId = Value(userId);
  static Insertable<StarredMessagesTableData> custom({
    Expression<String>? messageId,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StarredMessagesTableCompanion copyWith({
    Value<String>? messageId,
    Value<String>? userId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StarredMessagesTableCompanion(
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StarredMessagesTableCompanion(')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TypingIndicatorsTableTable extends TypingIndicatorsTable
    with TableInfo<$TypingIndicatorsTableTable, TypingIndicatorsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TypingIndicatorsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES conversations_table (id)',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users_table (id)',
    ),
  );
  static const VerificationMeta _isTypingMeta = const VerificationMeta(
    'isTyping',
  );
  @override
  late final GeneratedColumn<bool> isTyping = GeneratedColumn<bool>(
    'is_typing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_typing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isRecordingMeta = const VerificationMeta(
    'isRecording',
  );
  @override
  late final GeneratedColumn<bool> isRecording = GeneratedColumn<bool>(
    'is_recording',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recording" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    conversationId,
    userId,
    isTyping,
    isRecording,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'typing_indicators_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TypingIndicatorsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('is_typing')) {
      context.handle(
        _isTypingMeta,
        isTyping.isAcceptableOrUnknown(data['is_typing']!, _isTypingMeta),
      );
    }
    if (data.containsKey('is_recording')) {
      context.handle(
        _isRecordingMeta,
        isRecording.isAcceptableOrUnknown(
          data['is_recording']!,
          _isRecordingMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {conversationId, userId};
  @override
  TypingIndicatorsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TypingIndicatorsTableData(
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      isTyping: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_typing'],
      )!,
      isRecording: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recording'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TypingIndicatorsTableTable createAlias(String alias) {
    return $TypingIndicatorsTableTable(attachedDatabase, alias);
  }
}

class TypingIndicatorsTableData extends DataClass
    implements Insertable<TypingIndicatorsTableData> {
  final String conversationId;
  final String userId;
  final bool isTyping;
  final bool isRecording;
  final DateTime updatedAt;
  const TypingIndicatorsTableData({
    required this.conversationId,
    required this.userId,
    required this.isTyping,
    required this.isRecording,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<String>(conversationId);
    map['user_id'] = Variable<String>(userId);
    map['is_typing'] = Variable<bool>(isTyping);
    map['is_recording'] = Variable<bool>(isRecording);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TypingIndicatorsTableCompanion toCompanion(bool nullToAbsent) {
    return TypingIndicatorsTableCompanion(
      conversationId: Value(conversationId),
      userId: Value(userId),
      isTyping: Value(isTyping),
      isRecording: Value(isRecording),
      updatedAt: Value(updatedAt),
    );
  }

  factory TypingIndicatorsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TypingIndicatorsTableData(
      conversationId: serializer.fromJson<String>(json['conversationId']),
      userId: serializer.fromJson<String>(json['userId']),
      isTyping: serializer.fromJson<bool>(json['isTyping']),
      isRecording: serializer.fromJson<bool>(json['isRecording']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<String>(conversationId),
      'userId': serializer.toJson<String>(userId),
      'isTyping': serializer.toJson<bool>(isTyping),
      'isRecording': serializer.toJson<bool>(isRecording),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TypingIndicatorsTableData copyWith({
    String? conversationId,
    String? userId,
    bool? isTyping,
    bool? isRecording,
    DateTime? updatedAt,
  }) => TypingIndicatorsTableData(
    conversationId: conversationId ?? this.conversationId,
    userId: userId ?? this.userId,
    isTyping: isTyping ?? this.isTyping,
    isRecording: isRecording ?? this.isRecording,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TypingIndicatorsTableData copyWithCompanion(
    TypingIndicatorsTableCompanion data,
  ) {
    return TypingIndicatorsTableData(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      userId: data.userId.present ? data.userId.value : this.userId,
      isTyping: data.isTyping.present ? data.isTyping.value : this.isTyping,
      isRecording: data.isRecording.present
          ? data.isRecording.value
          : this.isRecording,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TypingIndicatorsTableData(')
          ..write('conversationId: $conversationId, ')
          ..write('userId: $userId, ')
          ..write('isTyping: $isTyping, ')
          ..write('isRecording: $isRecording, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(conversationId, userId, isTyping, isRecording, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TypingIndicatorsTableData &&
          other.conversationId == this.conversationId &&
          other.userId == this.userId &&
          other.isTyping == this.isTyping &&
          other.isRecording == this.isRecording &&
          other.updatedAt == this.updatedAt);
}

class TypingIndicatorsTableCompanion
    extends UpdateCompanion<TypingIndicatorsTableData> {
  final Value<String> conversationId;
  final Value<String> userId;
  final Value<bool> isTyping;
  final Value<bool> isRecording;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TypingIndicatorsTableCompanion({
    this.conversationId = const Value.absent(),
    this.userId = const Value.absent(),
    this.isTyping = const Value.absent(),
    this.isRecording = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TypingIndicatorsTableCompanion.insert({
    required String conversationId,
    required String userId,
    this.isTyping = const Value.absent(),
    this.isRecording = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       userId = Value(userId);
  static Insertable<TypingIndicatorsTableData> custom({
    Expression<String>? conversationId,
    Expression<String>? userId,
    Expression<bool>? isTyping,
    Expression<bool>? isRecording,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (userId != null) 'user_id': userId,
      if (isTyping != null) 'is_typing': isTyping,
      if (isRecording != null) 'is_recording': isRecording,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TypingIndicatorsTableCompanion copyWith({
    Value<String>? conversationId,
    Value<String>? userId,
    Value<bool>? isTyping,
    Value<bool>? isRecording,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TypingIndicatorsTableCompanion(
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      isTyping: isTyping ?? this.isTyping,
      isRecording: isRecording ?? this.isRecording,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (isTyping.present) {
      map['is_typing'] = Variable<bool>(isTyping.value);
    }
    if (isRecording.present) {
      map['is_recording'] = Variable<bool>(isRecording.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TypingIndicatorsTableCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('userId: $userId, ')
          ..write('isTyping: $isTyping, ')
          ..write('isRecording: $isRecording, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaUploadsTableTable extends MediaUploadsTable
    with TableInfo<$MediaUploadsTableTable, MediaUploadsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaUploadsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES messages_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users_table (id)',
    ),
  );
  static const VerificationMeta _bucketPathMeta = const VerificationMeta(
    'bucketPath',
  );
  @override
  late final GeneratedColumn<String> bucketPath = GeneratedColumn<String>(
    'bucket_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UploadStatus, String>
  uploadStatus = GeneratedColumn<String>(
    'upload_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  ).withConverter<UploadStatus>($MediaUploadsTableTable.$converteruploadStatus);
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    messageId,
    userId,
    bucketPath,
    uploadStatus,
    retryCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_uploads_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaUploadsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('bucket_path')) {
      context.handle(
        _bucketPathMeta,
        bucketPath.isAcceptableOrUnknown(data['bucket_path']!, _bucketPathMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketPathMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaUploadsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaUploadsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      bucketPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_path'],
      )!,
      uploadStatus: $MediaUploadsTableTable.$converteruploadStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}upload_status'],
        )!,
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MediaUploadsTableTable createAlias(String alias) {
    return $MediaUploadsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UploadStatus, String, String>
  $converteruploadStatus = const EnumNameConverter<UploadStatus>(
    UploadStatus.values,
  );
}

class MediaUploadsTableData extends DataClass
    implements Insertable<MediaUploadsTableData> {
  final String id;
  final String messageId;
  final String userId;
  final String bucketPath;
  final UploadStatus uploadStatus;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MediaUploadsTableData({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.bucketPath,
    required this.uploadStatus,
    required this.retryCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['user_id'] = Variable<String>(userId);
    map['bucket_path'] = Variable<String>(bucketPath);
    {
      map['upload_status'] = Variable<String>(
        $MediaUploadsTableTable.$converteruploadStatus.toSql(uploadStatus),
      );
    }
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MediaUploadsTableCompanion toCompanion(bool nullToAbsent) {
    return MediaUploadsTableCompanion(
      id: Value(id),
      messageId: Value(messageId),
      userId: Value(userId),
      bucketPath: Value(bucketPath),
      uploadStatus: Value(uploadStatus),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MediaUploadsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaUploadsTableData(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      userId: serializer.fromJson<String>(json['userId']),
      bucketPath: serializer.fromJson<String>(json['bucketPath']),
      uploadStatus: $MediaUploadsTableTable.$converteruploadStatus.fromJson(
        serializer.fromJson<String>(json['uploadStatus']),
      ),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'userId': serializer.toJson<String>(userId),
      'bucketPath': serializer.toJson<String>(bucketPath),
      'uploadStatus': serializer.toJson<String>(
        $MediaUploadsTableTable.$converteruploadStatus.toJson(uploadStatus),
      ),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MediaUploadsTableData copyWith({
    String? id,
    String? messageId,
    String? userId,
    String? bucketPath,
    UploadStatus? uploadStatus,
    int? retryCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MediaUploadsTableData(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    userId: userId ?? this.userId,
    bucketPath: bucketPath ?? this.bucketPath,
    uploadStatus: uploadStatus ?? this.uploadStatus,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MediaUploadsTableData copyWithCompanion(MediaUploadsTableCompanion data) {
    return MediaUploadsTableData(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      userId: data.userId.present ? data.userId.value : this.userId,
      bucketPath: data.bucketPath.present
          ? data.bucketPath.value
          : this.bucketPath,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaUploadsTableData(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('bucketPath: $bucketPath, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    messageId,
    userId,
    bucketPath,
    uploadStatus,
    retryCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaUploadsTableData &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.userId == this.userId &&
          other.bucketPath == this.bucketPath &&
          other.uploadStatus == this.uploadStatus &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MediaUploadsTableCompanion
    extends UpdateCompanion<MediaUploadsTableData> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<String> userId;
  final Value<String> bucketPath;
  final Value<UploadStatus> uploadStatus;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MediaUploadsTableCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.userId = const Value.absent(),
    this.bucketPath = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaUploadsTableCompanion.insert({
    required String id,
    required String messageId,
    required String userId,
    required String bucketPath,
    this.uploadStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       messageId = Value(messageId),
       userId = Value(userId),
       bucketPath = Value(bucketPath);
  static Insertable<MediaUploadsTableData> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<String>? userId,
    Expression<String>? bucketPath,
    Expression<String>? uploadStatus,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (userId != null) 'user_id': userId,
      if (bucketPath != null) 'bucket_path': bucketPath,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaUploadsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? messageId,
    Value<String>? userId,
    Value<String>? bucketPath,
    Value<UploadStatus>? uploadStatus,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MediaUploadsTableCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      bucketPath: bucketPath ?? this.bucketPath,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (bucketPath.present) {
      map['bucket_path'] = Variable<String>(bucketPath.value);
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(
        $MediaUploadsTableTable.$converteruploadStatus.toSql(
          uploadStatus.value,
        ),
      );
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaUploadsTableCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('bucketPath: $bucketPath, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $ConversationsTableTable conversationsTable =
      $ConversationsTableTable(this);
  late final $MessagesTableTable messagesTable = $MessagesTableTable(this);
  late final $MessagesFtsTableTable messagesFtsTable = $MessagesFtsTableTable(
    this,
  );
  late final $ReactionsTableTable reactionsTable = $ReactionsTableTable(this);
  late final $StarredMessagesTableTable starredMessagesTable =
      $StarredMessagesTableTable(this);
  late final $TypingIndicatorsTableTable typingIndicatorsTable =
      $TypingIndicatorsTableTable(this);
  late final $MediaUploadsTableTable mediaUploadsTable =
      $MediaUploadsTableTable(this);
  late final MessagesDao messagesDao = MessagesDao(this as AppDatabase);
  late final ConversationsDao conversationsDao = ConversationsDao(
    this as AppDatabase,
  );
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final ReactionsDao reactionsDao = ReactionsDao(this as AppDatabase);
  late final StarredMessagesDao starredMessagesDao = StarredMessagesDao(
    this as AppDatabase,
  );
  late final TypingIndicatorsDao typingIndicatorsDao = TypingIndicatorsDao(
    this as AppDatabase,
  );
  late final MediaUploadsDao mediaUploadsDao = MediaUploadsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usersTable,
    conversationsTable,
    messagesTable,
    messagesFtsTable,
    reactionsTable,
    starredMessagesTable,
    typingIndicatorsTable,
    mediaUploadsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'messages_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reactions_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'messages_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('starred_messages_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'messages_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('media_uploads_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UsersTableTableCreateCompanionBuilder = UsersTableCompanion Function({
  required String id,
  required String role,
  required String pinHash,
  Value<String?> displayName,
  Value<String?> avatarUrl,
  Value<String?> fcmToken,
  Value<DateTime?> lastSeenAt,
  Value<bool> isOnline,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableTableUpdateCompanionBuilder = UsersTableCompanion Function({
  Value<String> id,
  Value<String> role,
  Value<String> pinHash,
  Value<String?> displayName,
  Value<String?> avatarUrl,
  Value<String?> fcmToken,
  Value<DateTime?> lastSeenAt,
  Value<bool> isOnline,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$UsersTableTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTableTable, UsersTableData> {
  $$UsersTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessagesTableTable, List<MessagesTableData>>
  _messagesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messagesTable,
    aliasName: 'users_table__id__messages_table__sender_id',
  );

  $$MessagesTableTableProcessedTableManager get messagesTableRefs {
    final manager = $$MessagesTableTableTableManager(
      $_db,
      $_db.messagesTable,
    ).filter((f) => f.senderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReactionsTableTable, List<ReactionsTableData>>
  _reactionsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reactionsTable,
    aliasName: 'users_table__id__reactions_table__user_id',
  );

  $$ReactionsTableTableProcessedTableManager get reactionsTableRefs {
    final manager = $$ReactionsTableTableTableManager(
      $_db,
      $_db.reactionsTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reactionsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $StarredMessagesTableTable,
    List<StarredMessagesTableData>
  >
  _starredMessagesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.starredMessagesTable,
        aliasName: 'users_table__id__starred_messages_table__user_id',
      );

  $$StarredMessagesTableTableProcessedTableManager
  get starredMessagesTableRefs {
    final manager = $$StarredMessagesTableTableTableManager(
      $_db,
      $_db.starredMessagesTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _starredMessagesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TypingIndicatorsTableTable,
    List<TypingIndicatorsTableData>
  >
  _typingIndicatorsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.typingIndicatorsTable,
        aliasName: 'users_table__id__typing_indicators_table__user_id',
      );

  $$TypingIndicatorsTableTableProcessedTableManager
  get typingIndicatorsTableRefs {
    final manager = $$TypingIndicatorsTableTableTableManager(
      $_db,
      $_db.typingIndicatorsTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _typingIndicatorsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MediaUploadsTableTable,
    List<MediaUploadsTableData>
  >
  _mediaUploadsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.mediaUploadsTable,
        aliasName: 'users_table__id__media_uploads_table__user_id',
      );

  $$MediaUploadsTableTableProcessedTableManager get mediaUploadsTableRefs {
    final manager = $$MediaUploadsTableTableTableManager(
      $_db,
      $_db.mediaUploadsTable,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mediaUploadsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fcmToken => $composableBuilder(
    column: $table.fcmToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> messagesTableRefs(
    Expression<bool> Function($$MessagesTableTableFilterComposer f) f,
  ) {
    final $$MessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.senderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reactionsTableRefs(
    Expression<bool> Function($$ReactionsTableTableFilterComposer f) f,
  ) {
    final $$ReactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reactionsTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.reactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> starredMessagesTableRefs(
    Expression<bool> Function($$StarredMessagesTableTableFilterComposer f) f,
  ) {
    final $$StarredMessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.starredMessagesTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StarredMessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.starredMessagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> typingIndicatorsTableRefs(
    Expression<bool> Function($$TypingIndicatorsTableTableFilterComposer f) f,
  ) {
    final $$TypingIndicatorsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.typingIndicatorsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TypingIndicatorsTableTableFilterComposer(
                $db: $db,
                $table: $db.typingIndicatorsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> mediaUploadsTableRefs(
    Expression<bool> Function($$MediaUploadsTableTableFilterComposer f) f,
  ) {
    final $$MediaUploadsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaUploadsTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaUploadsTableTableFilterComposer(
            $db: $db,
            $table: $db.mediaUploadsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fcmToken => $composableBuilder(
    column: $table.fcmToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnline => $composableBuilder(
    column: $table.isOnline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get fcmToken =>
      $composableBuilder(column: $table.fcmToken, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> messagesTableRefs<T extends Object>(
    Expression<T> Function($$MessagesTableTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.senderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reactionsTableRefs<T extends Object>(
    Expression<T> Function($$ReactionsTableTableAnnotationComposer a) f,
  ) {
    final $$ReactionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reactionsTable,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReactionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.reactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> starredMessagesTableRefs<T extends Object>(
    Expression<T> Function($$StarredMessagesTableTableAnnotationComposer a) f,
  ) {
    final $$StarredMessagesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.starredMessagesTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StarredMessagesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.starredMessagesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> typingIndicatorsTableRefs<T extends Object>(
    Expression<T> Function($$TypingIndicatorsTableTableAnnotationComposer a) f,
  ) {
    final $$TypingIndicatorsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.typingIndicatorsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TypingIndicatorsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.typingIndicatorsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> mediaUploadsTableRefs<T extends Object>(
    Expression<T> Function($$MediaUploadsTableTableAnnotationComposer a) f,
  ) {
    final $$MediaUploadsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.mediaUploadsTable,
          getReferencedColumn: (t) => t.userId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MediaUploadsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.mediaUploadsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTableTable,
          UsersTableData,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (UsersTableData, $$UsersTableTableReferences),
          UsersTableData,
          PrefetchHooks Function({
            bool messagesTableRefs,
            bool reactionsTableRefs,
            bool starredMessagesTableRefs,
            bool typingIndicatorsTableRefs,
            bool mediaUploadsTableRefs,
          })
        > {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> fcmToken = const Value.absent(),
                Value<DateTime?> lastSeenAt = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion(
                id: id,
                role: role,
                pinHash: pinHash,
                displayName: displayName,
                avatarUrl: avatarUrl,
                fcmToken: fcmToken,
                lastSeenAt: lastSeenAt,
                isOnline: isOnline,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String role,
                required String pinHash,
                Value<String?> displayName = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> fcmToken = const Value.absent(),
                Value<DateTime?> lastSeenAt = const Value.absent(),
                Value<bool> isOnline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion.insert(
                id: id,
                role: role,
                pinHash: pinHash,
                displayName: displayName,
                avatarUrl: avatarUrl,
                fcmToken: fcmToken,
                lastSeenAt: lastSeenAt,
                isOnline: isOnline,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTableTable, UsersTableData>(table),
                  $$UsersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                messagesTableRefs = false,
                reactionsTableRefs = false,
                starredMessagesTableRefs = false,
                typingIndicatorsTableRefs = false,
                mediaUploadsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (messagesTableRefs) db.messagesTable,
                    if (reactionsTableRefs) db.reactionsTable,
                    if (starredMessagesTableRefs) db.starredMessagesTable,
                    if (typingIndicatorsTableRefs) db.typingIndicatorsTable,
                    if (mediaUploadsTableRefs) db.mediaUploadsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (messagesTableRefs)
                        await $_getPrefetchedDataByColumns<
                          UsersTableData,
                          $UsersTableTable,
                          MessagesTableData,
                          $MessagesTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableTableReferences
                              ._messagesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).messagesTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'sender_id',
                          typedResults: items,
                        ),
                      if (reactionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          UsersTableData,
                          $UsersTableTable,
                          ReactionsTableData,
                          $ReactionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableTableReferences
                              ._reactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).reactionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'user_id',
                          typedResults: items,
                        ),
                      if (starredMessagesTableRefs)
                        await $_getPrefetchedDataByColumns<
                          UsersTableData,
                          $UsersTableTable,
                          StarredMessagesTableData,
                          $StarredMessagesTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableTableReferences
                              ._starredMessagesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).starredMessagesTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'user_id',
                          typedResults: items,
                        ),
                      if (typingIndicatorsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          UsersTableData,
                          $UsersTableTable,
                          TypingIndicatorsTableData,
                          $TypingIndicatorsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableTableReferences
                              ._typingIndicatorsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).typingIndicatorsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'user_id',
                          typedResults: items,
                        ),
                      if (mediaUploadsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          UsersTableData,
                          $UsersTableTable,
                          MediaUploadsTableData,
                          $MediaUploadsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableTableReferences
                              ._mediaUploadsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaUploadsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'user_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTableTable,
      UsersTableData,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (UsersTableData, $$UsersTableTableReferences),
      UsersTableData,
      PrefetchHooks Function({
        bool messagesTableRefs,
        bool reactionsTableRefs,
        bool starredMessagesTableRefs,
        bool typingIndicatorsTableRefs,
        bool mediaUploadsTableRefs,
      })
    >;
typedef $$ConversationsTableTableCreateCompanionBuilder =
    ConversationsTableCompanion Function({
      required String id,
      required String user1Id,
      required String user2Id,
      Value<int?> disappearingTimer,
      Value<bool> viewOnceEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ConversationsTableTableUpdateCompanionBuilder =
    ConversationsTableCompanion Function({
      Value<String> id,
      Value<String> user1Id,
      Value<String> user2Id,
      Value<int?> disappearingTimer,
      Value<bool> viewOnceEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ConversationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ConversationsTableTable,
          ConversationsTableData
        > {
  $$ConversationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTableTable _user1IdTable(_$AppDatabase db) => db.usersTable
      .createAlias('conversations_table__user1_id__users_table__id');

  $$UsersTableTableProcessedTableManager get user1Id {
    final $_column = $_itemColumn<String>('user1_id')!;

    final manager = $$UsersTableTableTableManager(
      $_db,
      $_db.usersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_user1IdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTableTable _user2IdTable(_$AppDatabase db) => db.usersTable
      .createAlias('conversations_table__user2_id__users_table__id');

  $$UsersTableTableProcessedTableManager get user2Id {
    final $_column = $_itemColumn<String>('user2_id')!;

    final manager = $$UsersTableTableTableManager(
      $_db,
      $_db.usersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_user2IdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MessagesTableTable, List<MessagesTableData>>
  _messagesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messagesTable,
    aliasName: 'conversations_table__id__messages_table__conversation_id',
  );

  $$MessagesTableTableProcessedTableManager get messagesTableRefs {
    final manager = $$MessagesTableTableTableManager(
      $_db,
      $_db.messagesTable,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TypingIndicatorsTableTable,
    List<TypingIndicatorsTableData>
  >
  _typingIndicatorsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.typingIndicatorsTable,
        aliasName:
            'conversations_table__id__typing_indicators_table__conversation_id',
      );

  $$TypingIndicatorsTableTableProcessedTableManager
  get typingIndicatorsTableRefs {
    final manager = $$TypingIndicatorsTableTableTableManager(
      $_db,
      $_db.typingIndicatorsTable,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _typingIndicatorsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ConversationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationsTableTable> {
  $$ConversationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get disappearingTimer => $composableBuilder(
    column: $table.disappearingTimer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get viewOnceEnabled => $composableBuilder(
    column: $table.viewOnceEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableTableFilterComposer get user1Id {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user1Id,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableFilterComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableFilterComposer get user2Id {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user2Id,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableFilterComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> messagesTableRefs(
    Expression<bool> Function($$MessagesTableTableFilterComposer f) f,
  ) {
    final $$MessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> typingIndicatorsTableRefs(
    Expression<bool> Function($$TypingIndicatorsTableTableFilterComposer f) f,
  ) {
    final $$TypingIndicatorsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.typingIndicatorsTable,
          getReferencedColumn: (t) => t.conversationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TypingIndicatorsTableTableFilterComposer(
                $db: $db,
                $table: $db.typingIndicatorsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ConversationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationsTableTable> {
  $$ConversationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get disappearingTimer => $composableBuilder(
    column: $table.disappearingTimer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get viewOnceEnabled => $composableBuilder(
    column: $table.viewOnceEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableTableOrderingComposer get user1Id {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user1Id,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableOrderingComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableOrderingComposer get user2Id {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user2Id,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableOrderingComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConversationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationsTableTable> {
  $$ConversationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get disappearingTimer => $composableBuilder(
    column: $table.disappearingTimer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get viewOnceEnabled => $composableBuilder(
    column: $table.viewOnceEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableTableAnnotationComposer get user1Id {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user1Id,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableAnnotationComposer get user2Id {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.user2Id,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> messagesTableRefs<T extends Object>(
    Expression<T> Function($$MessagesTableTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> typingIndicatorsTableRefs<T extends Object>(
    Expression<T> Function($$TypingIndicatorsTableTableAnnotationComposer a) f,
  ) {
    final $$TypingIndicatorsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.typingIndicatorsTable,
          getReferencedColumn: (t) => t.conversationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TypingIndicatorsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.typingIndicatorsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ConversationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationsTableTable,
          ConversationsTableData,
          $$ConversationsTableTableFilterComposer,
          $$ConversationsTableTableOrderingComposer,
          $$ConversationsTableTableAnnotationComposer,
          $$ConversationsTableTableCreateCompanionBuilder,
          $$ConversationsTableTableUpdateCompanionBuilder,
          (ConversationsTableData, $$ConversationsTableTableReferences),
          ConversationsTableData,
          PrefetchHooks Function({
            bool user1Id,
            bool user2Id,
            bool messagesTableRefs,
            bool typingIndicatorsTableRefs,
          })
        > {
  $$ConversationsTableTableTableManager(
    _$AppDatabase db,
    $ConversationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> user1Id = const Value.absent(),
                Value<String> user2Id = const Value.absent(),
                Value<int?> disappearingTimer = const Value.absent(),
                Value<bool> viewOnceEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsTableCompanion(
                id: id,
                user1Id: user1Id,
                user2Id: user2Id,
                disappearingTimer: disappearingTimer,
                viewOnceEnabled: viewOnceEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String user1Id,
                required String user2Id,
                Value<int?> disappearingTimer = const Value.absent(),
                Value<bool> viewOnceEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsTableCompanion.insert(
                id: id,
                user1Id: user1Id,
                user2Id: user2Id,
                disappearingTimer: disappearingTimer,
                viewOnceEnabled: viewOnceEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConversationsTableTable, ConversationsTableData>(
                    table,
                  ),
                  $$ConversationsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                user1Id = false,
                user2Id = false,
                messagesTableRefs = false,
                typingIndicatorsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (messagesTableRefs) db.messagesTable,
                    if (typingIndicatorsTableRefs) db.typingIndicatorsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (user1Id) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.user1Id,
                            referencedTable: $$ConversationsTableTableReferences
                                ._user1IdTable(db),
                            referencedColumn:
                                $$ConversationsTableTableReferences
                                    ._user1IdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (user2Id) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.user2Id,
                            referencedTable: $$ConversationsTableTableReferences
                                ._user2IdTable(db),
                            referencedColumn:
                                $$ConversationsTableTableReferences
                                    ._user2IdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (messagesTableRefs)
                        await $_getPrefetchedDataByColumns<
                          ConversationsTableData,
                          $ConversationsTableTable,
                          MessagesTableData,
                          $MessagesTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$ConversationsTableTableReferences
                              ._messagesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ConversationsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).messagesTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'conversation_id',
                          typedResults: items,
                        ),
                      if (typingIndicatorsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          ConversationsTableData,
                          $ConversationsTableTable,
                          TypingIndicatorsTableData,
                          $TypingIndicatorsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$ConversationsTableTableReferences
                              ._typingIndicatorsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ConversationsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).typingIndicatorsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'conversation_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ConversationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationsTableTable,
      ConversationsTableData,
      $$ConversationsTableTableFilterComposer,
      $$ConversationsTableTableOrderingComposer,
      $$ConversationsTableTableAnnotationComposer,
      $$ConversationsTableTableCreateCompanionBuilder,
      $$ConversationsTableTableUpdateCompanionBuilder,
      (ConversationsTableData, $$ConversationsTableTableReferences),
      ConversationsTableData,
      PrefetchHooks Function({
        bool user1Id,
        bool user2Id,
        bool messagesTableRefs,
        bool typingIndicatorsTableRefs,
      })
    >;
typedef $$MessagesTableTableCreateCompanionBuilder =
    MessagesTableCompanion Function({
      required String id,
      required String conversationId,
      required String senderId,
      required String type,
      Value<String?> content,
      Value<String?> mediaUrl,
      Value<String?> mediaThumbnailUrl,
      Value<int?> mediaDuration,
      Value<int?> mediaSize,
      Value<String?> mediaMimeType,
      Value<String?> replyToId,
      Value<String> status,
      Value<bool> isStarred,
      Value<bool> isDisappearing,
      Value<DateTime?> expiresAt,
      Value<bool> viewOnceViewed,
      Value<DateTime?> viewOnceViewedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deliveredAt,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });
typedef $$MessagesTableTableUpdateCompanionBuilder =
    MessagesTableCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> senderId,
      Value<String> type,
      Value<String?> content,
      Value<String?> mediaUrl,
      Value<String?> mediaThumbnailUrl,
      Value<int?> mediaDuration,
      Value<int?> mediaSize,
      Value<String?> mediaMimeType,
      Value<String?> replyToId,
      Value<String> status,
      Value<bool> isStarred,
      Value<bool> isDisappearing,
      Value<DateTime?> expiresAt,
      Value<bool> viewOnceViewed,
      Value<DateTime?> viewOnceViewedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deliveredAt,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });

final class $$MessagesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $MessagesTableTable, MessagesTableData> {
  $$MessagesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ConversationsTableTable _conversationIdTable(_$AppDatabase db) => db
      .conversationsTable
      .createAlias('messages_table__conversation_id__conversations_table__id');

  $$ConversationsTableTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$ConversationsTableTableTableManager(
      $_db,
      $_db.conversationsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTableTable _senderIdTable(_$AppDatabase db) =>
      db.usersTable.createAlias('messages_table__sender_id__users_table__id');

  $$UsersTableTableProcessedTableManager get senderId {
    final $_column = $_itemColumn<String>('sender_id')!;

    final manager = $$UsersTableTableTableManager(
      $_db,
      $_db.usersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_senderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MessagesTableTable _replyToIdTable(_$AppDatabase db) => db
      .messagesTable
      .createAlias('messages_table__reply_to_id__messages_table__id');

  $$MessagesTableTableProcessedTableManager? get replyToId {
    final $_column = $_itemColumn<String>('reply_to_id');
    if ($_column == null) return null;
    final manager = $$MessagesTableTableTableManager(
      $_db,
      $_db.messagesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_replyToIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReactionsTableTable, List<ReactionsTableData>>
  _reactionsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reactionsTable,
    aliasName: 'messages_table__id__reactions_table__message_id',
  );

  $$ReactionsTableTableProcessedTableManager get reactionsTableRefs {
    final manager = $$ReactionsTableTableTableManager(
      $_db,
      $_db.reactionsTable,
    ).filter((f) => f.messageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reactionsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $StarredMessagesTableTable,
    List<StarredMessagesTableData>
  >
  _starredMessagesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.starredMessagesTable,
        aliasName: 'messages_table__id__starred_messages_table__message_id',
      );

  $$StarredMessagesTableTableProcessedTableManager
  get starredMessagesTableRefs {
    final manager = $$StarredMessagesTableTableTableManager(
      $_db,
      $_db.starredMessagesTable,
    ).filter((f) => f.messageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _starredMessagesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MediaUploadsTableTable,
    List<MediaUploadsTableData>
  >
  _mediaUploadsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.mediaUploadsTable,
        aliasName: 'messages_table__id__media_uploads_table__message_id',
      );

  $$MediaUploadsTableTableProcessedTableManager get mediaUploadsTableRefs {
    final manager = $$MediaUploadsTableTableTableManager(
      $_db,
      $_db.mediaUploadsTable,
    ).filter((f) => f.messageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mediaUploadsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTableTable> {
  $$MessagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaThumbnailUrl => $composableBuilder(
    column: $table.mediaThumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediaDuration => $composableBuilder(
    column: $table.mediaDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediaSize => $composableBuilder(
    column: $table.mediaSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaMimeType => $composableBuilder(
    column: $table.mediaMimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDisappearing => $composableBuilder(
    column: $table.isDisappearing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get viewOnceViewed => $composableBuilder(
    column: $table.viewOnceViewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get viewOnceViewedAt => $composableBuilder(
    column: $table.viewOnceViewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ConversationsTableTableFilterComposer get conversationId {
    final $$ConversationsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConversationsTableTableFilterComposer(
            $db: $db,
            $table: $db.conversationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableFilterComposer get senderId {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.senderId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableFilterComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MessagesTableTableFilterComposer get replyToId {
    final $$MessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.replyToId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reactionsTableRefs(
    Expression<bool> Function($$ReactionsTableTableFilterComposer f) f,
  ) {
    final $$ReactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reactionsTable,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.reactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> starredMessagesTableRefs(
    Expression<bool> Function($$StarredMessagesTableTableFilterComposer f) f,
  ) {
    final $$StarredMessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.starredMessagesTable,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StarredMessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.starredMessagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mediaUploadsTableRefs(
    Expression<bool> Function($$MediaUploadsTableTableFilterComposer f) f,
  ) {
    final $$MediaUploadsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mediaUploadsTable,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MediaUploadsTableTableFilterComposer(
            $db: $db,
            $table: $db.mediaUploadsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTableTable> {
  $$MessagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaThumbnailUrl => $composableBuilder(
    column: $table.mediaThumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediaDuration => $composableBuilder(
    column: $table.mediaDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediaSize => $composableBuilder(
    column: $table.mediaSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaMimeType => $composableBuilder(
    column: $table.mediaMimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDisappearing => $composableBuilder(
    column: $table.isDisappearing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get viewOnceViewed => $composableBuilder(
    column: $table.viewOnceViewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get viewOnceViewedAt => $composableBuilder(
    column: $table.viewOnceViewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ConversationsTableTableOrderingComposer get conversationId {
    final $$ConversationsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConversationsTableTableOrderingComposer(
            $db: $db,
            $table: $db.conversationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableOrderingComposer get senderId {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.senderId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableOrderingComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MessagesTableTableOrderingComposer get replyToId {
    final $$MessagesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.replyToId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableOrderingComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTableTable> {
  $$MessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<String> get mediaThumbnailUrl => $composableBuilder(
    column: $table.mediaThumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mediaDuration => $composableBuilder(
    column: $table.mediaDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mediaSize =>
      $composableBuilder(column: $table.mediaSize, builder: (column) => column);

  GeneratedColumn<String> get mediaMimeType => $composableBuilder(
    column: $table.mediaMimeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isStarred =>
      $composableBuilder(column: $table.isStarred, builder: (column) => column);

  GeneratedColumn<bool> get isDisappearing => $composableBuilder(
    column: $table.isDisappearing,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<bool> get viewOnceViewed => $composableBuilder(
    column: $table.viewOnceViewed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get viewOnceViewedAt => $composableBuilder(
    column: $table.viewOnceViewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
    column: $table.deliveredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  $$ConversationsTableTableAnnotationComposer get conversationId {
    final $$ConversationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.conversationsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ConversationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.conversationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$UsersTableTableAnnotationComposer get senderId {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.senderId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MessagesTableTableAnnotationComposer get replyToId {
    final $$MessagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.replyToId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reactionsTableRefs<T extends Object>(
    Expression<T> Function($$ReactionsTableTableAnnotationComposer a) f,
  ) {
    final $$ReactionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reactionsTable,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReactionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.reactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> starredMessagesTableRefs<T extends Object>(
    Expression<T> Function($$StarredMessagesTableTableAnnotationComposer a) f,
  ) {
    final $$StarredMessagesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.starredMessagesTable,
          getReferencedColumn: (t) => t.messageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StarredMessagesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.starredMessagesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> mediaUploadsTableRefs<T extends Object>(
    Expression<T> Function($$MediaUploadsTableTableAnnotationComposer a) f,
  ) {
    final $$MediaUploadsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.mediaUploadsTable,
          getReferencedColumn: (t) => t.messageId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MediaUploadsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.mediaUploadsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MessagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTableTable,
          MessagesTableData,
          $$MessagesTableTableFilterComposer,
          $$MessagesTableTableOrderingComposer,
          $$MessagesTableTableAnnotationComposer,
          $$MessagesTableTableCreateCompanionBuilder,
          $$MessagesTableTableUpdateCompanionBuilder,
          (MessagesTableData, $$MessagesTableTableReferences),
          MessagesTableData,
          PrefetchHooks Function({
            bool conversationId,
            bool senderId,
            bool replyToId,
            bool reactionsTableRefs,
            bool starredMessagesTableRefs,
            bool mediaUploadsTableRefs,
          })
        > {
  $$MessagesTableTableTableManager(_$AppDatabase db, $MessagesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<String?> mediaThumbnailUrl = const Value.absent(),
                Value<int?> mediaDuration = const Value.absent(),
                Value<int?> mediaSize = const Value.absent(),
                Value<String?> mediaMimeType = const Value.absent(),
                Value<String?> replyToId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<bool> isDisappearing = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<bool> viewOnceViewed = const Value.absent(),
                Value<DateTime?> viewOnceViewedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesTableCompanion(
                id: id,
                conversationId: conversationId,
                senderId: senderId,
                type: type,
                content: content,
                mediaUrl: mediaUrl,
                mediaThumbnailUrl: mediaThumbnailUrl,
                mediaDuration: mediaDuration,
                mediaSize: mediaSize,
                mediaMimeType: mediaMimeType,
                replyToId: replyToId,
                status: status,
                isStarred: isStarred,
                isDisappearing: isDisappearing,
                expiresAt: expiresAt,
                viewOnceViewed: viewOnceViewed,
                viewOnceViewedAt: viewOnceViewedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deliveredAt: deliveredAt,
                readAt: readAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String senderId,
                required String type,
                Value<String?> content = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<String?> mediaThumbnailUrl = const Value.absent(),
                Value<int?> mediaDuration = const Value.absent(),
                Value<int?> mediaSize = const Value.absent(),
                Value<String?> mediaMimeType = const Value.absent(),
                Value<String?> replyToId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<bool> isDisappearing = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<bool> viewOnceViewed = const Value.absent(),
                Value<DateTime?> viewOnceViewedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deliveredAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesTableCompanion.insert(
                id: id,
                conversationId: conversationId,
                senderId: senderId,
                type: type,
                content: content,
                mediaUrl: mediaUrl,
                mediaThumbnailUrl: mediaThumbnailUrl,
                mediaDuration: mediaDuration,
                mediaSize: mediaSize,
                mediaMimeType: mediaMimeType,
                replyToId: replyToId,
                status: status,
                isStarred: isStarred,
                isDisappearing: isDisappearing,
                expiresAt: expiresAt,
                viewOnceViewed: viewOnceViewed,
                viewOnceViewedAt: viewOnceViewedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deliveredAt: deliveredAt,
                readAt: readAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesTableTable, MessagesTableData>(table),
                  $$MessagesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                conversationId = false,
                senderId = false,
                replyToId = false,
                reactionsTableRefs = false,
                starredMessagesTableRefs = false,
                mediaUploadsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (reactionsTableRefs) db.reactionsTable,
                    if (starredMessagesTableRefs) db.starredMessagesTable,
                    if (mediaUploadsTableRefs) db.mediaUploadsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (conversationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.conversationId,
                            referencedTable: $$MessagesTableTableReferences
                                ._conversationIdTable(db),
                            referencedColumn: $$MessagesTableTableReferences
                                ._conversationIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (senderId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.senderId,
                            referencedTable: $$MessagesTableTableReferences
                                ._senderIdTable(db),
                            referencedColumn: $$MessagesTableTableReferences
                                ._senderIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (replyToId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.replyToId,
                            referencedTable: $$MessagesTableTableReferences
                                ._replyToIdTable(db),
                            referencedColumn: $$MessagesTableTableReferences
                                ._replyToIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reactionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          MessagesTableData,
                          $MessagesTableTable,
                          ReactionsTableData,
                          $ReactionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$MessagesTableTableReferences
                              ._reactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MessagesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).reactionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'message_id',
                          typedResults: items,
                        ),
                      if (starredMessagesTableRefs)
                        await $_getPrefetchedDataByColumns<
                          MessagesTableData,
                          $MessagesTableTable,
                          StarredMessagesTableData,
                          $StarredMessagesTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$MessagesTableTableReferences
                              ._starredMessagesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MessagesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).starredMessagesTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'message_id',
                          typedResults: items,
                        ),
                      if (mediaUploadsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          MessagesTableData,
                          $MessagesTableTable,
                          MediaUploadsTableData,
                          $MediaUploadsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$MessagesTableTableReferences
                              ._mediaUploadsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MessagesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).mediaUploadsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'message_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MessagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTableTable,
      MessagesTableData,
      $$MessagesTableTableFilterComposer,
      $$MessagesTableTableOrderingComposer,
      $$MessagesTableTableAnnotationComposer,
      $$MessagesTableTableCreateCompanionBuilder,
      $$MessagesTableTableUpdateCompanionBuilder,
      (MessagesTableData, $$MessagesTableTableReferences),
      MessagesTableData,
      PrefetchHooks Function({
        bool conversationId,
        bool senderId,
        bool replyToId,
        bool reactionsTableRefs,
        bool starredMessagesTableRefs,
        bool mediaUploadsTableRefs,
      })
    >;
typedef $$MessagesFtsTableTableCreateCompanionBuilder =
    MessagesFtsTableCompanion Function({
      required String id,
      required String conversationId,
      required String content,
      Value<int> rowid,
    });
typedef $$MessagesFtsTableTableUpdateCompanionBuilder =
    MessagesFtsTableCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> content,
      Value<int> rowid,
    });

class $$MessagesFtsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesFtsTableTable> {
  $$MessagesFtsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessagesFtsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesFtsTableTable> {
  $$MessagesFtsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessagesFtsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesFtsTableTable> {
  $$MessagesFtsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);
}

class $$MessagesFtsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesFtsTableTable,
          MessagesFtsTableData,
          $$MessagesFtsTableTableFilterComposer,
          $$MessagesFtsTableTableOrderingComposer,
          $$MessagesFtsTableTableAnnotationComposer,
          $$MessagesFtsTableTableCreateCompanionBuilder,
          $$MessagesFtsTableTableUpdateCompanionBuilder,
          (
            MessagesFtsTableData,
            BaseReferences<
              _$AppDatabase,
              $MessagesFtsTableTable,
              MessagesFtsTableData
            >,
          ),
          MessagesFtsTableData,
          PrefetchHooks Function()
        > {
  $$MessagesFtsTableTableTableManager(
    _$AppDatabase db,
    $MessagesFtsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesFtsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesFtsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesFtsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesFtsTableCompanion(
                id: id,
                conversationId: conversationId,
                content: content,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String content,
                Value<int> rowid = const Value.absent(),
              }) => MessagesFtsTableCompanion.insert(
                id: id,
                conversationId: conversationId,
                content: content,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesFtsTableTable, MessagesFtsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $MessagesFtsTableTable,
                    MessagesFtsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessagesFtsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesFtsTableTable,
      MessagesFtsTableData,
      $$MessagesFtsTableTableFilterComposer,
      $$MessagesFtsTableTableOrderingComposer,
      $$MessagesFtsTableTableAnnotationComposer,
      $$MessagesFtsTableTableCreateCompanionBuilder,
      $$MessagesFtsTableTableUpdateCompanionBuilder,
      (
        MessagesFtsTableData,
        BaseReferences<
          _$AppDatabase,
          $MessagesFtsTableTable,
          MessagesFtsTableData
        >,
      ),
      MessagesFtsTableData,
      PrefetchHooks Function()
    >;
typedef $$ReactionsTableTableCreateCompanionBuilder =
    ReactionsTableCompanion Function({
      required String messageId,
      required String userId,
      required String emoji,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ReactionsTableTableUpdateCompanionBuilder =
    ReactionsTableCompanion Function({
      Value<String> messageId,
      Value<String> userId,
      Value<String> emoji,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ReactionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReactionsTableTable,
          ReactionsTableData
        > {
  $$ReactionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MessagesTableTable _messageIdTable(_$AppDatabase db) => db
      .messagesTable
      .createAlias('reactions_table__message_id__messages_table__id');

  $$MessagesTableTableProcessedTableManager get messageId {
    final $_column = $_itemColumn<String>('message_id')!;

    final manager = $$MessagesTableTableTableManager(
      $_db,
      $_db.messagesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTableTable _userIdTable(_$AppDatabase db) =>
      db.usersTable.createAlias('reactions_table__user_id__users_table__id');

  $$UsersTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableTableManager(
      $_db,
      $_db.usersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReactionsTableTable> {
  $$ReactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MessagesTableTableFilterComposer get messageId {
    final $$MessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableFilterComposer get userId {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableFilterComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReactionsTableTable> {
  $$ReactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MessagesTableTableOrderingComposer get messageId {
    final $$MessagesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableOrderingComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableOrderingComposer get userId {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableOrderingComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReactionsTableTable> {
  $$ReactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MessagesTableTableAnnotationComposer get messageId {
    final $$MessagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableAnnotationComposer get userId {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReactionsTableTable,
          ReactionsTableData,
          $$ReactionsTableTableFilterComposer,
          $$ReactionsTableTableOrderingComposer,
          $$ReactionsTableTableAnnotationComposer,
          $$ReactionsTableTableCreateCompanionBuilder,
          $$ReactionsTableTableUpdateCompanionBuilder,
          (ReactionsTableData, $$ReactionsTableTableReferences),
          ReactionsTableData,
          PrefetchHooks Function({bool messageId, bool userId})
        > {
  $$ReactionsTableTableTableManager(
    _$AppDatabase db,
    $ReactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReactionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> messageId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReactionsTableCompanion(
                messageId: messageId,
                userId: userId,
                emoji: emoji,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String messageId,
                required String userId,
                required String emoji,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReactionsTableCompanion.insert(
                messageId: messageId,
                userId: userId,
                emoji: emoji,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReactionsTableTable, ReactionsTableData>(table),
                  $$ReactionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messageId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (messageId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.messageId,
                        referencedTable: $$ReactionsTableTableReferences
                            ._messageIdTable(db),
                        referencedColumn: $$ReactionsTableTableReferences
                            ._messageIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$ReactionsTableTableReferences
                            ._userIdTable(db),
                        referencedColumn: $$ReactionsTableTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReactionsTableTable,
      ReactionsTableData,
      $$ReactionsTableTableFilterComposer,
      $$ReactionsTableTableOrderingComposer,
      $$ReactionsTableTableAnnotationComposer,
      $$ReactionsTableTableCreateCompanionBuilder,
      $$ReactionsTableTableUpdateCompanionBuilder,
      (ReactionsTableData, $$ReactionsTableTableReferences),
      ReactionsTableData,
      PrefetchHooks Function({bool messageId, bool userId})
    >;
typedef $$StarredMessagesTableTableCreateCompanionBuilder =
    StarredMessagesTableCompanion Function({
      required String messageId,
      required String userId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$StarredMessagesTableTableUpdateCompanionBuilder =
    StarredMessagesTableCompanion Function({
      Value<String> messageId,
      Value<String> userId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StarredMessagesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StarredMessagesTableTable,
          StarredMessagesTableData
        > {
  $$StarredMessagesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MessagesTableTable _messageIdTable(_$AppDatabase db) => db
      .messagesTable
      .createAlias('starred_messages_table__message_id__messages_table__id');

  $$MessagesTableTableProcessedTableManager get messageId {
    final $_column = $_itemColumn<String>('message_id')!;

    final manager = $$MessagesTableTableTableManager(
      $_db,
      $_db.messagesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTableTable _userIdTable(_$AppDatabase db) => db.usersTable
      .createAlias('starred_messages_table__user_id__users_table__id');

  $$UsersTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableTableManager(
      $_db,
      $_db.usersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StarredMessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $StarredMessagesTableTable> {
  $$StarredMessagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MessagesTableTableFilterComposer get messageId {
    final $$MessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableFilterComposer get userId {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableFilterComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StarredMessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StarredMessagesTableTable> {
  $$StarredMessagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MessagesTableTableOrderingComposer get messageId {
    final $$MessagesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableOrderingComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableOrderingComposer get userId {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableOrderingComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StarredMessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StarredMessagesTableTable> {
  $$StarredMessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MessagesTableTableAnnotationComposer get messageId {
    final $$MessagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableAnnotationComposer get userId {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StarredMessagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StarredMessagesTableTable,
          StarredMessagesTableData,
          $$StarredMessagesTableTableFilterComposer,
          $$StarredMessagesTableTableOrderingComposer,
          $$StarredMessagesTableTableAnnotationComposer,
          $$StarredMessagesTableTableCreateCompanionBuilder,
          $$StarredMessagesTableTableUpdateCompanionBuilder,
          (StarredMessagesTableData, $$StarredMessagesTableTableReferences),
          StarredMessagesTableData,
          PrefetchHooks Function({bool messageId, bool userId})
        > {
  $$StarredMessagesTableTableTableManager(
    _$AppDatabase db,
    $StarredMessagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StarredMessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StarredMessagesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StarredMessagesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> messageId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StarredMessagesTableCompanion(
                messageId: messageId,
                userId: userId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String messageId,
                required String userId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StarredMessagesTableCompanion.insert(
                messageId: messageId,
                userId: userId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $StarredMessagesTableTable,
                    StarredMessagesTableData
                  >(table),
                  $$StarredMessagesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messageId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (messageId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.messageId,
                        referencedTable: $$StarredMessagesTableTableReferences
                            ._messageIdTable(db),
                        referencedColumn: $$StarredMessagesTableTableReferences
                            ._messageIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$StarredMessagesTableTableReferences
                            ._userIdTable(db),
                        referencedColumn: $$StarredMessagesTableTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StarredMessagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StarredMessagesTableTable,
      StarredMessagesTableData,
      $$StarredMessagesTableTableFilterComposer,
      $$StarredMessagesTableTableOrderingComposer,
      $$StarredMessagesTableTableAnnotationComposer,
      $$StarredMessagesTableTableCreateCompanionBuilder,
      $$StarredMessagesTableTableUpdateCompanionBuilder,
      (StarredMessagesTableData, $$StarredMessagesTableTableReferences),
      StarredMessagesTableData,
      PrefetchHooks Function({bool messageId, bool userId})
    >;
typedef $$TypingIndicatorsTableTableCreateCompanionBuilder =
    TypingIndicatorsTableCompanion Function({
      required String conversationId,
      required String userId,
      Value<bool> isTyping,
      Value<bool> isRecording,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TypingIndicatorsTableTableUpdateCompanionBuilder =
    TypingIndicatorsTableCompanion Function({
      Value<String> conversationId,
      Value<String> userId,
      Value<bool> isTyping,
      Value<bool> isRecording,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TypingIndicatorsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TypingIndicatorsTableTable,
          TypingIndicatorsTableData
        > {
  $$TypingIndicatorsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ConversationsTableTable _conversationIdTable(_$AppDatabase db) =>
      db.conversationsTable.createAlias(
        'typing_indicators_table__conversation_id__conversations_table__id',
      );

  $$ConversationsTableTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$ConversationsTableTableTableManager(
      $_db,
      $_db.conversationsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTableTable _userIdTable(_$AppDatabase db) => db.usersTable
      .createAlias('typing_indicators_table__user_id__users_table__id');

  $$UsersTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableTableManager(
      $_db,
      $_db.usersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TypingIndicatorsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TypingIndicatorsTableTable> {
  $$TypingIndicatorsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get isTyping => $composableBuilder(
    column: $table.isTyping,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecording => $composableBuilder(
    column: $table.isRecording,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ConversationsTableTableFilterComposer get conversationId {
    final $$ConversationsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConversationsTableTableFilterComposer(
            $db: $db,
            $table: $db.conversationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableFilterComposer get userId {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableFilterComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TypingIndicatorsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TypingIndicatorsTableTable> {
  $$TypingIndicatorsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get isTyping => $composableBuilder(
    column: $table.isTyping,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecording => $composableBuilder(
    column: $table.isRecording,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ConversationsTableTableOrderingComposer get conversationId {
    final $$ConversationsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.conversationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConversationsTableTableOrderingComposer(
            $db: $db,
            $table: $db.conversationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableOrderingComposer get userId {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableOrderingComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TypingIndicatorsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TypingIndicatorsTableTable> {
  $$TypingIndicatorsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get isTyping =>
      $composableBuilder(column: $table.isTyping, builder: (column) => column);

  GeneratedColumn<bool> get isRecording => $composableBuilder(
    column: $table.isRecording,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ConversationsTableTableAnnotationComposer get conversationId {
    final $$ConversationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.conversationsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ConversationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.conversationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$UsersTableTableAnnotationComposer get userId {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TypingIndicatorsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TypingIndicatorsTableTable,
          TypingIndicatorsTableData,
          $$TypingIndicatorsTableTableFilterComposer,
          $$TypingIndicatorsTableTableOrderingComposer,
          $$TypingIndicatorsTableTableAnnotationComposer,
          $$TypingIndicatorsTableTableCreateCompanionBuilder,
          $$TypingIndicatorsTableTableUpdateCompanionBuilder,
          (TypingIndicatorsTableData, $$TypingIndicatorsTableTableReferences),
          TypingIndicatorsTableData,
          PrefetchHooks Function({bool conversationId, bool userId})
        > {
  $$TypingIndicatorsTableTableTableManager(
    _$AppDatabase db,
    $TypingIndicatorsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TypingIndicatorsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TypingIndicatorsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TypingIndicatorsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> conversationId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<bool> isTyping = const Value.absent(),
                Value<bool> isRecording = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TypingIndicatorsTableCompanion(
                conversationId: conversationId,
                userId: userId,
                isTyping: isTyping,
                isRecording: isRecording,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String conversationId,
                required String userId,
                Value<bool> isTyping = const Value.absent(),
                Value<bool> isRecording = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TypingIndicatorsTableCompanion.insert(
                conversationId: conversationId,
                userId: userId,
                isTyping: isTyping,
                isRecording: isRecording,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $TypingIndicatorsTableTable,
                    TypingIndicatorsTableData
                  >(table),
                  $$TypingIndicatorsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (conversationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.conversationId,
                        referencedTable: $$TypingIndicatorsTableTableReferences
                            ._conversationIdTable(db),
                        referencedColumn: $$TypingIndicatorsTableTableReferences
                            ._conversationIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$TypingIndicatorsTableTableReferences
                            ._userIdTable(db),
                        referencedColumn: $$TypingIndicatorsTableTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TypingIndicatorsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TypingIndicatorsTableTable,
      TypingIndicatorsTableData,
      $$TypingIndicatorsTableTableFilterComposer,
      $$TypingIndicatorsTableTableOrderingComposer,
      $$TypingIndicatorsTableTableAnnotationComposer,
      $$TypingIndicatorsTableTableCreateCompanionBuilder,
      $$TypingIndicatorsTableTableUpdateCompanionBuilder,
      (TypingIndicatorsTableData, $$TypingIndicatorsTableTableReferences),
      TypingIndicatorsTableData,
      PrefetchHooks Function({bool conversationId, bool userId})
    >;
typedef $$MediaUploadsTableTableCreateCompanionBuilder =
    MediaUploadsTableCompanion Function({
      required String id,
      required String messageId,
      required String userId,
      required String bucketPath,
      Value<UploadStatus> uploadStatus,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$MediaUploadsTableTableUpdateCompanionBuilder =
    MediaUploadsTableCompanion Function({
      Value<String> id,
      Value<String> messageId,
      Value<String> userId,
      Value<String> bucketPath,
      Value<UploadStatus> uploadStatus,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MediaUploadsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MediaUploadsTableTable,
          MediaUploadsTableData
        > {
  $$MediaUploadsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MessagesTableTable _messageIdTable(_$AppDatabase db) => db
      .messagesTable
      .createAlias('media_uploads_table__message_id__messages_table__id');

  $$MessagesTableTableProcessedTableManager get messageId {
    final $_column = $_itemColumn<String>('message_id')!;

    final manager = $$MessagesTableTableTableManager(
      $_db,
      $_db.messagesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTableTable _userIdTable(_$AppDatabase db) => db.usersTable
      .createAlias('media_uploads_table__user_id__users_table__id');

  $$UsersTableTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableTableManager(
      $_db,
      $_db.usersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MediaUploadsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MediaUploadsTableTable> {
  $$MediaUploadsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketPath => $composableBuilder(
    column: $table.bucketPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UploadStatus, UploadStatus, String>
  get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MessagesTableTableFilterComposer get messageId {
    final $$MessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableFilterComposer get userId {
    final $$UsersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableFilterComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaUploadsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaUploadsTableTable> {
  $$MediaUploadsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketPath => $composableBuilder(
    column: $table.bucketPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MessagesTableTableOrderingComposer get messageId {
    final $$MessagesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableOrderingComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableOrderingComposer get userId {
    final $$UsersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableOrderingComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaUploadsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaUploadsTableTable> {
  $$MediaUploadsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bucketPath => $composableBuilder(
    column: $table.bucketPath,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<UploadStatus, String> get uploadStatus =>
      $composableBuilder(
        column: $table.uploadStatus,
        builder: (column) => column,
      );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$MessagesTableTableAnnotationComposer get messageId {
    final $$MessagesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messagesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.messagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableTableAnnotationComposer get userId {
    final $$UsersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.usersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.usersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MediaUploadsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaUploadsTableTable,
          MediaUploadsTableData,
          $$MediaUploadsTableTableFilterComposer,
          $$MediaUploadsTableTableOrderingComposer,
          $$MediaUploadsTableTableAnnotationComposer,
          $$MediaUploadsTableTableCreateCompanionBuilder,
          $$MediaUploadsTableTableUpdateCompanionBuilder,
          (MediaUploadsTableData, $$MediaUploadsTableTableReferences),
          MediaUploadsTableData,
          PrefetchHooks Function({bool messageId, bool userId})
        > {
  $$MediaUploadsTableTableTableManager(
    _$AppDatabase db,
    $MediaUploadsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaUploadsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaUploadsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaUploadsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> bucketPath = const Value.absent(),
                Value<UploadStatus> uploadStatus = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaUploadsTableCompanion(
                id: id,
                messageId: messageId,
                userId: userId,
                bucketPath: bucketPath,
                uploadStatus: uploadStatus,
                retryCount: retryCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String messageId,
                required String userId,
                required String bucketPath,
                Value<UploadStatus> uploadStatus = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaUploadsTableCompanion.insert(
                id: id,
                messageId: messageId,
                userId: userId,
                bucketPath: bucketPath,
                uploadStatus: uploadStatus,
                retryCount: retryCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MediaUploadsTableTable, MediaUploadsTableData>(
                    table,
                  ),
                  $$MediaUploadsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messageId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (messageId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.messageId,
                        referencedTable: $$MediaUploadsTableTableReferences
                            ._messageIdTable(db),
                        referencedColumn: $$MediaUploadsTableTableReferences
                            ._messageIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$MediaUploadsTableTableReferences
                            ._userIdTable(db),
                        referencedColumn: $$MediaUploadsTableTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MediaUploadsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaUploadsTableTable,
      MediaUploadsTableData,
      $$MediaUploadsTableTableFilterComposer,
      $$MediaUploadsTableTableOrderingComposer,
      $$MediaUploadsTableTableAnnotationComposer,
      $$MediaUploadsTableTableCreateCompanionBuilder,
      $$MediaUploadsTableTableUpdateCompanionBuilder,
      (MediaUploadsTableData, $$MediaUploadsTableTableReferences),
      MediaUploadsTableData,
      PrefetchHooks Function({bool messageId, bool userId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$ConversationsTableTableTableManager get conversationsTable =>
      $$ConversationsTableTableTableManager(_db, _db.conversationsTable);
  $$MessagesTableTableTableManager get messagesTable =>
      $$MessagesTableTableTableManager(_db, _db.messagesTable);
  $$MessagesFtsTableTableTableManager get messagesFtsTable =>
      $$MessagesFtsTableTableTableManager(_db, _db.messagesFtsTable);
  $$ReactionsTableTableTableManager get reactionsTable =>
      $$ReactionsTableTableTableManager(_db, _db.reactionsTable);
  $$StarredMessagesTableTableTableManager get starredMessagesTable =>
      $$StarredMessagesTableTableTableManager(_db, _db.starredMessagesTable);
  $$TypingIndicatorsTableTableTableManager get typingIndicatorsTable =>
      $$TypingIndicatorsTableTableTableManager(_db, _db.typingIndicatorsTable);
  $$MediaUploadsTableTableTableManager get mediaUploadsTable =>
      $$MediaUploadsTableTableTableManager(_db, _db.mediaUploadsTable);
}
