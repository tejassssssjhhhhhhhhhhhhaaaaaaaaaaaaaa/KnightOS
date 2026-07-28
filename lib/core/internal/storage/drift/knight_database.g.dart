// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knight_database.dart';

// ignore_for_file: type=lint
mixin _$MigrationDaoMixin on DatabaseAccessor<KnightDatabase> {
  $MigrationLedgerTable get migrationLedger => attachedDatabase.migrationLedger;
  MigrationDaoManager get managers => MigrationDaoManager(this);
}

class MigrationDaoManager {
  final _$MigrationDaoMixin _db;
  MigrationDaoManager(this._db);
  $$MigrationLedgerTableTableManager get migrationLedger =>
      $$MigrationLedgerTableTableManager(
        _db.attachedDatabase,
        _db.migrationLedger,
      );
}

class $MigrationLedgerTable extends MigrationLedger
    with TableInfo<$MigrationLedgerTable, MigrationLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MigrationLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
    'module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _migratedRecordsMeta = const VerificationMeta(
    'migratedRecords',
  );
  @override
  late final GeneratedColumn<int> migratedRecords = GeneratedColumn<int>(
    'migrated_records',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failedRecordsMeta = const VerificationMeta(
    'failedRecords',
  );
  @override
  late final GeneratedColumn<int> failedRecords = GeneratedColumn<int>(
    'failed_records',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    module,
    migratedRecords,
    failedRecords,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'migration_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<MigrationLedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('module')) {
      context.handle(
        _moduleMeta,
        module.isAcceptableOrUnknown(data['module']!, _moduleMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('migrated_records')) {
      context.handle(
        _migratedRecordsMeta,
        migratedRecords.isAcceptableOrUnknown(
          data['migrated_records']!,
          _migratedRecordsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_migratedRecordsMeta);
    }
    if (data.containsKey('failed_records')) {
      context.handle(
        _failedRecordsMeta,
        failedRecords.isAcceptableOrUnknown(
          data['failed_records']!,
          _failedRecordsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_failedRecordsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MigrationLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MigrationLedgerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      module: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module'],
      )!,
      migratedRecords: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}migrated_records'],
      )!,
      failedRecords: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_records'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MigrationLedgerTable createAlias(String alias) {
    return $MigrationLedgerTable(attachedDatabase, alias);
  }
}

class MigrationLedgerData extends DataClass
    implements Insertable<MigrationLedgerData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String syncStatus;
  final String? deviceId;
  final String module;
  final int migratedRecords;
  final int failedRecords;
  final String status;
  const MigrationLedgerData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.syncStatus,
    this.deviceId,
    required this.module,
    required this.migratedRecords,
    required this.failedRecords,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['module'] = Variable<String>(module);
    map['migrated_records'] = Variable<int>(migratedRecords);
    map['failed_records'] = Variable<int>(failedRecords);
    map['status'] = Variable<String>(status);
    return map;
  }

  MigrationLedgerCompanion toCompanion(bool nullToAbsent) {
    return MigrationLedgerCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      module: Value(module),
      migratedRecords: Value(migratedRecords),
      failedRecords: Value(failedRecords),
      status: Value(status),
    );
  }

  factory MigrationLedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MigrationLedgerData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      module: serializer.fromJson<String>(json['module']),
      migratedRecords: serializer.fromJson<int>(json['migratedRecords']),
      failedRecords: serializer.fromJson<int>(json['failedRecords']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deviceId': serializer.toJson<String?>(deviceId),
      'module': serializer.toJson<String>(module),
      'migratedRecords': serializer.toJson<int>(migratedRecords),
      'failedRecords': serializer.toJson<int>(failedRecords),
      'status': serializer.toJson<String>(status),
    };
  }

  MigrationLedgerData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> deviceId = const Value.absent(),
    String? module,
    int? migratedRecords,
    int? failedRecords,
    String? status,
  }) => MigrationLedgerData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    module: module ?? this.module,
    migratedRecords: migratedRecords ?? this.migratedRecords,
    failedRecords: failedRecords ?? this.failedRecords,
    status: status ?? this.status,
  );
  MigrationLedgerData copyWithCompanion(MigrationLedgerCompanion data) {
    return MigrationLedgerData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      module: data.module.present ? data.module.value : this.module,
      migratedRecords: data.migratedRecords.present
          ? data.migratedRecords.value
          : this.migratedRecords,
      failedRecords: data.failedRecords.present
          ? data.failedRecords.value
          : this.failedRecords,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MigrationLedgerData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('module: $module, ')
          ..write('migratedRecords: $migratedRecords, ')
          ..write('failedRecords: $failedRecords, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    module,
    migratedRecords,
    failedRecords,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MigrationLedgerData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId &&
          other.module == this.module &&
          other.migratedRecords == this.migratedRecords &&
          other.failedRecords == this.failedRecords &&
          other.status == this.status);
}

class MigrationLedgerCompanion extends UpdateCompanion<MigrationLedgerData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> deviceId;
  final Value<String> module;
  final Value<int> migratedRecords;
  final Value<int> failedRecords;
  final Value<String> status;
  final Value<int> rowid;
  const MigrationLedgerCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.module = const Value.absent(),
    this.migratedRecords = const Value.absent(),
    this.failedRecords = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MigrationLedgerCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String module,
    required int migratedRecords,
    required int failedRecords,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       module = Value(module),
       migratedRecords = Value(migratedRecords),
       failedRecords = Value(failedRecords),
       status = Value(status);
  static Insertable<MigrationLedgerData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<String>? module,
    Expression<int>? migratedRecords,
    Expression<int>? failedRecords,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (module != null) 'module': module,
      if (migratedRecords != null) 'migrated_records': migratedRecords,
      if (failedRecords != null) 'failed_records': failedRecords,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MigrationLedgerCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<String?>? deviceId,
    Value<String>? module,
    Value<int>? migratedRecords,
    Value<int>? failedRecords,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return MigrationLedgerCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      module: module ?? this.module,
      migratedRecords: migratedRecords ?? this.migratedRecords,
      failedRecords: failedRecords ?? this.failedRecords,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (migratedRecords.present) {
      map['migrated_records'] = Variable<int>(migratedRecords.value);
    }
    if (failedRecords.present) {
      map['failed_records'] = Variable<int>(failedRecords.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MigrationLedgerCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('module: $module, ')
          ..write('migratedRecords: $migratedRecords, ')
          ..write('failedRecords: $failedRecords, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTableTable extends UserProfileTable
    with TableInfo<$UserProfileTableTable, UserProfileTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _focusAreaMeta = const VerificationMeta(
    'focusArea',
  );
  @override
  late final GeneratedColumn<String> focusArea = GeneratedColumn<String>(
    'focus_area',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Focus'),
  );
  static const VerificationMeta _workStyleMeta = const VerificationMeta(
    'workStyle',
  );
  @override
  late final GeneratedColumn<String> workStyle = GeneratedColumn<String>(
    'work_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Deep work'),
  );
  static const VerificationMeta _healthGoalMeta = const VerificationMeta(
    'healthGoal',
  );
  @override
  late final GeneratedColumn<String> healthGoal = GeneratedColumn<String>(
    'health_goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Sleep'),
  );
  static const VerificationMeta _financeGoalMeta = const VerificationMeta(
    'financeGoal',
  );
  @override
  late final GeneratedColumn<String> financeGoal = GeneratedColumn<String>(
    'finance_goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Save more'),
  );
  static const VerificationMeta _goalTextMeta = const VerificationMeta(
    'goalText',
  );
  @override
  late final GeneratedColumn<String> goalText = GeneratedColumn<String>(
    'goal_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _aiToneMeta = const VerificationMeta('aiTone');
  @override
  late final GeneratedColumn<String> aiTone = GeneratedColumn<String>(
    'ai_tone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Balanced'),
  );
  static const VerificationMeta _aiDepthMeta = const VerificationMeta(
    'aiDepth',
  );
  @override
  late final GeneratedColumn<String> aiDepth = GeneratedColumn<String>(
    'ai_depth',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Medium'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  completedSteps =
      GeneratedColumn<String>(
        'completed_steps',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $UserProfileTableTable.$convertercompletedSteps,
      );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _preferredNameMeta = const VerificationMeta(
    'preferredName',
  );
  @override
  late final GeneratedColumn<String> preferredName = GeneratedColumn<String>(
    'preferred_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<String> height = GeneratedColumn<String>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<String> weight = GeneratedColumn<String>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _workTypeMeta = const VerificationMeta(
    'workType',
  );
  @override
  late final GeneratedColumn<String> workType = GeneratedColumn<String>(
    'work_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _shiftTypeMeta = const VerificationMeta(
    'shiftType',
  );
  @override
  late final GeneratedColumn<String> shiftType = GeneratedColumn<String>(
    'shift_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _workHoursMeta = const VerificationMeta(
    'workHours',
  );
  @override
  late final GeneratedColumn<String> workHours = GeneratedColumn<String>(
    'work_hours',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sleepGoalMeta = const VerificationMeta(
    'sleepGoal',
  );
  @override
  late final GeneratedColumn<String> sleepGoal = GeneratedColumn<String>(
    'sleep_goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _waterGoalMeta = const VerificationMeta(
    'waterGoal',
  );
  @override
  late final GeneratedColumn<String> waterGoal = GeneratedColumn<String>(
    'water_goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _exerciseFrequencyMeta = const VerificationMeta(
    'exerciseFrequency',
  );
  @override
  late final GeneratedColumn<String> exerciseFrequency =
      GeneratedColumn<String>(
        'exercise_frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _fitnessLevelMeta = const VerificationMeta(
    'fitnessLevel',
  );
  @override
  late final GeneratedColumn<String> fitnessLevel = GeneratedColumn<String>(
    'fitness_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  healthGoals = GeneratedColumn<String>(
    'health_goals',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($UserProfileTableTable.$converterhealthGoals);
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _monthlyIncomeMeta = const VerificationMeta(
    'monthlyIncome',
  );
  @override
  late final GeneratedColumn<String> monthlyIncome = GeneratedColumn<String>(
    'monthly_income',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _monthlyBudgetMeta = const VerificationMeta(
    'monthlyBudget',
  );
  @override
  late final GeneratedColumn<String> monthlyBudget = GeneratedColumn<String>(
    'monthly_budget',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _savingsGoalMeta = const VerificationMeta(
    'savingsGoal',
  );
  @override
  late final GeneratedColumn<String> savingsGoal = GeneratedColumn<String>(
    'savings_goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  financialPriorities =
      GeneratedColumn<String>(
        'financial_priorities',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $UserProfileTableTable.$converterfinancialPriorities,
      );
  static const VerificationMeta _lifeGoalsMeta = const VerificationMeta(
    'lifeGoals',
  );
  @override
  late final GeneratedColumn<String> lifeGoals = GeneratedColumn<String>(
    'life_goals',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _learningGoalsMeta = const VerificationMeta(
    'learningGoals',
  );
  @override
  late final GeneratedColumn<String> learningGoals = GeneratedColumn<String>(
    'learning_goals',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _focusAreasMeta = const VerificationMeta(
    'focusAreas',
  );
  @override
  late final GeneratedColumn<String> focusAreas = GeneratedColumn<String>(
    'focus_areas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _reminderPreferenceMeta =
      const VerificationMeta('reminderPreference');
  @override
  late final GeneratedColumn<String> reminderPreference =
      GeneratedColumn<String>(
        'reminder_preference',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _aiPersonalityMeta = const VerificationMeta(
    'aiPersonality',
  );
  @override
  late final GeneratedColumn<String> aiPersonality = GeneratedColumn<String>(
    'ai_personality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Professional'),
  );
  static const VerificationMeta _notificationPreferenceMeta =
      const VerificationMeta('notificationPreference');
  @override
  late final GeneratedColumn<String> notificationPreference =
      GeneratedColumn<String>(
        'notification_preference',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _themePreferenceMeta = const VerificationMeta(
    'themePreference',
  );
  @override
  late final GeneratedColumn<String> themePreference = GeneratedColumn<String>(
    'theme_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _privacyPreferenceMeta = const VerificationMeta(
    'privacyPreference',
  );
  @override
  late final GeneratedColumn<String> privacyPreference =
      GeneratedColumn<String>(
        'privacy_preference',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    name,
    role,
    focusArea,
    workStyle,
    healthGoal,
    financeGoal,
    goalText,
    aiTone,
    aiDepth,
    completedSteps,
    fullName,
    preferredName,
    dateOfBirth,
    gender,
    height,
    weight,
    country,
    timeZone,
    occupation,
    company,
    workType,
    shiftType,
    workHours,
    sleepGoal,
    waterGoal,
    exerciseFrequency,
    fitnessLevel,
    healthGoals,
    currency,
    monthlyIncome,
    monthlyBudget,
    savingsGoal,
    financialPriorities,
    lifeGoals,
    learningGoals,
    focusAreas,
    reminderPreference,
    aiPersonality,
    notificationPreference,
    themePreference,
    privacyPreference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('focus_area')) {
      context.handle(
        _focusAreaMeta,
        focusArea.isAcceptableOrUnknown(data['focus_area']!, _focusAreaMeta),
      );
    }
    if (data.containsKey('work_style')) {
      context.handle(
        _workStyleMeta,
        workStyle.isAcceptableOrUnknown(data['work_style']!, _workStyleMeta),
      );
    }
    if (data.containsKey('health_goal')) {
      context.handle(
        _healthGoalMeta,
        healthGoal.isAcceptableOrUnknown(data['health_goal']!, _healthGoalMeta),
      );
    }
    if (data.containsKey('finance_goal')) {
      context.handle(
        _financeGoalMeta,
        financeGoal.isAcceptableOrUnknown(
          data['finance_goal']!,
          _financeGoalMeta,
        ),
      );
    }
    if (data.containsKey('goal_text')) {
      context.handle(
        _goalTextMeta,
        goalText.isAcceptableOrUnknown(data['goal_text']!, _goalTextMeta),
      );
    }
    if (data.containsKey('ai_tone')) {
      context.handle(
        _aiToneMeta,
        aiTone.isAcceptableOrUnknown(data['ai_tone']!, _aiToneMeta),
      );
    }
    if (data.containsKey('ai_depth')) {
      context.handle(
        _aiDepthMeta,
        aiDepth.isAcceptableOrUnknown(data['ai_depth']!, _aiDepthMeta),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('preferred_name')) {
      context.handle(
        _preferredNameMeta,
        preferredName.isAcceptableOrUnknown(
          data['preferred_name']!,
          _preferredNameMeta,
        ),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('work_type')) {
      context.handle(
        _workTypeMeta,
        workType.isAcceptableOrUnknown(data['work_type']!, _workTypeMeta),
      );
    }
    if (data.containsKey('shift_type')) {
      context.handle(
        _shiftTypeMeta,
        shiftType.isAcceptableOrUnknown(data['shift_type']!, _shiftTypeMeta),
      );
    }
    if (data.containsKey('work_hours')) {
      context.handle(
        _workHoursMeta,
        workHours.isAcceptableOrUnknown(data['work_hours']!, _workHoursMeta),
      );
    }
    if (data.containsKey('sleep_goal')) {
      context.handle(
        _sleepGoalMeta,
        sleepGoal.isAcceptableOrUnknown(data['sleep_goal']!, _sleepGoalMeta),
      );
    }
    if (data.containsKey('water_goal')) {
      context.handle(
        _waterGoalMeta,
        waterGoal.isAcceptableOrUnknown(data['water_goal']!, _waterGoalMeta),
      );
    }
    if (data.containsKey('exercise_frequency')) {
      context.handle(
        _exerciseFrequencyMeta,
        exerciseFrequency.isAcceptableOrUnknown(
          data['exercise_frequency']!,
          _exerciseFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('fitness_level')) {
      context.handle(
        _fitnessLevelMeta,
        fitnessLevel.isAcceptableOrUnknown(
          data['fitness_level']!,
          _fitnessLevelMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('monthly_income')) {
      context.handle(
        _monthlyIncomeMeta,
        monthlyIncome.isAcceptableOrUnknown(
          data['monthly_income']!,
          _monthlyIncomeMeta,
        ),
      );
    }
    if (data.containsKey('monthly_budget')) {
      context.handle(
        _monthlyBudgetMeta,
        monthlyBudget.isAcceptableOrUnknown(
          data['monthly_budget']!,
          _monthlyBudgetMeta,
        ),
      );
    }
    if (data.containsKey('savings_goal')) {
      context.handle(
        _savingsGoalMeta,
        savingsGoal.isAcceptableOrUnknown(
          data['savings_goal']!,
          _savingsGoalMeta,
        ),
      );
    }
    if (data.containsKey('life_goals')) {
      context.handle(
        _lifeGoalsMeta,
        lifeGoals.isAcceptableOrUnknown(data['life_goals']!, _lifeGoalsMeta),
      );
    }
    if (data.containsKey('learning_goals')) {
      context.handle(
        _learningGoalsMeta,
        learningGoals.isAcceptableOrUnknown(
          data['learning_goals']!,
          _learningGoalsMeta,
        ),
      );
    }
    if (data.containsKey('focus_areas')) {
      context.handle(
        _focusAreasMeta,
        focusAreas.isAcceptableOrUnknown(data['focus_areas']!, _focusAreasMeta),
      );
    }
    if (data.containsKey('reminder_preference')) {
      context.handle(
        _reminderPreferenceMeta,
        reminderPreference.isAcceptableOrUnknown(
          data['reminder_preference']!,
          _reminderPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('ai_personality')) {
      context.handle(
        _aiPersonalityMeta,
        aiPersonality.isAcceptableOrUnknown(
          data['ai_personality']!,
          _aiPersonalityMeta,
        ),
      );
    }
    if (data.containsKey('notification_preference')) {
      context.handle(
        _notificationPreferenceMeta,
        notificationPreference.isAcceptableOrUnknown(
          data['notification_preference']!,
          _notificationPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('theme_preference')) {
      context.handle(
        _themePreferenceMeta,
        themePreference.isAcceptableOrUnknown(
          data['theme_preference']!,
          _themePreferenceMeta,
        ),
      );
    }
    if (data.containsKey('privacy_preference')) {
      context.handle(
        _privacyPreferenceMeta,
        privacyPreference.isAcceptableOrUnknown(
          data['privacy_preference']!,
          _privacyPreferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      focusArea: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus_area'],
      )!,
      workStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_style'],
      )!,
      healthGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_goal'],
      )!,
      financeGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finance_goal'],
      )!,
      goalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_text'],
      )!,
      aiTone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_tone'],
      )!,
      aiDepth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_depth'],
      )!,
      completedSteps: $UserProfileTableTable.$convertercompletedSteps.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}completed_steps'],
        )!,
      ),
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      preferredName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_name'],
      )!,
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_of_birth'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}height'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      )!,
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      )!,
      workType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_type'],
      )!,
      shiftType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_type'],
      )!,
      workHours: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_hours'],
      )!,
      sleepGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sleep_goal'],
      )!,
      waterGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}water_goal'],
      )!,
      exerciseFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_frequency'],
      )!,
      fitnessLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fitness_level'],
      )!,
      healthGoals: $UserProfileTableTable.$converterhealthGoals.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}health_goals'],
        )!,
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      monthlyIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}monthly_income'],
      )!,
      monthlyBudget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}monthly_budget'],
      )!,
      savingsGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}savings_goal'],
      )!,
      financialPriorities: $UserProfileTableTable.$converterfinancialPriorities
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}financial_priorities'],
            )!,
          ),
      lifeGoals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}life_goals'],
      )!,
      learningGoals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_goals'],
      )!,
      focusAreas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus_areas'],
      )!,
      reminderPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_preference'],
      )!,
      aiPersonality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_personality'],
      )!,
      notificationPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_preference'],
      )!,
      themePreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_preference'],
      )!,
      privacyPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}privacy_preference'],
      )!,
    );
  }

  @override
  $UserProfileTableTable createAlias(String alias) {
    return $UserProfileTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertercompletedSteps =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterhealthGoals =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterfinancialPriorities =
      const StringListConverter();
}

class UserProfileTableData extends DataClass
    implements Insertable<UserProfileTableData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String syncStatus;
  final String? deviceId;
  final String name;
  final String role;
  final String focusArea;
  final String workStyle;
  final String healthGoal;
  final String financeGoal;
  final String goalText;
  final String aiTone;
  final String aiDepth;
  final List<String> completedSteps;
  final String fullName;
  final String preferredName;
  final String dateOfBirth;
  final String gender;
  final String height;
  final String weight;
  final String country;
  final String timeZone;
  final String occupation;
  final String company;
  final String workType;
  final String shiftType;
  final String workHours;
  final String sleepGoal;
  final String waterGoal;
  final String exerciseFrequency;
  final String fitnessLevel;
  final List<String> healthGoals;
  final String currency;
  final String monthlyIncome;
  final String monthlyBudget;
  final String savingsGoal;
  final List<String> financialPriorities;
  final String lifeGoals;
  final String learningGoals;
  final String focusAreas;
  final String reminderPreference;
  final String aiPersonality;
  final String notificationPreference;
  final String themePreference;
  final String privacyPreference;
  const UserProfileTableData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.syncStatus,
    this.deviceId,
    required this.name,
    required this.role,
    required this.focusArea,
    required this.workStyle,
    required this.healthGoal,
    required this.financeGoal,
    required this.goalText,
    required this.aiTone,
    required this.aiDepth,
    required this.completedSteps,
    required this.fullName,
    required this.preferredName,
    required this.dateOfBirth,
    required this.gender,
    required this.height,
    required this.weight,
    required this.country,
    required this.timeZone,
    required this.occupation,
    required this.company,
    required this.workType,
    required this.shiftType,
    required this.workHours,
    required this.sleepGoal,
    required this.waterGoal,
    required this.exerciseFrequency,
    required this.fitnessLevel,
    required this.healthGoals,
    required this.currency,
    required this.monthlyIncome,
    required this.monthlyBudget,
    required this.savingsGoal,
    required this.financialPriorities,
    required this.lifeGoals,
    required this.learningGoals,
    required this.focusAreas,
    required this.reminderPreference,
    required this.aiPersonality,
    required this.notificationPreference,
    required this.themePreference,
    required this.privacyPreference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['focus_area'] = Variable<String>(focusArea);
    map['work_style'] = Variable<String>(workStyle);
    map['health_goal'] = Variable<String>(healthGoal);
    map['finance_goal'] = Variable<String>(financeGoal);
    map['goal_text'] = Variable<String>(goalText);
    map['ai_tone'] = Variable<String>(aiTone);
    map['ai_depth'] = Variable<String>(aiDepth);
    {
      map['completed_steps'] = Variable<String>(
        $UserProfileTableTable.$convertercompletedSteps.toSql(completedSteps),
      );
    }
    map['full_name'] = Variable<String>(fullName);
    map['preferred_name'] = Variable<String>(preferredName);
    map['date_of_birth'] = Variable<String>(dateOfBirth);
    map['gender'] = Variable<String>(gender);
    map['height'] = Variable<String>(height);
    map['weight'] = Variable<String>(weight);
    map['country'] = Variable<String>(country);
    map['time_zone'] = Variable<String>(timeZone);
    map['occupation'] = Variable<String>(occupation);
    map['company'] = Variable<String>(company);
    map['work_type'] = Variable<String>(workType);
    map['shift_type'] = Variable<String>(shiftType);
    map['work_hours'] = Variable<String>(workHours);
    map['sleep_goal'] = Variable<String>(sleepGoal);
    map['water_goal'] = Variable<String>(waterGoal);
    map['exercise_frequency'] = Variable<String>(exerciseFrequency);
    map['fitness_level'] = Variable<String>(fitnessLevel);
    {
      map['health_goals'] = Variable<String>(
        $UserProfileTableTable.$converterhealthGoals.toSql(healthGoals),
      );
    }
    map['currency'] = Variable<String>(currency);
    map['monthly_income'] = Variable<String>(monthlyIncome);
    map['monthly_budget'] = Variable<String>(monthlyBudget);
    map['savings_goal'] = Variable<String>(savingsGoal);
    {
      map['financial_priorities'] = Variable<String>(
        $UserProfileTableTable.$converterfinancialPriorities.toSql(
          financialPriorities,
        ),
      );
    }
    map['life_goals'] = Variable<String>(lifeGoals);
    map['learning_goals'] = Variable<String>(learningGoals);
    map['focus_areas'] = Variable<String>(focusAreas);
    map['reminder_preference'] = Variable<String>(reminderPreference);
    map['ai_personality'] = Variable<String>(aiPersonality);
    map['notification_preference'] = Variable<String>(notificationPreference);
    map['theme_preference'] = Variable<String>(themePreference);
    map['privacy_preference'] = Variable<String>(privacyPreference);
    return map;
  }

  UserProfileTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfileTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      name: Value(name),
      role: Value(role),
      focusArea: Value(focusArea),
      workStyle: Value(workStyle),
      healthGoal: Value(healthGoal),
      financeGoal: Value(financeGoal),
      goalText: Value(goalText),
      aiTone: Value(aiTone),
      aiDepth: Value(aiDepth),
      completedSteps: Value(completedSteps),
      fullName: Value(fullName),
      preferredName: Value(preferredName),
      dateOfBirth: Value(dateOfBirth),
      gender: Value(gender),
      height: Value(height),
      weight: Value(weight),
      country: Value(country),
      timeZone: Value(timeZone),
      occupation: Value(occupation),
      company: Value(company),
      workType: Value(workType),
      shiftType: Value(shiftType),
      workHours: Value(workHours),
      sleepGoal: Value(sleepGoal),
      waterGoal: Value(waterGoal),
      exerciseFrequency: Value(exerciseFrequency),
      fitnessLevel: Value(fitnessLevel),
      healthGoals: Value(healthGoals),
      currency: Value(currency),
      monthlyIncome: Value(monthlyIncome),
      monthlyBudget: Value(monthlyBudget),
      savingsGoal: Value(savingsGoal),
      financialPriorities: Value(financialPriorities),
      lifeGoals: Value(lifeGoals),
      learningGoals: Value(learningGoals),
      focusAreas: Value(focusAreas),
      reminderPreference: Value(reminderPreference),
      aiPersonality: Value(aiPersonality),
      notificationPreference: Value(notificationPreference),
      themePreference: Value(themePreference),
      privacyPreference: Value(privacyPreference),
    );
  }

  factory UserProfileTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileTableData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      focusArea: serializer.fromJson<String>(json['focusArea']),
      workStyle: serializer.fromJson<String>(json['workStyle']),
      healthGoal: serializer.fromJson<String>(json['healthGoal']),
      financeGoal: serializer.fromJson<String>(json['financeGoal']),
      goalText: serializer.fromJson<String>(json['goalText']),
      aiTone: serializer.fromJson<String>(json['aiTone']),
      aiDepth: serializer.fromJson<String>(json['aiDepth']),
      completedSteps: serializer.fromJson<List<String>>(json['completedSteps']),
      fullName: serializer.fromJson<String>(json['fullName']),
      preferredName: serializer.fromJson<String>(json['preferredName']),
      dateOfBirth: serializer.fromJson<String>(json['dateOfBirth']),
      gender: serializer.fromJson<String>(json['gender']),
      height: serializer.fromJson<String>(json['height']),
      weight: serializer.fromJson<String>(json['weight']),
      country: serializer.fromJson<String>(json['country']),
      timeZone: serializer.fromJson<String>(json['timeZone']),
      occupation: serializer.fromJson<String>(json['occupation']),
      company: serializer.fromJson<String>(json['company']),
      workType: serializer.fromJson<String>(json['workType']),
      shiftType: serializer.fromJson<String>(json['shiftType']),
      workHours: serializer.fromJson<String>(json['workHours']),
      sleepGoal: serializer.fromJson<String>(json['sleepGoal']),
      waterGoal: serializer.fromJson<String>(json['waterGoal']),
      exerciseFrequency: serializer.fromJson<String>(json['exerciseFrequency']),
      fitnessLevel: serializer.fromJson<String>(json['fitnessLevel']),
      healthGoals: serializer.fromJson<List<String>>(json['healthGoals']),
      currency: serializer.fromJson<String>(json['currency']),
      monthlyIncome: serializer.fromJson<String>(json['monthlyIncome']),
      monthlyBudget: serializer.fromJson<String>(json['monthlyBudget']),
      savingsGoal: serializer.fromJson<String>(json['savingsGoal']),
      financialPriorities: serializer.fromJson<List<String>>(
        json['financialPriorities'],
      ),
      lifeGoals: serializer.fromJson<String>(json['lifeGoals']),
      learningGoals: serializer.fromJson<String>(json['learningGoals']),
      focusAreas: serializer.fromJson<String>(json['focusAreas']),
      reminderPreference: serializer.fromJson<String>(
        json['reminderPreference'],
      ),
      aiPersonality: serializer.fromJson<String>(json['aiPersonality']),
      notificationPreference: serializer.fromJson<String>(
        json['notificationPreference'],
      ),
      themePreference: serializer.fromJson<String>(json['themePreference']),
      privacyPreference: serializer.fromJson<String>(json['privacyPreference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deviceId': serializer.toJson<String?>(deviceId),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'focusArea': serializer.toJson<String>(focusArea),
      'workStyle': serializer.toJson<String>(workStyle),
      'healthGoal': serializer.toJson<String>(healthGoal),
      'financeGoal': serializer.toJson<String>(financeGoal),
      'goalText': serializer.toJson<String>(goalText),
      'aiTone': serializer.toJson<String>(aiTone),
      'aiDepth': serializer.toJson<String>(aiDepth),
      'completedSteps': serializer.toJson<List<String>>(completedSteps),
      'fullName': serializer.toJson<String>(fullName),
      'preferredName': serializer.toJson<String>(preferredName),
      'dateOfBirth': serializer.toJson<String>(dateOfBirth),
      'gender': serializer.toJson<String>(gender),
      'height': serializer.toJson<String>(height),
      'weight': serializer.toJson<String>(weight),
      'country': serializer.toJson<String>(country),
      'timeZone': serializer.toJson<String>(timeZone),
      'occupation': serializer.toJson<String>(occupation),
      'company': serializer.toJson<String>(company),
      'workType': serializer.toJson<String>(workType),
      'shiftType': serializer.toJson<String>(shiftType),
      'workHours': serializer.toJson<String>(workHours),
      'sleepGoal': serializer.toJson<String>(sleepGoal),
      'waterGoal': serializer.toJson<String>(waterGoal),
      'exerciseFrequency': serializer.toJson<String>(exerciseFrequency),
      'fitnessLevel': serializer.toJson<String>(fitnessLevel),
      'healthGoals': serializer.toJson<List<String>>(healthGoals),
      'currency': serializer.toJson<String>(currency),
      'monthlyIncome': serializer.toJson<String>(monthlyIncome),
      'monthlyBudget': serializer.toJson<String>(monthlyBudget),
      'savingsGoal': serializer.toJson<String>(savingsGoal),
      'financialPriorities': serializer.toJson<List<String>>(
        financialPriorities,
      ),
      'lifeGoals': serializer.toJson<String>(lifeGoals),
      'learningGoals': serializer.toJson<String>(learningGoals),
      'focusAreas': serializer.toJson<String>(focusAreas),
      'reminderPreference': serializer.toJson<String>(reminderPreference),
      'aiPersonality': serializer.toJson<String>(aiPersonality),
      'notificationPreference': serializer.toJson<String>(
        notificationPreference,
      ),
      'themePreference': serializer.toJson<String>(themePreference),
      'privacyPreference': serializer.toJson<String>(privacyPreference),
    };
  }

  UserProfileTableData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> deviceId = const Value.absent(),
    String? name,
    String? role,
    String? focusArea,
    String? workStyle,
    String? healthGoal,
    String? financeGoal,
    String? goalText,
    String? aiTone,
    String? aiDepth,
    List<String>? completedSteps,
    String? fullName,
    String? preferredName,
    String? dateOfBirth,
    String? gender,
    String? height,
    String? weight,
    String? country,
    String? timeZone,
    String? occupation,
    String? company,
    String? workType,
    String? shiftType,
    String? workHours,
    String? sleepGoal,
    String? waterGoal,
    String? exerciseFrequency,
    String? fitnessLevel,
    List<String>? healthGoals,
    String? currency,
    String? monthlyIncome,
    String? monthlyBudget,
    String? savingsGoal,
    List<String>? financialPriorities,
    String? lifeGoals,
    String? learningGoals,
    String? focusAreas,
    String? reminderPreference,
    String? aiPersonality,
    String? notificationPreference,
    String? themePreference,
    String? privacyPreference,
  }) => UserProfileTableData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    name: name ?? this.name,
    role: role ?? this.role,
    focusArea: focusArea ?? this.focusArea,
    workStyle: workStyle ?? this.workStyle,
    healthGoal: healthGoal ?? this.healthGoal,
    financeGoal: financeGoal ?? this.financeGoal,
    goalText: goalText ?? this.goalText,
    aiTone: aiTone ?? this.aiTone,
    aiDepth: aiDepth ?? this.aiDepth,
    completedSteps: completedSteps ?? this.completedSteps,
    fullName: fullName ?? this.fullName,
    preferredName: preferredName ?? this.preferredName,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    country: country ?? this.country,
    timeZone: timeZone ?? this.timeZone,
    occupation: occupation ?? this.occupation,
    company: company ?? this.company,
    workType: workType ?? this.workType,
    shiftType: shiftType ?? this.shiftType,
    workHours: workHours ?? this.workHours,
    sleepGoal: sleepGoal ?? this.sleepGoal,
    waterGoal: waterGoal ?? this.waterGoal,
    exerciseFrequency: exerciseFrequency ?? this.exerciseFrequency,
    fitnessLevel: fitnessLevel ?? this.fitnessLevel,
    healthGoals: healthGoals ?? this.healthGoals,
    currency: currency ?? this.currency,
    monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    savingsGoal: savingsGoal ?? this.savingsGoal,
    financialPriorities: financialPriorities ?? this.financialPriorities,
    lifeGoals: lifeGoals ?? this.lifeGoals,
    learningGoals: learningGoals ?? this.learningGoals,
    focusAreas: focusAreas ?? this.focusAreas,
    reminderPreference: reminderPreference ?? this.reminderPreference,
    aiPersonality: aiPersonality ?? this.aiPersonality,
    notificationPreference:
        notificationPreference ?? this.notificationPreference,
    themePreference: themePreference ?? this.themePreference,
    privacyPreference: privacyPreference ?? this.privacyPreference,
  );
  UserProfileTableData copyWithCompanion(UserProfileTableCompanion data) {
    return UserProfileTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      focusArea: data.focusArea.present ? data.focusArea.value : this.focusArea,
      workStyle: data.workStyle.present ? data.workStyle.value : this.workStyle,
      healthGoal: data.healthGoal.present
          ? data.healthGoal.value
          : this.healthGoal,
      financeGoal: data.financeGoal.present
          ? data.financeGoal.value
          : this.financeGoal,
      goalText: data.goalText.present ? data.goalText.value : this.goalText,
      aiTone: data.aiTone.present ? data.aiTone.value : this.aiTone,
      aiDepth: data.aiDepth.present ? data.aiDepth.value : this.aiDepth,
      completedSteps: data.completedSteps.present
          ? data.completedSteps.value
          : this.completedSteps,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      preferredName: data.preferredName.present
          ? data.preferredName.value
          : this.preferredName,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      gender: data.gender.present ? data.gender.value : this.gender,
      height: data.height.present ? data.height.value : this.height,
      weight: data.weight.present ? data.weight.value : this.weight,
      country: data.country.present ? data.country.value : this.country,
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      occupation: data.occupation.present
          ? data.occupation.value
          : this.occupation,
      company: data.company.present ? data.company.value : this.company,
      workType: data.workType.present ? data.workType.value : this.workType,
      shiftType: data.shiftType.present ? data.shiftType.value : this.shiftType,
      workHours: data.workHours.present ? data.workHours.value : this.workHours,
      sleepGoal: data.sleepGoal.present ? data.sleepGoal.value : this.sleepGoal,
      waterGoal: data.waterGoal.present ? data.waterGoal.value : this.waterGoal,
      exerciseFrequency: data.exerciseFrequency.present
          ? data.exerciseFrequency.value
          : this.exerciseFrequency,
      fitnessLevel: data.fitnessLevel.present
          ? data.fitnessLevel.value
          : this.fitnessLevel,
      healthGoals: data.healthGoals.present
          ? data.healthGoals.value
          : this.healthGoals,
      currency: data.currency.present ? data.currency.value : this.currency,
      monthlyIncome: data.monthlyIncome.present
          ? data.monthlyIncome.value
          : this.monthlyIncome,
      monthlyBudget: data.monthlyBudget.present
          ? data.monthlyBudget.value
          : this.monthlyBudget,
      savingsGoal: data.savingsGoal.present
          ? data.savingsGoal.value
          : this.savingsGoal,
      financialPriorities: data.financialPriorities.present
          ? data.financialPriorities.value
          : this.financialPriorities,
      lifeGoals: data.lifeGoals.present ? data.lifeGoals.value : this.lifeGoals,
      learningGoals: data.learningGoals.present
          ? data.learningGoals.value
          : this.learningGoals,
      focusAreas: data.focusAreas.present
          ? data.focusAreas.value
          : this.focusAreas,
      reminderPreference: data.reminderPreference.present
          ? data.reminderPreference.value
          : this.reminderPreference,
      aiPersonality: data.aiPersonality.present
          ? data.aiPersonality.value
          : this.aiPersonality,
      notificationPreference: data.notificationPreference.present
          ? data.notificationPreference.value
          : this.notificationPreference,
      themePreference: data.themePreference.present
          ? data.themePreference.value
          : this.themePreference,
      privacyPreference: data.privacyPreference.present
          ? data.privacyPreference.value
          : this.privacyPreference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('focusArea: $focusArea, ')
          ..write('workStyle: $workStyle, ')
          ..write('healthGoal: $healthGoal, ')
          ..write('financeGoal: $financeGoal, ')
          ..write('goalText: $goalText, ')
          ..write('aiTone: $aiTone, ')
          ..write('aiDepth: $aiDepth, ')
          ..write('completedSteps: $completedSteps, ')
          ..write('fullName: $fullName, ')
          ..write('preferredName: $preferredName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('country: $country, ')
          ..write('timeZone: $timeZone, ')
          ..write('occupation: $occupation, ')
          ..write('company: $company, ')
          ..write('workType: $workType, ')
          ..write('shiftType: $shiftType, ')
          ..write('workHours: $workHours, ')
          ..write('sleepGoal: $sleepGoal, ')
          ..write('waterGoal: $waterGoal, ')
          ..write('exerciseFrequency: $exerciseFrequency, ')
          ..write('fitnessLevel: $fitnessLevel, ')
          ..write('healthGoals: $healthGoals, ')
          ..write('currency: $currency, ')
          ..write('monthlyIncome: $monthlyIncome, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('savingsGoal: $savingsGoal, ')
          ..write('financialPriorities: $financialPriorities, ')
          ..write('lifeGoals: $lifeGoals, ')
          ..write('learningGoals: $learningGoals, ')
          ..write('focusAreas: $focusAreas, ')
          ..write('reminderPreference: $reminderPreference, ')
          ..write('aiPersonality: $aiPersonality, ')
          ..write('notificationPreference: $notificationPreference, ')
          ..write('themePreference: $themePreference, ')
          ..write('privacyPreference: $privacyPreference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    name,
    role,
    focusArea,
    workStyle,
    healthGoal,
    financeGoal,
    goalText,
    aiTone,
    aiDepth,
    completedSteps,
    fullName,
    preferredName,
    dateOfBirth,
    gender,
    height,
    weight,
    country,
    timeZone,
    occupation,
    company,
    workType,
    shiftType,
    workHours,
    sleepGoal,
    waterGoal,
    exerciseFrequency,
    fitnessLevel,
    healthGoals,
    currency,
    monthlyIncome,
    monthlyBudget,
    savingsGoal,
    financialPriorities,
    lifeGoals,
    learningGoals,
    focusAreas,
    reminderPreference,
    aiPersonality,
    notificationPreference,
    themePreference,
    privacyPreference,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.role == this.role &&
          other.focusArea == this.focusArea &&
          other.workStyle == this.workStyle &&
          other.healthGoal == this.healthGoal &&
          other.financeGoal == this.financeGoal &&
          other.goalText == this.goalText &&
          other.aiTone == this.aiTone &&
          other.aiDepth == this.aiDepth &&
          other.completedSteps == this.completedSteps &&
          other.fullName == this.fullName &&
          other.preferredName == this.preferredName &&
          other.dateOfBirth == this.dateOfBirth &&
          other.gender == this.gender &&
          other.height == this.height &&
          other.weight == this.weight &&
          other.country == this.country &&
          other.timeZone == this.timeZone &&
          other.occupation == this.occupation &&
          other.company == this.company &&
          other.workType == this.workType &&
          other.shiftType == this.shiftType &&
          other.workHours == this.workHours &&
          other.sleepGoal == this.sleepGoal &&
          other.waterGoal == this.waterGoal &&
          other.exerciseFrequency == this.exerciseFrequency &&
          other.fitnessLevel == this.fitnessLevel &&
          other.healthGoals == this.healthGoals &&
          other.currency == this.currency &&
          other.monthlyIncome == this.monthlyIncome &&
          other.monthlyBudget == this.monthlyBudget &&
          other.savingsGoal == this.savingsGoal &&
          other.financialPriorities == this.financialPriorities &&
          other.lifeGoals == this.lifeGoals &&
          other.learningGoals == this.learningGoals &&
          other.focusAreas == this.focusAreas &&
          other.reminderPreference == this.reminderPreference &&
          other.aiPersonality == this.aiPersonality &&
          other.notificationPreference == this.notificationPreference &&
          other.themePreference == this.themePreference &&
          other.privacyPreference == this.privacyPreference);
}

class UserProfileTableCompanion extends UpdateCompanion<UserProfileTableData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> deviceId;
  final Value<String> name;
  final Value<String> role;
  final Value<String> focusArea;
  final Value<String> workStyle;
  final Value<String> healthGoal;
  final Value<String> financeGoal;
  final Value<String> goalText;
  final Value<String> aiTone;
  final Value<String> aiDepth;
  final Value<List<String>> completedSteps;
  final Value<String> fullName;
  final Value<String> preferredName;
  final Value<String> dateOfBirth;
  final Value<String> gender;
  final Value<String> height;
  final Value<String> weight;
  final Value<String> country;
  final Value<String> timeZone;
  final Value<String> occupation;
  final Value<String> company;
  final Value<String> workType;
  final Value<String> shiftType;
  final Value<String> workHours;
  final Value<String> sleepGoal;
  final Value<String> waterGoal;
  final Value<String> exerciseFrequency;
  final Value<String> fitnessLevel;
  final Value<List<String>> healthGoals;
  final Value<String> currency;
  final Value<String> monthlyIncome;
  final Value<String> monthlyBudget;
  final Value<String> savingsGoal;
  final Value<List<String>> financialPriorities;
  final Value<String> lifeGoals;
  final Value<String> learningGoals;
  final Value<String> focusAreas;
  final Value<String> reminderPreference;
  final Value<String> aiPersonality;
  final Value<String> notificationPreference;
  final Value<String> themePreference;
  final Value<String> privacyPreference;
  final Value<int> rowid;
  const UserProfileTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.focusArea = const Value.absent(),
    this.workStyle = const Value.absent(),
    this.healthGoal = const Value.absent(),
    this.financeGoal = const Value.absent(),
    this.goalText = const Value.absent(),
    this.aiTone = const Value.absent(),
    this.aiDepth = const Value.absent(),
    this.completedSteps = const Value.absent(),
    this.fullName = const Value.absent(),
    this.preferredName = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.country = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.occupation = const Value.absent(),
    this.company = const Value.absent(),
    this.workType = const Value.absent(),
    this.shiftType = const Value.absent(),
    this.workHours = const Value.absent(),
    this.sleepGoal = const Value.absent(),
    this.waterGoal = const Value.absent(),
    this.exerciseFrequency = const Value.absent(),
    this.fitnessLevel = const Value.absent(),
    this.healthGoals = const Value.absent(),
    this.currency = const Value.absent(),
    this.monthlyIncome = const Value.absent(),
    this.monthlyBudget = const Value.absent(),
    this.savingsGoal = const Value.absent(),
    this.financialPriorities = const Value.absent(),
    this.lifeGoals = const Value.absent(),
    this.learningGoals = const Value.absent(),
    this.focusAreas = const Value.absent(),
    this.reminderPreference = const Value.absent(),
    this.aiPersonality = const Value.absent(),
    this.notificationPreference = const Value.absent(),
    this.themePreference = const Value.absent(),
    this.privacyPreference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfileTableCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.focusArea = const Value.absent(),
    this.workStyle = const Value.absent(),
    this.healthGoal = const Value.absent(),
    this.financeGoal = const Value.absent(),
    this.goalText = const Value.absent(),
    this.aiTone = const Value.absent(),
    this.aiDepth = const Value.absent(),
    required List<String> completedSteps,
    this.fullName = const Value.absent(),
    this.preferredName = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.country = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.occupation = const Value.absent(),
    this.company = const Value.absent(),
    this.workType = const Value.absent(),
    this.shiftType = const Value.absent(),
    this.workHours = const Value.absent(),
    this.sleepGoal = const Value.absent(),
    this.waterGoal = const Value.absent(),
    this.exerciseFrequency = const Value.absent(),
    this.fitnessLevel = const Value.absent(),
    required List<String> healthGoals,
    this.currency = const Value.absent(),
    this.monthlyIncome = const Value.absent(),
    this.monthlyBudget = const Value.absent(),
    this.savingsGoal = const Value.absent(),
    required List<String> financialPriorities,
    this.lifeGoals = const Value.absent(),
    this.learningGoals = const Value.absent(),
    this.focusAreas = const Value.absent(),
    this.reminderPreference = const Value.absent(),
    this.aiPersonality = const Value.absent(),
    this.notificationPreference = const Value.absent(),
    this.themePreference = const Value.absent(),
    this.privacyPreference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       completedSteps = Value(completedSteps),
       healthGoals = Value(healthGoals),
       financialPriorities = Value(financialPriorities);
  static Insertable<UserProfileTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? focusArea,
    Expression<String>? workStyle,
    Expression<String>? healthGoal,
    Expression<String>? financeGoal,
    Expression<String>? goalText,
    Expression<String>? aiTone,
    Expression<String>? aiDepth,
    Expression<String>? completedSteps,
    Expression<String>? fullName,
    Expression<String>? preferredName,
    Expression<String>? dateOfBirth,
    Expression<String>? gender,
    Expression<String>? height,
    Expression<String>? weight,
    Expression<String>? country,
    Expression<String>? timeZone,
    Expression<String>? occupation,
    Expression<String>? company,
    Expression<String>? workType,
    Expression<String>? shiftType,
    Expression<String>? workHours,
    Expression<String>? sleepGoal,
    Expression<String>? waterGoal,
    Expression<String>? exerciseFrequency,
    Expression<String>? fitnessLevel,
    Expression<String>? healthGoals,
    Expression<String>? currency,
    Expression<String>? monthlyIncome,
    Expression<String>? monthlyBudget,
    Expression<String>? savingsGoal,
    Expression<String>? financialPriorities,
    Expression<String>? lifeGoals,
    Expression<String>? learningGoals,
    Expression<String>? focusAreas,
    Expression<String>? reminderPreference,
    Expression<String>? aiPersonality,
    Expression<String>? notificationPreference,
    Expression<String>? themePreference,
    Expression<String>? privacyPreference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (focusArea != null) 'focus_area': focusArea,
      if (workStyle != null) 'work_style': workStyle,
      if (healthGoal != null) 'health_goal': healthGoal,
      if (financeGoal != null) 'finance_goal': financeGoal,
      if (goalText != null) 'goal_text': goalText,
      if (aiTone != null) 'ai_tone': aiTone,
      if (aiDepth != null) 'ai_depth': aiDepth,
      if (completedSteps != null) 'completed_steps': completedSteps,
      if (fullName != null) 'full_name': fullName,
      if (preferredName != null) 'preferred_name': preferredName,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (country != null) 'country': country,
      if (timeZone != null) 'time_zone': timeZone,
      if (occupation != null) 'occupation': occupation,
      if (company != null) 'company': company,
      if (workType != null) 'work_type': workType,
      if (shiftType != null) 'shift_type': shiftType,
      if (workHours != null) 'work_hours': workHours,
      if (sleepGoal != null) 'sleep_goal': sleepGoal,
      if (waterGoal != null) 'water_goal': waterGoal,
      if (exerciseFrequency != null) 'exercise_frequency': exerciseFrequency,
      if (fitnessLevel != null) 'fitness_level': fitnessLevel,
      if (healthGoals != null) 'health_goals': healthGoals,
      if (currency != null) 'currency': currency,
      if (monthlyIncome != null) 'monthly_income': monthlyIncome,
      if (monthlyBudget != null) 'monthly_budget': monthlyBudget,
      if (savingsGoal != null) 'savings_goal': savingsGoal,
      if (financialPriorities != null)
        'financial_priorities': financialPriorities,
      if (lifeGoals != null) 'life_goals': lifeGoals,
      if (learningGoals != null) 'learning_goals': learningGoals,
      if (focusAreas != null) 'focus_areas': focusAreas,
      if (reminderPreference != null) 'reminder_preference': reminderPreference,
      if (aiPersonality != null) 'ai_personality': aiPersonality,
      if (notificationPreference != null)
        'notification_preference': notificationPreference,
      if (themePreference != null) 'theme_preference': themePreference,
      if (privacyPreference != null) 'privacy_preference': privacyPreference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfileTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<String?>? deviceId,
    Value<String>? name,
    Value<String>? role,
    Value<String>? focusArea,
    Value<String>? workStyle,
    Value<String>? healthGoal,
    Value<String>? financeGoal,
    Value<String>? goalText,
    Value<String>? aiTone,
    Value<String>? aiDepth,
    Value<List<String>>? completedSteps,
    Value<String>? fullName,
    Value<String>? preferredName,
    Value<String>? dateOfBirth,
    Value<String>? gender,
    Value<String>? height,
    Value<String>? weight,
    Value<String>? country,
    Value<String>? timeZone,
    Value<String>? occupation,
    Value<String>? company,
    Value<String>? workType,
    Value<String>? shiftType,
    Value<String>? workHours,
    Value<String>? sleepGoal,
    Value<String>? waterGoal,
    Value<String>? exerciseFrequency,
    Value<String>? fitnessLevel,
    Value<List<String>>? healthGoals,
    Value<String>? currency,
    Value<String>? monthlyIncome,
    Value<String>? monthlyBudget,
    Value<String>? savingsGoal,
    Value<List<String>>? financialPriorities,
    Value<String>? lifeGoals,
    Value<String>? learningGoals,
    Value<String>? focusAreas,
    Value<String>? reminderPreference,
    Value<String>? aiPersonality,
    Value<String>? notificationPreference,
    Value<String>? themePreference,
    Value<String>? privacyPreference,
    Value<int>? rowid,
  }) {
    return UserProfileTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      role: role ?? this.role,
      focusArea: focusArea ?? this.focusArea,
      workStyle: workStyle ?? this.workStyle,
      healthGoal: healthGoal ?? this.healthGoal,
      financeGoal: financeGoal ?? this.financeGoal,
      goalText: goalText ?? this.goalText,
      aiTone: aiTone ?? this.aiTone,
      aiDepth: aiDepth ?? this.aiDepth,
      completedSteps: completedSteps ?? this.completedSteps,
      fullName: fullName ?? this.fullName,
      preferredName: preferredName ?? this.preferredName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      country: country ?? this.country,
      timeZone: timeZone ?? this.timeZone,
      occupation: occupation ?? this.occupation,
      company: company ?? this.company,
      workType: workType ?? this.workType,
      shiftType: shiftType ?? this.shiftType,
      workHours: workHours ?? this.workHours,
      sleepGoal: sleepGoal ?? this.sleepGoal,
      waterGoal: waterGoal ?? this.waterGoal,
      exerciseFrequency: exerciseFrequency ?? this.exerciseFrequency,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      healthGoals: healthGoals ?? this.healthGoals,
      currency: currency ?? this.currency,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      savingsGoal: savingsGoal ?? this.savingsGoal,
      financialPriorities: financialPriorities ?? this.financialPriorities,
      lifeGoals: lifeGoals ?? this.lifeGoals,
      learningGoals: learningGoals ?? this.learningGoals,
      focusAreas: focusAreas ?? this.focusAreas,
      reminderPreference: reminderPreference ?? this.reminderPreference,
      aiPersonality: aiPersonality ?? this.aiPersonality,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
      themePreference: themePreference ?? this.themePreference,
      privacyPreference: privacyPreference ?? this.privacyPreference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (focusArea.present) {
      map['focus_area'] = Variable<String>(focusArea.value);
    }
    if (workStyle.present) {
      map['work_style'] = Variable<String>(workStyle.value);
    }
    if (healthGoal.present) {
      map['health_goal'] = Variable<String>(healthGoal.value);
    }
    if (financeGoal.present) {
      map['finance_goal'] = Variable<String>(financeGoal.value);
    }
    if (goalText.present) {
      map['goal_text'] = Variable<String>(goalText.value);
    }
    if (aiTone.present) {
      map['ai_tone'] = Variable<String>(aiTone.value);
    }
    if (aiDepth.present) {
      map['ai_depth'] = Variable<String>(aiDepth.value);
    }
    if (completedSteps.present) {
      map['completed_steps'] = Variable<String>(
        $UserProfileTableTable.$convertercompletedSteps.toSql(
          completedSteps.value,
        ),
      );
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (preferredName.present) {
      map['preferred_name'] = Variable<String>(preferredName.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (height.present) {
      map['height'] = Variable<String>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<String>(weight.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (workType.present) {
      map['work_type'] = Variable<String>(workType.value);
    }
    if (shiftType.present) {
      map['shift_type'] = Variable<String>(shiftType.value);
    }
    if (workHours.present) {
      map['work_hours'] = Variable<String>(workHours.value);
    }
    if (sleepGoal.present) {
      map['sleep_goal'] = Variable<String>(sleepGoal.value);
    }
    if (waterGoal.present) {
      map['water_goal'] = Variable<String>(waterGoal.value);
    }
    if (exerciseFrequency.present) {
      map['exercise_frequency'] = Variable<String>(exerciseFrequency.value);
    }
    if (fitnessLevel.present) {
      map['fitness_level'] = Variable<String>(fitnessLevel.value);
    }
    if (healthGoals.present) {
      map['health_goals'] = Variable<String>(
        $UserProfileTableTable.$converterhealthGoals.toSql(healthGoals.value),
      );
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (monthlyIncome.present) {
      map['monthly_income'] = Variable<String>(monthlyIncome.value);
    }
    if (monthlyBudget.present) {
      map['monthly_budget'] = Variable<String>(monthlyBudget.value);
    }
    if (savingsGoal.present) {
      map['savings_goal'] = Variable<String>(savingsGoal.value);
    }
    if (financialPriorities.present) {
      map['financial_priorities'] = Variable<String>(
        $UserProfileTableTable.$converterfinancialPriorities.toSql(
          financialPriorities.value,
        ),
      );
    }
    if (lifeGoals.present) {
      map['life_goals'] = Variable<String>(lifeGoals.value);
    }
    if (learningGoals.present) {
      map['learning_goals'] = Variable<String>(learningGoals.value);
    }
    if (focusAreas.present) {
      map['focus_areas'] = Variable<String>(focusAreas.value);
    }
    if (reminderPreference.present) {
      map['reminder_preference'] = Variable<String>(reminderPreference.value);
    }
    if (aiPersonality.present) {
      map['ai_personality'] = Variable<String>(aiPersonality.value);
    }
    if (notificationPreference.present) {
      map['notification_preference'] = Variable<String>(
        notificationPreference.value,
      );
    }
    if (themePreference.present) {
      map['theme_preference'] = Variable<String>(themePreference.value);
    }
    if (privacyPreference.present) {
      map['privacy_preference'] = Variable<String>(privacyPreference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('focusArea: $focusArea, ')
          ..write('workStyle: $workStyle, ')
          ..write('healthGoal: $healthGoal, ')
          ..write('financeGoal: $financeGoal, ')
          ..write('goalText: $goalText, ')
          ..write('aiTone: $aiTone, ')
          ..write('aiDepth: $aiDepth, ')
          ..write('completedSteps: $completedSteps, ')
          ..write('fullName: $fullName, ')
          ..write('preferredName: $preferredName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('country: $country, ')
          ..write('timeZone: $timeZone, ')
          ..write('occupation: $occupation, ')
          ..write('company: $company, ')
          ..write('workType: $workType, ')
          ..write('shiftType: $shiftType, ')
          ..write('workHours: $workHours, ')
          ..write('sleepGoal: $sleepGoal, ')
          ..write('waterGoal: $waterGoal, ')
          ..write('exerciseFrequency: $exerciseFrequency, ')
          ..write('fitnessLevel: $fitnessLevel, ')
          ..write('healthGoals: $healthGoals, ')
          ..write('currency: $currency, ')
          ..write('monthlyIncome: $monthlyIncome, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('savingsGoal: $savingsGoal, ')
          ..write('financialPriorities: $financialPriorities, ')
          ..write('lifeGoals: $lifeGoals, ')
          ..write('learningGoals: $learningGoals, ')
          ..write('focusAreas: $focusAreas, ')
          ..write('reminderPreference: $reminderPreference, ')
          ..write('aiPersonality: $aiPersonality, ')
          ..write('notificationPreference: $notificationPreference, ')
          ..write('themePreference: $themePreference, ')
          ..write('privacyPreference: $privacyPreference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryTableTable extends MemoryTable
    with TableInfo<$MemoryTableTable, MemoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoryIdMeta = const VerificationMeta(
    'memoryId',
  );
  @override
  late final GeneratedColumn<String> memoryId = GeneratedColumn<String>(
    'memory_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _domainIdMeta = const VerificationMeta(
    'domainId',
  );
  @override
  late final GeneratedColumn<int> domainId = GeneratedColumn<int>(
    'domain_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importanceMeta = const VerificationMeta(
    'importance',
  );
  @override
  late final GeneratedColumn<double> importance = GeneratedColumn<double>(
    'importance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.5),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provenanceMeta = const VerificationMeta(
    'provenance',
  );
  @override
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
    'provenance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeTypeMeta = const VerificationMeta(
    'changeType',
  );
  @override
  late final GeneratedColumn<String> changeType = GeneratedColumn<String>(
    'change_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasoningMeta = const VerificationMeta(
    'reasoning',
  );
  @override
  late final GeneratedColumn<String> reasoning = GeneratedColumn<String>(
    'reasoning',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<String> delta = GeneratedColumn<String>(
    'delta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effectiveAtMeta = const VerificationMeta(
    'effectiveAt',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveAt = GeneratedColumn<DateTime>(
    'effective_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastVerifiedAtMeta = const VerificationMeta(
    'lastVerifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastVerifiedAt =
      GeneratedColumn<DateTime>(
        'last_verified_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _verificationHistoryMeta =
      const VerificationMeta('verificationHistory');
  @override
  late final GeneratedColumn<String> verificationHistory =
      GeneratedColumn<String>(
        'verification_history',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _prevVersionIdMeta = const VerificationMeta(
    'prevVersionId',
  );
  @override
  late final GeneratedColumn<String> prevVersionId = GeneratedColumn<String>(
    'prev_version_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES memories (id)',
    ),
  );
  static const VerificationMeta _isLatestMeta = const VerificationMeta(
    'isLatest',
  );
  @override
  late final GeneratedColumn<bool> isLatest = GeneratedColumn<bool>(
    'is_latest',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_latest" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _verifiedMeta = const VerificationMeta(
    'verified',
  );
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
    'verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _knowledgeStateMeta = const VerificationMeta(
    'knowledgeState',
  );
  @override
  late final GeneratedColumn<String> knowledgeState = GeneratedColumn<String>(
    'knowledge_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('observed'),
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _embeddingMeta = const VerificationMeta(
    'embedding',
  );
  @override
  late final GeneratedColumn<String> embedding = GeneratedColumn<String>(
    'embedding',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    memoryId,
    categoryId,
    domainId,
    type,
    content,
    summary,
    importance,
    confidence,
    source,
    provenance,
    changeType,
    reasoning,
    delta,
    effectiveAt,
    recordedAt,
    lastVerifiedAt,
    verificationHistory,
    prevVersionId,
    isLatest,
    verified,
    questionId,
    knowledgeState,
    explanation,
    tags,
    embedding,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('memory_id')) {
      context.handle(
        _memoryIdMeta,
        memoryId.isAcceptableOrUnknown(data['memory_id']!, _memoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memoryIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('domain_id')) {
      context.handle(
        _domainIdMeta,
        domainId.isAcceptableOrUnknown(data['domain_id']!, _domainIdMeta),
      );
    } else if (isInserting) {
      context.missing(_domainIdMeta);
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
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('importance')) {
      context.handle(
        _importanceMeta,
        importance.isAcceptableOrUnknown(data['importance']!, _importanceMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('provenance')) {
      context.handle(
        _provenanceMeta,
        provenance.isAcceptableOrUnknown(data['provenance']!, _provenanceMeta),
      );
    } else if (isInserting) {
      context.missing(_provenanceMeta);
    }
    if (data.containsKey('change_type')) {
      context.handle(
        _changeTypeMeta,
        changeType.isAcceptableOrUnknown(data['change_type']!, _changeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_changeTypeMeta);
    }
    if (data.containsKey('reasoning')) {
      context.handle(
        _reasoningMeta,
        reasoning.isAcceptableOrUnknown(data['reasoning']!, _reasoningMeta),
      );
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    }
    if (data.containsKey('effective_at')) {
      context.handle(
        _effectiveAtMeta,
        effectiveAt.isAcceptableOrUnknown(
          data['effective_at']!,
          _effectiveAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveAtMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('last_verified_at')) {
      context.handle(
        _lastVerifiedAtMeta,
        lastVerifiedAt.isAcceptableOrUnknown(
          data['last_verified_at']!,
          _lastVerifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('verification_history')) {
      context.handle(
        _verificationHistoryMeta,
        verificationHistory.isAcceptableOrUnknown(
          data['verification_history']!,
          _verificationHistoryMeta,
        ),
      );
    }
    if (data.containsKey('prev_version_id')) {
      context.handle(
        _prevVersionIdMeta,
        prevVersionId.isAcceptableOrUnknown(
          data['prev_version_id']!,
          _prevVersionIdMeta,
        ),
      );
    }
    if (data.containsKey('is_latest')) {
      context.handle(
        _isLatestMeta,
        isLatest.isAcceptableOrUnknown(data['is_latest']!, _isLatestMeta),
      );
    }
    if (data.containsKey('verified')) {
      context.handle(
        _verifiedMeta,
        verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta),
      );
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    }
    if (data.containsKey('knowledge_state')) {
      context.handle(
        _knowledgeStateMeta,
        knowledgeState.isAcceptableOrUnknown(
          data['knowledge_state']!,
          _knowledgeStateMeta,
        ),
      );
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('embedding')) {
      context.handle(
        _embeddingMeta,
        embedding.isAcceptableOrUnknown(data['embedding']!, _embeddingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      memoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memory_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      domainId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}domain_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      importance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}importance'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      provenance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provenance'],
      )!,
      changeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_type'],
      )!,
      reasoning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reasoning'],
      ),
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delta'],
      ),
      effectiveAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_at'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      lastVerifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_verified_at'],
      ),
      verificationHistory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification_history'],
      ),
      prevVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prev_version_id'],
      ),
      isLatest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_latest'],
      )!,
      verified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}verified'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      ),
      knowledgeState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}knowledge_state'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      embedding: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}embedding'],
      ),
    );
  }

  @override
  $MemoryTableTable createAlias(String alias) {
    return $MemoryTableTable(attachedDatabase, alias);
  }
}

class MemoryTableData extends DataClass implements Insertable<MemoryTableData> {
  final String id;
  final DateTime createdAt;

  /// Last modification timestamp.
  final DateTime updatedAt;

  /// Incremental version number.
  final int version;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String syncStatus;
  final String? deviceId;

  /// Logical identifier for the fact chain (Single Source of Truth key).
  final String memoryId;

  /// Primary category (11 Books).
  final int categoryId;

  /// Specific domain (30 Domains).
  final int domainId;

  /// identity or event.
  final String type;

  /// JSON payload conforming to domain schema.
  final String content;

  /// Optional short description.
  final String? summary;

  /// 0.0 to 1.0.
  final double importance;

  /// 0.0 to 1.0 (Calculated or stated).
  final double confidence;

  /// manual, imported, ai_generated, sensor.
  final String source;

  /// Origin details.
  final String provenance;

  /// creation, evolution, etc.
  final String changeType;

  /// Logical justification for the version.
  final String? reasoning;

  /// JSON map of fields that changed.
  final String? delta;

  /// Timeline timestamp.
  final DateTime effectiveAt;

  /// Storage timestamp.
  final DateTime recordedAt;

  /// When the user last confirmed this memory.
  final DateTime? lastVerifiedAt;

  /// JSON list of verification events.
  final String? verificationHistory;

  /// Foreign key to previous version within the chain.
  final String? prevVersionId;

  /// Current state flag for optimized queries.
  final bool isLatest;

  /// Whether the owner has explicitly verified this information.
  final bool verified;

  /// Link back to the specific inquiry in the Question Bank.
  final String? questionId;

  /// Lifecycle state: observed, inferred, userConfirmed, userCorrected, deprecated.
  final String knowledgeState;

  /// Human-readable reasoning for inferred knowledge.
  final String? explanation;

  /// Comma-separated or JSON list of labels.
  final String tags;

  /// Reserved for future vector support (JSON string of doubles).
  final String? embedding;
  const MemoryTableData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.syncStatus,
    this.deviceId,
    required this.memoryId,
    required this.categoryId,
    required this.domainId,
    required this.type,
    required this.content,
    this.summary,
    required this.importance,
    required this.confidence,
    required this.source,
    required this.provenance,
    required this.changeType,
    this.reasoning,
    this.delta,
    required this.effectiveAt,
    required this.recordedAt,
    this.lastVerifiedAt,
    this.verificationHistory,
    this.prevVersionId,
    required this.isLatest,
    required this.verified,
    this.questionId,
    required this.knowledgeState,
    this.explanation,
    required this.tags,
    this.embedding,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['memory_id'] = Variable<String>(memoryId);
    map['category_id'] = Variable<int>(categoryId);
    map['domain_id'] = Variable<int>(domainId);
    map['type'] = Variable<String>(type);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['importance'] = Variable<double>(importance);
    map['confidence'] = Variable<double>(confidence);
    map['source'] = Variable<String>(source);
    map['provenance'] = Variable<String>(provenance);
    map['change_type'] = Variable<String>(changeType);
    if (!nullToAbsent || reasoning != null) {
      map['reasoning'] = Variable<String>(reasoning);
    }
    if (!nullToAbsent || delta != null) {
      map['delta'] = Variable<String>(delta);
    }
    map['effective_at'] = Variable<DateTime>(effectiveAt);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    if (!nullToAbsent || lastVerifiedAt != null) {
      map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt);
    }
    if (!nullToAbsent || verificationHistory != null) {
      map['verification_history'] = Variable<String>(verificationHistory);
    }
    if (!nullToAbsent || prevVersionId != null) {
      map['prev_version_id'] = Variable<String>(prevVersionId);
    }
    map['is_latest'] = Variable<bool>(isLatest);
    map['verified'] = Variable<bool>(verified);
    if (!nullToAbsent || questionId != null) {
      map['question_id'] = Variable<String>(questionId);
    }
    map['knowledge_state'] = Variable<String>(knowledgeState);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || embedding != null) {
      map['embedding'] = Variable<String>(embedding);
    }
    return map;
  }

  MemoryTableCompanion toCompanion(bool nullToAbsent) {
    return MemoryTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      memoryId: Value(memoryId),
      categoryId: Value(categoryId),
      domainId: Value(domainId),
      type: Value(type),
      content: Value(content),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      importance: Value(importance),
      confidence: Value(confidence),
      source: Value(source),
      provenance: Value(provenance),
      changeType: Value(changeType),
      reasoning: reasoning == null && nullToAbsent
          ? const Value.absent()
          : Value(reasoning),
      delta: delta == null && nullToAbsent
          ? const Value.absent()
          : Value(delta),
      effectiveAt: Value(effectiveAt),
      recordedAt: Value(recordedAt),
      lastVerifiedAt: lastVerifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVerifiedAt),
      verificationHistory: verificationHistory == null && nullToAbsent
          ? const Value.absent()
          : Value(verificationHistory),
      prevVersionId: prevVersionId == null && nullToAbsent
          ? const Value.absent()
          : Value(prevVersionId),
      isLatest: Value(isLatest),
      verified: Value(verified),
      questionId: questionId == null && nullToAbsent
          ? const Value.absent()
          : Value(questionId),
      knowledgeState: Value(knowledgeState),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      tags: Value(tags),
      embedding: embedding == null && nullToAbsent
          ? const Value.absent()
          : Value(embedding),
    );
  }

  factory MemoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryTableData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      memoryId: serializer.fromJson<String>(json['memoryId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      domainId: serializer.fromJson<int>(json['domainId']),
      type: serializer.fromJson<String>(json['type']),
      content: serializer.fromJson<String>(json['content']),
      summary: serializer.fromJson<String?>(json['summary']),
      importance: serializer.fromJson<double>(json['importance']),
      confidence: serializer.fromJson<double>(json['confidence']),
      source: serializer.fromJson<String>(json['source']),
      provenance: serializer.fromJson<String>(json['provenance']),
      changeType: serializer.fromJson<String>(json['changeType']),
      reasoning: serializer.fromJson<String?>(json['reasoning']),
      delta: serializer.fromJson<String?>(json['delta']),
      effectiveAt: serializer.fromJson<DateTime>(json['effectiveAt']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      lastVerifiedAt: serializer.fromJson<DateTime?>(json['lastVerifiedAt']),
      verificationHistory: serializer.fromJson<String?>(
        json['verificationHistory'],
      ),
      prevVersionId: serializer.fromJson<String?>(json['prevVersionId']),
      isLatest: serializer.fromJson<bool>(json['isLatest']),
      verified: serializer.fromJson<bool>(json['verified']),
      questionId: serializer.fromJson<String?>(json['questionId']),
      knowledgeState: serializer.fromJson<String>(json['knowledgeState']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      tags: serializer.fromJson<String>(json['tags']),
      embedding: serializer.fromJson<String?>(json['embedding']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deviceId': serializer.toJson<String?>(deviceId),
      'memoryId': serializer.toJson<String>(memoryId),
      'categoryId': serializer.toJson<int>(categoryId),
      'domainId': serializer.toJson<int>(domainId),
      'type': serializer.toJson<String>(type),
      'content': serializer.toJson<String>(content),
      'summary': serializer.toJson<String?>(summary),
      'importance': serializer.toJson<double>(importance),
      'confidence': serializer.toJson<double>(confidence),
      'source': serializer.toJson<String>(source),
      'provenance': serializer.toJson<String>(provenance),
      'changeType': serializer.toJson<String>(changeType),
      'reasoning': serializer.toJson<String?>(reasoning),
      'delta': serializer.toJson<String?>(delta),
      'effectiveAt': serializer.toJson<DateTime>(effectiveAt),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'lastVerifiedAt': serializer.toJson<DateTime?>(lastVerifiedAt),
      'verificationHistory': serializer.toJson<String?>(verificationHistory),
      'prevVersionId': serializer.toJson<String?>(prevVersionId),
      'isLatest': serializer.toJson<bool>(isLatest),
      'verified': serializer.toJson<bool>(verified),
      'questionId': serializer.toJson<String?>(questionId),
      'knowledgeState': serializer.toJson<String>(knowledgeState),
      'explanation': serializer.toJson<String?>(explanation),
      'tags': serializer.toJson<String>(tags),
      'embedding': serializer.toJson<String?>(embedding),
    };
  }

  MemoryTableData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> deviceId = const Value.absent(),
    String? memoryId,
    int? categoryId,
    int? domainId,
    String? type,
    String? content,
    Value<String?> summary = const Value.absent(),
    double? importance,
    double? confidence,
    String? source,
    String? provenance,
    String? changeType,
    Value<String?> reasoning = const Value.absent(),
    Value<String?> delta = const Value.absent(),
    DateTime? effectiveAt,
    DateTime? recordedAt,
    Value<DateTime?> lastVerifiedAt = const Value.absent(),
    Value<String?> verificationHistory = const Value.absent(),
    Value<String?> prevVersionId = const Value.absent(),
    bool? isLatest,
    bool? verified,
    Value<String?> questionId = const Value.absent(),
    String? knowledgeState,
    Value<String?> explanation = const Value.absent(),
    String? tags,
    Value<String?> embedding = const Value.absent(),
  }) => MemoryTableData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    memoryId: memoryId ?? this.memoryId,
    categoryId: categoryId ?? this.categoryId,
    domainId: domainId ?? this.domainId,
    type: type ?? this.type,
    content: content ?? this.content,
    summary: summary.present ? summary.value : this.summary,
    importance: importance ?? this.importance,
    confidence: confidence ?? this.confidence,
    source: source ?? this.source,
    provenance: provenance ?? this.provenance,
    changeType: changeType ?? this.changeType,
    reasoning: reasoning.present ? reasoning.value : this.reasoning,
    delta: delta.present ? delta.value : this.delta,
    effectiveAt: effectiveAt ?? this.effectiveAt,
    recordedAt: recordedAt ?? this.recordedAt,
    lastVerifiedAt: lastVerifiedAt.present
        ? lastVerifiedAt.value
        : this.lastVerifiedAt,
    verificationHistory: verificationHistory.present
        ? verificationHistory.value
        : this.verificationHistory,
    prevVersionId: prevVersionId.present
        ? prevVersionId.value
        : this.prevVersionId,
    isLatest: isLatest ?? this.isLatest,
    verified: verified ?? this.verified,
    questionId: questionId.present ? questionId.value : this.questionId,
    knowledgeState: knowledgeState ?? this.knowledgeState,
    explanation: explanation.present ? explanation.value : this.explanation,
    tags: tags ?? this.tags,
    embedding: embedding.present ? embedding.value : this.embedding,
  );
  MemoryTableData copyWithCompanion(MemoryTableCompanion data) {
    return MemoryTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      memoryId: data.memoryId.present ? data.memoryId.value : this.memoryId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      domainId: data.domainId.present ? data.domainId.value : this.domainId,
      type: data.type.present ? data.type.value : this.type,
      content: data.content.present ? data.content.value : this.content,
      summary: data.summary.present ? data.summary.value : this.summary,
      importance: data.importance.present
          ? data.importance.value
          : this.importance,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      source: data.source.present ? data.source.value : this.source,
      provenance: data.provenance.present
          ? data.provenance.value
          : this.provenance,
      changeType: data.changeType.present
          ? data.changeType.value
          : this.changeType,
      reasoning: data.reasoning.present ? data.reasoning.value : this.reasoning,
      delta: data.delta.present ? data.delta.value : this.delta,
      effectiveAt: data.effectiveAt.present
          ? data.effectiveAt.value
          : this.effectiveAt,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      lastVerifiedAt: data.lastVerifiedAt.present
          ? data.lastVerifiedAt.value
          : this.lastVerifiedAt,
      verificationHistory: data.verificationHistory.present
          ? data.verificationHistory.value
          : this.verificationHistory,
      prevVersionId: data.prevVersionId.present
          ? data.prevVersionId.value
          : this.prevVersionId,
      isLatest: data.isLatest.present ? data.isLatest.value : this.isLatest,
      verified: data.verified.present ? data.verified.value : this.verified,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      knowledgeState: data.knowledgeState.present
          ? data.knowledgeState.value
          : this.knowledgeState,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      tags: data.tags.present ? data.tags.value : this.tags,
      embedding: data.embedding.present ? data.embedding.value : this.embedding,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('memoryId: $memoryId, ')
          ..write('categoryId: $categoryId, ')
          ..write('domainId: $domainId, ')
          ..write('type: $type, ')
          ..write('content: $content, ')
          ..write('summary: $summary, ')
          ..write('importance: $importance, ')
          ..write('confidence: $confidence, ')
          ..write('source: $source, ')
          ..write('provenance: $provenance, ')
          ..write('changeType: $changeType, ')
          ..write('reasoning: $reasoning, ')
          ..write('delta: $delta, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('lastVerifiedAt: $lastVerifiedAt, ')
          ..write('verificationHistory: $verificationHistory, ')
          ..write('prevVersionId: $prevVersionId, ')
          ..write('isLatest: $isLatest, ')
          ..write('verified: $verified, ')
          ..write('questionId: $questionId, ')
          ..write('knowledgeState: $knowledgeState, ')
          ..write('explanation: $explanation, ')
          ..write('tags: $tags, ')
          ..write('embedding: $embedding')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    memoryId,
    categoryId,
    domainId,
    type,
    content,
    summary,
    importance,
    confidence,
    source,
    provenance,
    changeType,
    reasoning,
    delta,
    effectiveAt,
    recordedAt,
    lastVerifiedAt,
    verificationHistory,
    prevVersionId,
    isLatest,
    verified,
    questionId,
    knowledgeState,
    explanation,
    tags,
    embedding,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId &&
          other.memoryId == this.memoryId &&
          other.categoryId == this.categoryId &&
          other.domainId == this.domainId &&
          other.type == this.type &&
          other.content == this.content &&
          other.summary == this.summary &&
          other.importance == this.importance &&
          other.confidence == this.confidence &&
          other.source == this.source &&
          other.provenance == this.provenance &&
          other.changeType == this.changeType &&
          other.reasoning == this.reasoning &&
          other.delta == this.delta &&
          other.effectiveAt == this.effectiveAt &&
          other.recordedAt == this.recordedAt &&
          other.lastVerifiedAt == this.lastVerifiedAt &&
          other.verificationHistory == this.verificationHistory &&
          other.prevVersionId == this.prevVersionId &&
          other.isLatest == this.isLatest &&
          other.verified == this.verified &&
          other.questionId == this.questionId &&
          other.knowledgeState == this.knowledgeState &&
          other.explanation == this.explanation &&
          other.tags == this.tags &&
          other.embedding == this.embedding);
}

class MemoryTableCompanion extends UpdateCompanion<MemoryTableData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> deviceId;
  final Value<String> memoryId;
  final Value<int> categoryId;
  final Value<int> domainId;
  final Value<String> type;
  final Value<String> content;
  final Value<String?> summary;
  final Value<double> importance;
  final Value<double> confidence;
  final Value<String> source;
  final Value<String> provenance;
  final Value<String> changeType;
  final Value<String?> reasoning;
  final Value<String?> delta;
  final Value<DateTime> effectiveAt;
  final Value<DateTime> recordedAt;
  final Value<DateTime?> lastVerifiedAt;
  final Value<String?> verificationHistory;
  final Value<String?> prevVersionId;
  final Value<bool> isLatest;
  final Value<bool> verified;
  final Value<String?> questionId;
  final Value<String> knowledgeState;
  final Value<String?> explanation;
  final Value<String> tags;
  final Value<String?> embedding;
  final Value<int> rowid;
  const MemoryTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.memoryId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.domainId = const Value.absent(),
    this.type = const Value.absent(),
    this.content = const Value.absent(),
    this.summary = const Value.absent(),
    this.importance = const Value.absent(),
    this.confidence = const Value.absent(),
    this.source = const Value.absent(),
    this.provenance = const Value.absent(),
    this.changeType = const Value.absent(),
    this.reasoning = const Value.absent(),
    this.delta = const Value.absent(),
    this.effectiveAt = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.lastVerifiedAt = const Value.absent(),
    this.verificationHistory = const Value.absent(),
    this.prevVersionId = const Value.absent(),
    this.isLatest = const Value.absent(),
    this.verified = const Value.absent(),
    this.questionId = const Value.absent(),
    this.knowledgeState = const Value.absent(),
    this.explanation = const Value.absent(),
    this.tags = const Value.absent(),
    this.embedding = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryTableCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String memoryId,
    required int categoryId,
    required int domainId,
    required String type,
    required String content,
    this.summary = const Value.absent(),
    this.importance = const Value.absent(),
    this.confidence = const Value.absent(),
    required String source,
    required String provenance,
    required String changeType,
    this.reasoning = const Value.absent(),
    this.delta = const Value.absent(),
    required DateTime effectiveAt,
    required DateTime recordedAt,
    this.lastVerifiedAt = const Value.absent(),
    this.verificationHistory = const Value.absent(),
    this.prevVersionId = const Value.absent(),
    this.isLatest = const Value.absent(),
    this.verified = const Value.absent(),
    this.questionId = const Value.absent(),
    this.knowledgeState = const Value.absent(),
    this.explanation = const Value.absent(),
    this.tags = const Value.absent(),
    this.embedding = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memoryId = Value(memoryId),
       categoryId = Value(categoryId),
       domainId = Value(domainId),
       type = Value(type),
       content = Value(content),
       source = Value(source),
       provenance = Value(provenance),
       changeType = Value(changeType),
       effectiveAt = Value(effectiveAt),
       recordedAt = Value(recordedAt);
  static Insertable<MemoryTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<String>? memoryId,
    Expression<int>? categoryId,
    Expression<int>? domainId,
    Expression<String>? type,
    Expression<String>? content,
    Expression<String>? summary,
    Expression<double>? importance,
    Expression<double>? confidence,
    Expression<String>? source,
    Expression<String>? provenance,
    Expression<String>? changeType,
    Expression<String>? reasoning,
    Expression<String>? delta,
    Expression<DateTime>? effectiveAt,
    Expression<DateTime>? recordedAt,
    Expression<DateTime>? lastVerifiedAt,
    Expression<String>? verificationHistory,
    Expression<String>? prevVersionId,
    Expression<bool>? isLatest,
    Expression<bool>? verified,
    Expression<String>? questionId,
    Expression<String>? knowledgeState,
    Expression<String>? explanation,
    Expression<String>? tags,
    Expression<String>? embedding,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (memoryId != null) 'memory_id': memoryId,
      if (categoryId != null) 'category_id': categoryId,
      if (domainId != null) 'domain_id': domainId,
      if (type != null) 'type': type,
      if (content != null) 'content': content,
      if (summary != null) 'summary': summary,
      if (importance != null) 'importance': importance,
      if (confidence != null) 'confidence': confidence,
      if (source != null) 'source': source,
      if (provenance != null) 'provenance': provenance,
      if (changeType != null) 'change_type': changeType,
      if (reasoning != null) 'reasoning': reasoning,
      if (delta != null) 'delta': delta,
      if (effectiveAt != null) 'effective_at': effectiveAt,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (lastVerifiedAt != null) 'last_verified_at': lastVerifiedAt,
      if (verificationHistory != null)
        'verification_history': verificationHistory,
      if (prevVersionId != null) 'prev_version_id': prevVersionId,
      if (isLatest != null) 'is_latest': isLatest,
      if (verified != null) 'verified': verified,
      if (questionId != null) 'question_id': questionId,
      if (knowledgeState != null) 'knowledge_state': knowledgeState,
      if (explanation != null) 'explanation': explanation,
      if (tags != null) 'tags': tags,
      if (embedding != null) 'embedding': embedding,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<String?>? deviceId,
    Value<String>? memoryId,
    Value<int>? categoryId,
    Value<int>? domainId,
    Value<String>? type,
    Value<String>? content,
    Value<String?>? summary,
    Value<double>? importance,
    Value<double>? confidence,
    Value<String>? source,
    Value<String>? provenance,
    Value<String>? changeType,
    Value<String?>? reasoning,
    Value<String?>? delta,
    Value<DateTime>? effectiveAt,
    Value<DateTime>? recordedAt,
    Value<DateTime?>? lastVerifiedAt,
    Value<String?>? verificationHistory,
    Value<String?>? prevVersionId,
    Value<bool>? isLatest,
    Value<bool>? verified,
    Value<String?>? questionId,
    Value<String>? knowledgeState,
    Value<String?>? explanation,
    Value<String>? tags,
    Value<String?>? embedding,
    Value<int>? rowid,
  }) {
    return MemoryTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      memoryId: memoryId ?? this.memoryId,
      categoryId: categoryId ?? this.categoryId,
      domainId: domainId ?? this.domainId,
      type: type ?? this.type,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      importance: importance ?? this.importance,
      confidence: confidence ?? this.confidence,
      source: source ?? this.source,
      provenance: provenance ?? this.provenance,
      changeType: changeType ?? this.changeType,
      reasoning: reasoning ?? this.reasoning,
      delta: delta ?? this.delta,
      effectiveAt: effectiveAt ?? this.effectiveAt,
      recordedAt: recordedAt ?? this.recordedAt,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      verificationHistory: verificationHistory ?? this.verificationHistory,
      prevVersionId: prevVersionId ?? this.prevVersionId,
      isLatest: isLatest ?? this.isLatest,
      verified: verified ?? this.verified,
      questionId: questionId ?? this.questionId,
      knowledgeState: knowledgeState ?? this.knowledgeState,
      explanation: explanation ?? this.explanation,
      tags: tags ?? this.tags,
      embedding: embedding ?? this.embedding,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (memoryId.present) {
      map['memory_id'] = Variable<String>(memoryId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (domainId.present) {
      map['domain_id'] = Variable<int>(domainId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (importance.present) {
      map['importance'] = Variable<double>(importance.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (provenance.present) {
      map['provenance'] = Variable<String>(provenance.value);
    }
    if (changeType.present) {
      map['change_type'] = Variable<String>(changeType.value);
    }
    if (reasoning.present) {
      map['reasoning'] = Variable<String>(reasoning.value);
    }
    if (delta.present) {
      map['delta'] = Variable<String>(delta.value);
    }
    if (effectiveAt.present) {
      map['effective_at'] = Variable<DateTime>(effectiveAt.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (lastVerifiedAt.present) {
      map['last_verified_at'] = Variable<DateTime>(lastVerifiedAt.value);
    }
    if (verificationHistory.present) {
      map['verification_history'] = Variable<String>(verificationHistory.value);
    }
    if (prevVersionId.present) {
      map['prev_version_id'] = Variable<String>(prevVersionId.value);
    }
    if (isLatest.present) {
      map['is_latest'] = Variable<bool>(isLatest.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (knowledgeState.present) {
      map['knowledge_state'] = Variable<String>(knowledgeState.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (embedding.present) {
      map['embedding'] = Variable<String>(embedding.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('memoryId: $memoryId, ')
          ..write('categoryId: $categoryId, ')
          ..write('domainId: $domainId, ')
          ..write('type: $type, ')
          ..write('content: $content, ')
          ..write('summary: $summary, ')
          ..write('importance: $importance, ')
          ..write('confidence: $confidence, ')
          ..write('source: $source, ')
          ..write('provenance: $provenance, ')
          ..write('changeType: $changeType, ')
          ..write('reasoning: $reasoning, ')
          ..write('delta: $delta, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('lastVerifiedAt: $lastVerifiedAt, ')
          ..write('verificationHistory: $verificationHistory, ')
          ..write('prevVersionId: $prevVersionId, ')
          ..write('isLatest: $isLatest, ')
          ..write('verified: $verified, ')
          ..write('questionId: $questionId, ')
          ..write('knowledgeState: $knowledgeState, ')
          ..write('explanation: $explanation, ')
          ..write('tags: $tags, ')
          ..write('embedding: $embedding, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoryRelationTableTable extends MemoryRelationTable
    with TableInfo<$MemoryRelationTableTable, MemoryRelationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryRelationTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    requiredDuringInsert: true,
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<double> strength = GeneratedColumn<double>(
    'strength',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    sourceId,
    targetId,
    type,
    strength,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryRelationData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryRelationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryRelationData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}strength'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      )!,
    );
  }

  @override
  $MemoryRelationTableTable createAlias(String alias) {
    return $MemoryRelationTableTable(attachedDatabase, alias);
  }
}

class MemoryRelationData extends DataClass
    implements Insertable<MemoryRelationData> {
  final String id;

  /// When the relationship was established.
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String syncStatus;
  final String? deviceId;

  /// Source memory node (MemoryID).
  final String sourceId;

  /// Target memory node (MemoryID).
  final String targetId;

  /// parent, child, influences, caused_by, duplicate, derived_from, references.
  final String type;

  /// 0.0 to 1.0 link strength.
  final double strength;

  /// JSON metadata for the edge.
  final String metadata;
  const MemoryRelationData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.syncStatus,
    this.deviceId,
    required this.sourceId,
    required this.targetId,
    required this.type,
    required this.strength,
    required this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['source_id'] = Variable<String>(sourceId);
    map['target_id'] = Variable<String>(targetId);
    map['type'] = Variable<String>(type);
    map['strength'] = Variable<double>(strength);
    map['metadata'] = Variable<String>(metadata);
    return map;
  }

  MemoryRelationTableCompanion toCompanion(bool nullToAbsent) {
    return MemoryRelationTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      sourceId: Value(sourceId),
      targetId: Value(targetId),
      type: Value(type),
      strength: Value(strength),
      metadata: Value(metadata),
    );
  }

  factory MemoryRelationData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryRelationData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      targetId: serializer.fromJson<String>(json['targetId']),
      type: serializer.fromJson<String>(json['type']),
      strength: serializer.fromJson<double>(json['strength']),
      metadata: serializer.fromJson<String>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deviceId': serializer.toJson<String?>(deviceId),
      'sourceId': serializer.toJson<String>(sourceId),
      'targetId': serializer.toJson<String>(targetId),
      'type': serializer.toJson<String>(type),
      'strength': serializer.toJson<double>(strength),
      'metadata': serializer.toJson<String>(metadata),
    };
  }

  MemoryRelationData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> deviceId = const Value.absent(),
    String? sourceId,
    String? targetId,
    String? type,
    double? strength,
    String? metadata,
  }) => MemoryRelationData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    sourceId: sourceId ?? this.sourceId,
    targetId: targetId ?? this.targetId,
    type: type ?? this.type,
    strength: strength ?? this.strength,
    metadata: metadata ?? this.metadata,
  );
  MemoryRelationData copyWithCompanion(MemoryRelationTableCompanion data) {
    return MemoryRelationData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      type: data.type.present ? data.type.value : this.type,
      strength: data.strength.present ? data.strength.value : this.strength,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryRelationData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('type: $type, ')
          ..write('strength: $strength, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    sourceId,
    targetId,
    type,
    strength,
    metadata,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryRelationData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId &&
          other.sourceId == this.sourceId &&
          other.targetId == this.targetId &&
          other.type == this.type &&
          other.strength == this.strength &&
          other.metadata == this.metadata);
}

class MemoryRelationTableCompanion extends UpdateCompanion<MemoryRelationData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> deviceId;
  final Value<String> sourceId;
  final Value<String> targetId;
  final Value<String> type;
  final Value<double> strength;
  final Value<String> metadata;
  final Value<int> rowid;
  const MemoryRelationTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.targetId = const Value.absent(),
    this.type = const Value.absent(),
    this.strength = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoryRelationTableCompanion.insert({
    required String id,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String sourceId,
    required String targetId,
    required String type,
    this.strength = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       sourceId = Value(sourceId),
       targetId = Value(targetId),
       type = Value(type);
  static Insertable<MemoryRelationData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<String>? sourceId,
    Expression<String>? targetId,
    Expression<String>? type,
    Expression<double>? strength,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (sourceId != null) 'source_id': sourceId,
      if (targetId != null) 'target_id': targetId,
      if (type != null) 'type': type,
      if (strength != null) 'strength': strength,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoryRelationTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<String?>? deviceId,
    Value<String>? sourceId,
    Value<String>? targetId,
    Value<String>? type,
    Value<double>? strength,
    Value<String>? metadata,
    Value<int>? rowid,
  }) {
    return MemoryRelationTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      type: type ?? this.type,
      strength: strength ?? this.strength,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (strength.present) {
      map['strength'] = Variable<double>(strength.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryRelationTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('type: $type, ')
          ..write('strength: $strength, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EvidenceTableTable extends EvidenceTable
    with TableInfo<$EvidenceTableTable, EvidenceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidenceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caidMeta = const VerificationMeta('caid');
  @override
  late final GeneratedColumn<String> caid = GeneratedColumn<String>(
    'caid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalNameMeta = const VerificationMeta(
    'originalName',
  );
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
    'original_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingestedAtMeta = const VerificationMeta(
    'ingestedAt',
  );
  @override
  late final GeneratedColumn<DateTime> ingestedAt = GeneratedColumn<DateTime>(
    'ingested_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storagePathMeta = const VerificationMeta(
    'storagePath',
  );
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
    'storage_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractionDataMeta = const VerificationMeta(
    'extractionData',
  );
  @override
  late final GeneratedColumn<String> extractionData = GeneratedColumn<String>(
    'extraction_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    caid,
    originalName,
    mimeType,
    fileSize,
    ingestedAt,
    storagePath,
    extractionData,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidence';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvidenceTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('caid')) {
      context.handle(
        _caidMeta,
        caid.isAcceptableOrUnknown(data['caid']!, _caidMeta),
      );
    } else if (isInserting) {
      context.missing(_caidMeta);
    }
    if (data.containsKey('original_name')) {
      context.handle(
        _originalNameMeta,
        originalName.isAcceptableOrUnknown(
          data['original_name']!,
          _originalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalNameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('ingested_at')) {
      context.handle(
        _ingestedAtMeta,
        ingestedAt.isAcceptableOrUnknown(data['ingested_at']!, _ingestedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_ingestedAtMeta);
    }
    if (data.containsKey('storage_path')) {
      context.handle(
        _storagePathMeta,
        storagePath.isAcceptableOrUnknown(
          data['storage_path']!,
          _storagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_storagePathMeta);
    }
    if (data.containsKey('extraction_data')) {
      context.handle(
        _extractionDataMeta,
        extractionData.isAcceptableOrUnknown(
          data['extraction_data']!,
          _extractionDataMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {caid};
  @override
  EvidenceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      caid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caid'],
      )!,
      originalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_name'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      ingestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ingested_at'],
      )!,
      storagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_path'],
      )!,
      extractionData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extraction_data'],
      )!,
    );
  }

  @override
  $EvidenceTableTable createAlias(String alias) {
    return $EvidenceTableTable(attachedDatabase, alias);
  }
}

class EvidenceTableData extends DataClass
    implements Insertable<EvidenceTableData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String syncStatus;
  final String? deviceId;

  /// SHA-256 hash of the content (Primary Key).
  final String caid;

  /// Original name of the file during ingestion.
  final String originalName;

  /// MIME type (e.g. application/pdf, image/jpeg).
  final String mimeType;

  /// Size in bytes.
  final int fileSize;

  /// When the artifact was first seen by Knight.
  final DateTime ingestedAt;

  /// Path within the internal Evidence Vault.
  final String storagePath;

  /// Extracted JSON data (OCR, EXIF, etc.).
  final String extractionData;
  const EvidenceTableData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.syncStatus,
    this.deviceId,
    required this.caid,
    required this.originalName,
    required this.mimeType,
    required this.fileSize,
    required this.ingestedAt,
    required this.storagePath,
    required this.extractionData,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['caid'] = Variable<String>(caid);
    map['original_name'] = Variable<String>(originalName);
    map['mime_type'] = Variable<String>(mimeType);
    map['file_size'] = Variable<int>(fileSize);
    map['ingested_at'] = Variable<DateTime>(ingestedAt);
    map['storage_path'] = Variable<String>(storagePath);
    map['extraction_data'] = Variable<String>(extractionData);
    return map;
  }

  EvidenceTableCompanion toCompanion(bool nullToAbsent) {
    return EvidenceTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      caid: Value(caid),
      originalName: Value(originalName),
      mimeType: Value(mimeType),
      fileSize: Value(fileSize),
      ingestedAt: Value(ingestedAt),
      storagePath: Value(storagePath),
      extractionData: Value(extractionData),
    );
  }

  factory EvidenceTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceTableData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      caid: serializer.fromJson<String>(json['caid']),
      originalName: serializer.fromJson<String>(json['originalName']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      ingestedAt: serializer.fromJson<DateTime>(json['ingestedAt']),
      storagePath: serializer.fromJson<String>(json['storagePath']),
      extractionData: serializer.fromJson<String>(json['extractionData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deviceId': serializer.toJson<String?>(deviceId),
      'caid': serializer.toJson<String>(caid),
      'originalName': serializer.toJson<String>(originalName),
      'mimeType': serializer.toJson<String>(mimeType),
      'fileSize': serializer.toJson<int>(fileSize),
      'ingestedAt': serializer.toJson<DateTime>(ingestedAt),
      'storagePath': serializer.toJson<String>(storagePath),
      'extractionData': serializer.toJson<String>(extractionData),
    };
  }

  EvidenceTableData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> deviceId = const Value.absent(),
    String? caid,
    String? originalName,
    String? mimeType,
    int? fileSize,
    DateTime? ingestedAt,
    String? storagePath,
    String? extractionData,
  }) => EvidenceTableData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    caid: caid ?? this.caid,
    originalName: originalName ?? this.originalName,
    mimeType: mimeType ?? this.mimeType,
    fileSize: fileSize ?? this.fileSize,
    ingestedAt: ingestedAt ?? this.ingestedAt,
    storagePath: storagePath ?? this.storagePath,
    extractionData: extractionData ?? this.extractionData,
  );
  EvidenceTableData copyWithCompanion(EvidenceTableCompanion data) {
    return EvidenceTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      caid: data.caid.present ? data.caid.value : this.caid,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      ingestedAt: data.ingestedAt.present
          ? data.ingestedAt.value
          : this.ingestedAt,
      storagePath: data.storagePath.present
          ? data.storagePath.value
          : this.storagePath,
      extractionData: data.extractionData.present
          ? data.extractionData.value
          : this.extractionData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('caid: $caid, ')
          ..write('originalName: $originalName, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('ingestedAt: $ingestedAt, ')
          ..write('storagePath: $storagePath, ')
          ..write('extractionData: $extractionData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    caid,
    originalName,
    mimeType,
    fileSize,
    ingestedAt,
    storagePath,
    extractionData,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId &&
          other.caid == this.caid &&
          other.originalName == this.originalName &&
          other.mimeType == this.mimeType &&
          other.fileSize == this.fileSize &&
          other.ingestedAt == this.ingestedAt &&
          other.storagePath == this.storagePath &&
          other.extractionData == this.extractionData);
}

class EvidenceTableCompanion extends UpdateCompanion<EvidenceTableData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> deviceId;
  final Value<String> caid;
  final Value<String> originalName;
  final Value<String> mimeType;
  final Value<int> fileSize;
  final Value<DateTime> ingestedAt;
  final Value<String> storagePath;
  final Value<String> extractionData;
  final Value<int> rowid;
  const EvidenceTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.caid = const Value.absent(),
    this.originalName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.ingestedAt = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.extractionData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidenceTableCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String caid,
    required String originalName,
    required String mimeType,
    required int fileSize,
    required DateTime ingestedAt,
    required String storagePath,
    this.extractionData = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       caid = Value(caid),
       originalName = Value(originalName),
       mimeType = Value(mimeType),
       fileSize = Value(fileSize),
       ingestedAt = Value(ingestedAt),
       storagePath = Value(storagePath);
  static Insertable<EvidenceTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<String>? caid,
    Expression<String>? originalName,
    Expression<String>? mimeType,
    Expression<int>? fileSize,
    Expression<DateTime>? ingestedAt,
    Expression<String>? storagePath,
    Expression<String>? extractionData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (caid != null) 'caid': caid,
      if (originalName != null) 'original_name': originalName,
      if (mimeType != null) 'mime_type': mimeType,
      if (fileSize != null) 'file_size': fileSize,
      if (ingestedAt != null) 'ingested_at': ingestedAt,
      if (storagePath != null) 'storage_path': storagePath,
      if (extractionData != null) 'extraction_data': extractionData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidenceTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<String?>? deviceId,
    Value<String>? caid,
    Value<String>? originalName,
    Value<String>? mimeType,
    Value<int>? fileSize,
    Value<DateTime>? ingestedAt,
    Value<String>? storagePath,
    Value<String>? extractionData,
    Value<int>? rowid,
  }) {
    return EvidenceTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      caid: caid ?? this.caid,
      originalName: originalName ?? this.originalName,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      ingestedAt: ingestedAt ?? this.ingestedAt,
      storagePath: storagePath ?? this.storagePath,
      extractionData: extractionData ?? this.extractionData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (caid.present) {
      map['caid'] = Variable<String>(caid.value);
    }
    if (originalName.present) {
      map['original_name'] = Variable<String>(originalName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (ingestedAt.present) {
      map['ingested_at'] = Variable<DateTime>(ingestedAt.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (extractionData.present) {
      map['extraction_data'] = Variable<String>(extractionData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('caid: $caid, ')
          ..write('originalName: $originalName, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('ingestedAt: $ingestedAt, ')
          ..write('storagePath: $storagePath, ')
          ..write('extractionData: $extractionData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentTableTable extends AttachmentTable
    with TableInfo<$AttachmentTableTable, AttachmentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoryIdMeta = const VerificationMeta(
    'memoryId',
  );
  @override
  late final GeneratedColumn<String> memoryId = GeneratedColumn<String>(
    'memory_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES memories (id)',
    ),
  );
  static const VerificationMeta _caidMeta = const VerificationMeta('caid');
  @override
  late final GeneratedColumn<String> caid = GeneratedColumn<String>(
    'caid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES evidence (caid)',
    ),
  );
  static const VerificationMeta _fragmentMeta = const VerificationMeta(
    'fragment',
  );
  @override
  late final GeneratedColumn<String> fragment = GeneratedColumn<String>(
    'fragment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    memoryId,
    caid,
    fragment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttachmentTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('memory_id')) {
      context.handle(
        _memoryIdMeta,
        memoryId.isAcceptableOrUnknown(data['memory_id']!, _memoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memoryIdMeta);
    }
    if (data.containsKey('caid')) {
      context.handle(
        _caidMeta,
        caid.isAcceptableOrUnknown(data['caid']!, _caidMeta),
      );
    } else if (isInserting) {
      context.missing(_caidMeta);
    }
    if (data.containsKey('fragment')) {
      context.handle(
        _fragmentMeta,
        fragment.isAcceptableOrUnknown(data['fragment']!, _fragmentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttachmentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttachmentTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      memoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memory_id'],
      )!,
      caid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caid'],
      )!,
      fragment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fragment'],
      ),
    );
  }

  @override
  $AttachmentTableTable createAlias(String alias) {
    return $AttachmentTableTable(attachedDatabase, alias);
  }
}

class AttachmentTableData extends DataClass
    implements Insertable<AttachmentTableData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String syncStatus;
  final String? deviceId;

  /// The memory fact being supported.
  final String memoryId;

  /// The proof artifact (CAID).
  final String caid;

  /// Optional deep-link into the evidence (e.g. page=2).
  final String? fragment;
  const AttachmentTableData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.syncStatus,
    this.deviceId,
    required this.memoryId,
    required this.caid,
    this.fragment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['memory_id'] = Variable<String>(memoryId);
    map['caid'] = Variable<String>(caid);
    if (!nullToAbsent || fragment != null) {
      map['fragment'] = Variable<String>(fragment);
    }
    return map;
  }

  AttachmentTableCompanion toCompanion(bool nullToAbsent) {
    return AttachmentTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      memoryId: Value(memoryId),
      caid: Value(caid),
      fragment: fragment == null && nullToAbsent
          ? const Value.absent()
          : Value(fragment),
    );
  }

  factory AttachmentTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttachmentTableData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      memoryId: serializer.fromJson<String>(json['memoryId']),
      caid: serializer.fromJson<String>(json['caid']),
      fragment: serializer.fromJson<String?>(json['fragment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deviceId': serializer.toJson<String?>(deviceId),
      'memoryId': serializer.toJson<String>(memoryId),
      'caid': serializer.toJson<String>(caid),
      'fragment': serializer.toJson<String?>(fragment),
    };
  }

  AttachmentTableData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> deviceId = const Value.absent(),
    String? memoryId,
    String? caid,
    Value<String?> fragment = const Value.absent(),
  }) => AttachmentTableData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    memoryId: memoryId ?? this.memoryId,
    caid: caid ?? this.caid,
    fragment: fragment.present ? fragment.value : this.fragment,
  );
  AttachmentTableData copyWithCompanion(AttachmentTableCompanion data) {
    return AttachmentTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      memoryId: data.memoryId.present ? data.memoryId.value : this.memoryId,
      caid: data.caid.present ? data.caid.value : this.caid,
      fragment: data.fragment.present ? data.fragment.value : this.fragment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('memoryId: $memoryId, ')
          ..write('caid: $caid, ')
          ..write('fragment: $fragment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    memoryId,
    caid,
    fragment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttachmentTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId &&
          other.memoryId == this.memoryId &&
          other.caid == this.caid &&
          other.fragment == this.fragment);
}

class AttachmentTableCompanion extends UpdateCompanion<AttachmentTableData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> deviceId;
  final Value<String> memoryId;
  final Value<String> caid;
  final Value<String?> fragment;
  final Value<int> rowid;
  const AttachmentTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.memoryId = const Value.absent(),
    this.caid = const Value.absent(),
    this.fragment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentTableCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String memoryId,
    required String caid,
    this.fragment = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       memoryId = Value(memoryId),
       caid = Value(caid);
  static Insertable<AttachmentTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<String>? memoryId,
    Expression<String>? caid,
    Expression<String>? fragment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (memoryId != null) 'memory_id': memoryId,
      if (caid != null) 'caid': caid,
      if (fragment != null) 'fragment': fragment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<String?>? deviceId,
    Value<String>? memoryId,
    Value<String>? caid,
    Value<String?>? fragment,
    Value<int>? rowid,
  }) {
    return AttachmentTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      memoryId: memoryId ?? this.memoryId,
      caid: caid ?? this.caid,
      fragment: fragment ?? this.fragment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (memoryId.present) {
      map['memory_id'] = Variable<String>(memoryId.value);
    }
    if (caid.present) {
      map['caid'] = Variable<String>(caid.value);
    }
    if (fragment.present) {
      map['fragment'] = Variable<String>(fragment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('memoryId: $memoryId, ')
          ..write('caid: $caid, ')
          ..write('fragment: $fragment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTableTable extends AuditLogTable
    with TableInfo<$AuditLogTableTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableNameRefMeta = const VerificationMeta(
    'tableNameRef',
  );
  @override
  late final GeneratedColumn<String> tableNameRef = GeneratedColumn<String>(
    'table_name_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    timestamp,
    operation,
    tableNameRef,
    recordId,
    details,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('table_name_ref')) {
      context.handle(
        _tableNameRefMeta,
        tableNameRef.isAcceptableOrUnknown(
          data['table_name_ref']!,
          _tableNameRefMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tableNameRefMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      tableNameRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name_ref'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
    );
  }

  @override
  $AuditLogTableTable createAlias(String alias) {
    return $AuditLogTableTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String syncStatus;
  final String? deviceId;

  /// When the change occurred.
  final DateTime timestamp;

  /// INSERT, UPDATE, DELETE, DEDUP.
  final String operation;

  /// The affected table.
  final String tableNameRef;

  /// Primary key of the affected record.
  final String recordId;

  /// JSON details of the change or reasoning.
  final String? details;
  const AuditLogData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.syncStatus,
    this.deviceId,
    required this.timestamp,
    required this.operation,
    required this.tableNameRef,
    required this.recordId,
    this.details,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['operation'] = Variable<String>(operation);
    map['table_name_ref'] = Variable<String>(tableNameRef);
    map['record_id'] = Variable<String>(recordId);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    return map;
  }

  AuditLogTableCompanion toCompanion(bool nullToAbsent) {
    return AuditLogTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      timestamp: Value(timestamp),
      operation: Value(operation),
      tableNameRef: Value(tableNameRef),
      recordId: Value(recordId),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      operation: serializer.fromJson<String>(json['operation']),
      tableNameRef: serializer.fromJson<String>(json['tableNameRef']),
      recordId: serializer.fromJson<String>(json['recordId']),
      details: serializer.fromJson<String?>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deviceId': serializer.toJson<String?>(deviceId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'operation': serializer.toJson<String>(operation),
      'tableNameRef': serializer.toJson<String>(tableNameRef),
      'recordId': serializer.toJson<String>(recordId),
      'details': serializer.toJson<String?>(details),
    };
  }

  AuditLogData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> deviceId = const Value.absent(),
    DateTime? timestamp,
    String? operation,
    String? tableNameRef,
    String? recordId,
    Value<String?> details = const Value.absent(),
  }) => AuditLogData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    timestamp: timestamp ?? this.timestamp,
    operation: operation ?? this.operation,
    tableNameRef: tableNameRef ?? this.tableNameRef,
    recordId: recordId ?? this.recordId,
    details: details.present ? details.value : this.details,
  );
  AuditLogData copyWithCompanion(AuditLogTableCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      operation: data.operation.present ? data.operation.value : this.operation,
      tableNameRef: data.tableNameRef.present
          ? data.tableNameRef.value
          : this.tableNameRef,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('timestamp: $timestamp, ')
          ..write('operation: $operation, ')
          ..write('tableNameRef: $tableNameRef, ')
          ..write('recordId: $recordId, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    timestamp,
    operation,
    tableNameRef,
    recordId,
    details,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId &&
          other.timestamp == this.timestamp &&
          other.operation == this.operation &&
          other.tableNameRef == this.tableNameRef &&
          other.recordId == this.recordId &&
          other.details == this.details);
}

class AuditLogTableCompanion extends UpdateCompanion<AuditLogData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> deviceId;
  final Value<DateTime> timestamp;
  final Value<String> operation;
  final Value<String> tableNameRef;
  final Value<String> recordId;
  final Value<String?> details;
  final Value<int> rowid;
  const AuditLogTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.operation = const Value.absent(),
    this.tableNameRef = const Value.absent(),
    this.recordId = const Value.absent(),
    this.details = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogTableCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    required DateTime timestamp,
    required String operation,
    required String tableNameRef,
    required String recordId,
    this.details = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timestamp = Value(timestamp),
       operation = Value(operation),
       tableNameRef = Value(tableNameRef),
       recordId = Value(recordId);
  static Insertable<AuditLogData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<DateTime>? timestamp,
    Expression<String>? operation,
    Expression<String>? tableNameRef,
    Expression<String>? recordId,
    Expression<String>? details,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (timestamp != null) 'timestamp': timestamp,
      if (operation != null) 'operation': operation,
      if (tableNameRef != null) 'table_name_ref': tableNameRef,
      if (recordId != null) 'record_id': recordId,
      if (details != null) 'details': details,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<String?>? deviceId,
    Value<DateTime>? timestamp,
    Value<String>? operation,
    Value<String>? tableNameRef,
    Value<String>? recordId,
    Value<String?>? details,
    Value<int>? rowid,
  }) {
    return AuditLogTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      timestamp: timestamp ?? this.timestamp,
      operation: operation ?? this.operation,
      tableNameRef: tableNameRef ?? this.tableNameRef,
      recordId: recordId ?? this.recordId,
      details: details ?? this.details,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (tableNameRef.present) {
      map['table_name_ref'] = Variable<String>(tableNameRef.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('timestamp: $timestamp, ')
          ..write('operation: $operation, ')
          ..write('tableNameRef: $tableNameRef, ')
          ..write('recordId: $recordId, ')
          ..write('details: $details, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    requiredDuringInsert: true,
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    recordId,
    targetTable,
    action,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;

  /// When the record entered the queue.
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String syncStatus;
  final String? deviceId;

  /// Primary key of the record needing sync.
  final String recordId;

  /// The table name.
  final String targetTable;

  /// UPSERT, DELETE.
  final String action;

  /// pending, processing, completed, failed.
  final String status;
  const SyncQueueData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.syncStatus,
    this.deviceId,
    required this.recordId,
    required this.targetTable,
    required this.action,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['record_id'] = Variable<String>(recordId);
    map['target_table'] = Variable<String>(targetTable);
    map['action'] = Variable<String>(action);
    map['status'] = Variable<String>(status);
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      recordId: Value(recordId),
      targetTable: Value(targetTable),
      action: Value(action),
      status: Value(status),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      recordId: serializer.fromJson<String>(json['recordId']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      action: serializer.fromJson<String>(json['action']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deviceId': serializer.toJson<String?>(deviceId),
      'recordId': serializer.toJson<String>(recordId),
      'targetTable': serializer.toJson<String>(targetTable),
      'action': serializer.toJson<String>(action),
      'status': serializer.toJson<String>(status),
    };
  }

  SyncQueueData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> deviceId = const Value.absent(),
    String? recordId,
    String? targetTable,
    String? action,
    String? status,
  }) => SyncQueueData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    recordId: recordId ?? this.recordId,
    targetTable: targetTable ?? this.targetTable,
    action: action ?? this.action,
    status: status ?? this.status,
  );
  SyncQueueData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      action: data.action.present ? data.action.value : this.action,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('recordId: $recordId, ')
          ..write('targetTable: $targetTable, ')
          ..write('action: $action, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    recordId,
    targetTable,
    action,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId &&
          other.recordId == this.recordId &&
          other.targetTable == this.targetTable &&
          other.action == this.action &&
          other.status == this.status);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> deviceId;
  final Value<String> recordId;
  final Value<String> targetTable;
  final Value<String> action;
  final Value<String> status;
  final Value<int> rowid;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.recordId = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.action = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    required String id,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String recordId,
    required String targetTable,
    required String action,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       recordId = Value(recordId),
       targetTable = Value(targetTable),
       action = Value(action);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<String>? recordId,
    Expression<String>? targetTable,
    Expression<String>? action,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (recordId != null) 'record_id': recordId,
      if (targetTable != null) 'target_table': targetTable,
      if (action != null) 'action': action,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<String?>? deviceId,
    Value<String>? recordId,
    Value<String>? targetTable,
    Value<String>? action,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      recordId: recordId ?? this.recordId,
      targetTable: targetTable ?? this.targetTable,
      action: action ?? this.action,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('recordId: $recordId, ')
          ..write('targetTable: $targetTable, ')
          ..write('action: $action, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionStatusTableTable extends QuestionStatusTable
    with TableInfo<$QuestionStatusTableTable, QuestionStatusTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionStatusTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAnsweredMeta = const VerificationMeta(
    'isAnswered',
  );
  @override
  late final GeneratedColumn<bool> isAnswered = GeneratedColumn<bool>(
    'is_answered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_answered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSkippedMeta = const VerificationMeta(
    'isSkipped',
  );
  @override
  late final GeneratedColumn<bool> isSkipped = GeneratedColumn<bool>(
    'is_skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastOfferedMeta = const VerificationMeta(
    'lastOffered',
  );
  @override
  late final GeneratedColumn<DateTime> lastOffered = GeneratedColumn<DateTime>(
    'last_offered',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoryIdMeta = const VerificationMeta(
    'memoryId',
  );
  @override
  late final GeneratedColumn<String> memoryId = GeneratedColumn<String>(
    'memory_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    questionId,
    isAnswered,
    isSkipped,
    lastOffered,
    memoryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_statuses';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionStatusTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('is_answered')) {
      context.handle(
        _isAnsweredMeta,
        isAnswered.isAcceptableOrUnknown(data['is_answered']!, _isAnsweredMeta),
      );
    }
    if (data.containsKey('is_skipped')) {
      context.handle(
        _isSkippedMeta,
        isSkipped.isAcceptableOrUnknown(data['is_skipped']!, _isSkippedMeta),
      );
    }
    if (data.containsKey('last_offered')) {
      context.handle(
        _lastOfferedMeta,
        lastOffered.isAcceptableOrUnknown(
          data['last_offered']!,
          _lastOfferedMeta,
        ),
      );
    }
    if (data.containsKey('memory_id')) {
      context.handle(
        _memoryIdMeta,
        memoryId.isAcceptableOrUnknown(data['memory_id']!, _memoryIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionStatusTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionStatusTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      isAnswered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_answered'],
      )!,
      isSkipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_skipped'],
      )!,
      lastOffered: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_offered'],
      ),
      memoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memory_id'],
      ),
    );
  }

  @override
  $QuestionStatusTableTable createAlias(String alias) {
    return $QuestionStatusTableTable(attachedDatabase, alias);
  }
}

class QuestionStatusTableData extends DataClass
    implements Insertable<QuestionStatusTableData> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String syncStatus;
  final String? deviceId;

  /// The unique ID from the Question Bank (e.g. B01-Q001).
  final String questionId;

  /// Whether the user has provided a valid answer.
  final bool isAnswered;

  /// Whether the user has explicitly skipped this question.
  final bool isSkipped;

  /// When the question was last presented to the user.
  final DateTime? lastOffered;

  /// Link to the generated memory ID if answered.
  final String? memoryId;
  const QuestionStatusTableData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    this.deletedAt,
    required this.syncStatus,
    this.deviceId,
    required this.questionId,
    required this.isAnswered,
    required this.isSkipped,
    this.lastOffered,
    this.memoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['question_id'] = Variable<String>(questionId);
    map['is_answered'] = Variable<bool>(isAnswered);
    map['is_skipped'] = Variable<bool>(isSkipped);
    if (!nullToAbsent || lastOffered != null) {
      map['last_offered'] = Variable<DateTime>(lastOffered);
    }
    if (!nullToAbsent || memoryId != null) {
      map['memory_id'] = Variable<String>(memoryId);
    }
    return map;
  }

  QuestionStatusTableCompanion toCompanion(bool nullToAbsent) {
    return QuestionStatusTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      questionId: Value(questionId),
      isAnswered: Value(isAnswered),
      isSkipped: Value(isSkipped),
      lastOffered: lastOffered == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOffered),
      memoryId: memoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(memoryId),
    );
  }

  factory QuestionStatusTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionStatusTableData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      isAnswered: serializer.fromJson<bool>(json['isAnswered']),
      isSkipped: serializer.fromJson<bool>(json['isSkipped']),
      lastOffered: serializer.fromJson<DateTime?>(json['lastOffered']),
      memoryId: serializer.fromJson<String?>(json['memoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deviceId': serializer.toJson<String?>(deviceId),
      'questionId': serializer.toJson<String>(questionId),
      'isAnswered': serializer.toJson<bool>(isAnswered),
      'isSkipped': serializer.toJson<bool>(isSkipped),
      'lastOffered': serializer.toJson<DateTime?>(lastOffered),
      'memoryId': serializer.toJson<String?>(memoryId),
    };
  }

  QuestionStatusTableData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> deviceId = const Value.absent(),
    String? questionId,
    bool? isAnswered,
    bool? isSkipped,
    Value<DateTime?> lastOffered = const Value.absent(),
    Value<String?> memoryId = const Value.absent(),
  }) => QuestionStatusTableData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    questionId: questionId ?? this.questionId,
    isAnswered: isAnswered ?? this.isAnswered,
    isSkipped: isSkipped ?? this.isSkipped,
    lastOffered: lastOffered.present ? lastOffered.value : this.lastOffered,
    memoryId: memoryId.present ? memoryId.value : this.memoryId,
  );
  QuestionStatusTableData copyWithCompanion(QuestionStatusTableCompanion data) {
    return QuestionStatusTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      isAnswered: data.isAnswered.present
          ? data.isAnswered.value
          : this.isAnswered,
      isSkipped: data.isSkipped.present ? data.isSkipped.value : this.isSkipped,
      lastOffered: data.lastOffered.present
          ? data.lastOffered.value
          : this.lastOffered,
      memoryId: data.memoryId.present ? data.memoryId.value : this.memoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionStatusTableData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('questionId: $questionId, ')
          ..write('isAnswered: $isAnswered, ')
          ..write('isSkipped: $isSkipped, ')
          ..write('lastOffered: $lastOffered, ')
          ..write('memoryId: $memoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    isDeleted,
    deletedAt,
    syncStatus,
    deviceId,
    questionId,
    isAnswered,
    isSkipped,
    lastOffered,
    memoryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionStatusTableData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus &&
          other.deviceId == this.deviceId &&
          other.questionId == this.questionId &&
          other.isAnswered == this.isAnswered &&
          other.isSkipped == this.isSkipped &&
          other.lastOffered == this.lastOffered &&
          other.memoryId == this.memoryId);
}

class QuestionStatusTableCompanion
    extends UpdateCompanion<QuestionStatusTableData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<String> syncStatus;
  final Value<String?> deviceId;
  final Value<String> questionId;
  final Value<bool> isAnswered;
  final Value<bool> isSkipped;
  final Value<DateTime?> lastOffered;
  final Value<String?> memoryId;
  final Value<int> rowid;
  const QuestionStatusTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.isAnswered = const Value.absent(),
    this.isSkipped = const Value.absent(),
    this.lastOffered = const Value.absent(),
    this.memoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionStatusTableCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deviceId = const Value.absent(),
    required String questionId,
    this.isAnswered = const Value.absent(),
    this.isSkipped = const Value.absent(),
    this.lastOffered = const Value.absent(),
    this.memoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       questionId = Value(questionId);
  static Insertable<QuestionStatusTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<String>? syncStatus,
    Expression<String>? deviceId,
    Expression<String>? questionId,
    Expression<bool>? isAnswered,
    Expression<bool>? isSkipped,
    Expression<DateTime>? lastOffered,
    Expression<String>? memoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deviceId != null) 'device_id': deviceId,
      if (questionId != null) 'question_id': questionId,
      if (isAnswered != null) 'is_answered': isAnswered,
      if (isSkipped != null) 'is_skipped': isSkipped,
      if (lastOffered != null) 'last_offered': lastOffered,
      if (memoryId != null) 'memory_id': memoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionStatusTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<String>? syncStatus,
    Value<String?>? deviceId,
    Value<String>? questionId,
    Value<bool>? isAnswered,
    Value<bool>? isSkipped,
    Value<DateTime?>? lastOffered,
    Value<String?>? memoryId,
    Value<int>? rowid,
  }) {
    return QuestionStatusTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deviceId: deviceId ?? this.deviceId,
      questionId: questionId ?? this.questionId,
      isAnswered: isAnswered ?? this.isAnswered,
      isSkipped: isSkipped ?? this.isSkipped,
      lastOffered: lastOffered ?? this.lastOffered,
      memoryId: memoryId ?? this.memoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (isAnswered.present) {
      map['is_answered'] = Variable<bool>(isAnswered.value);
    }
    if (isSkipped.present) {
      map['is_skipped'] = Variable<bool>(isSkipped.value);
    }
    if (lastOffered.present) {
      map['last_offered'] = Variable<DateTime>(lastOffered.value);
    }
    if (memoryId.present) {
      map['memory_id'] = Variable<String>(memoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionStatusTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deviceId: $deviceId, ')
          ..write('questionId: $questionId, ')
          ..write('isAnswered: $isAnswered, ')
          ..write('isSkipped: $isSkipped, ')
          ..write('lastOffered: $lastOffered, ')
          ..write('memoryId: $memoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$KnightDatabase extends GeneratedDatabase {
  _$KnightDatabase(QueryExecutor e) : super(e);
  $KnightDatabaseManager get managers => $KnightDatabaseManager(this);
  late final $MigrationLedgerTable migrationLedger = $MigrationLedgerTable(
    this,
  );
  late final $UserProfileTableTable userProfileTable = $UserProfileTableTable(
    this,
  );
  late final $MemoryTableTable memoryTable = $MemoryTableTable(this);
  late final $MemoryRelationTableTable memoryRelationTable =
      $MemoryRelationTableTable(this);
  late final $EvidenceTableTable evidenceTable = $EvidenceTableTable(this);
  late final $AttachmentTableTable attachmentTable = $AttachmentTableTable(
    this,
  );
  late final $AuditLogTableTable auditLogTable = $AuditLogTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final $QuestionStatusTableTable questionStatusTable =
      $QuestionStatusTableTable(this);
  late final MigrationDao migrationDao = MigrationDao(this as KnightDatabase);
  late final UserProfileDao userProfileDao = UserProfileDao(
    this as KnightDatabase,
  );
  late final MemoryDao memoryDao = MemoryDao(this as KnightDatabase);
  late final EvidenceDao evidenceDao = EvidenceDao(this as KnightDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    migrationLedger,
    userProfileTable,
    memoryTable,
    memoryRelationTable,
    evidenceTable,
    attachmentTable,
    auditLogTable,
    syncQueueTable,
    questionStatusTable,
  ];
}

typedef $$MigrationLedgerTableCreateCompanionBuilder =
    MigrationLedgerCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      required String module,
      required int migratedRecords,
      required int failedRecords,
      required String status,
      Value<int> rowid,
    });
typedef $$MigrationLedgerTableUpdateCompanionBuilder =
    MigrationLedgerCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<String> module,
      Value<int> migratedRecords,
      Value<int> failedRecords,
      Value<String> status,
      Value<int> rowid,
    });

class $$MigrationLedgerTableFilterComposer
    extends Composer<_$KnightDatabase, $MigrationLedgerTable> {
  $$MigrationLedgerTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get migratedRecords => $composableBuilder(
    column: $table.migratedRecords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedRecords => $composableBuilder(
    column: $table.failedRecords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MigrationLedgerTableOrderingComposer
    extends Composer<_$KnightDatabase, $MigrationLedgerTable> {
  $$MigrationLedgerTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get migratedRecords => $composableBuilder(
    column: $table.migratedRecords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedRecords => $composableBuilder(
    column: $table.failedRecords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MigrationLedgerTableAnnotationComposer
    extends Composer<_$KnightDatabase, $MigrationLedgerTable> {
  $$MigrationLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<int> get migratedRecords => $composableBuilder(
    column: $table.migratedRecords,
    builder: (column) => column,
  );

  GeneratedColumn<int> get failedRecords => $composableBuilder(
    column: $table.failedRecords,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$MigrationLedgerTableTableManager
    extends
        RootTableManager<
          _$KnightDatabase,
          $MigrationLedgerTable,
          MigrationLedgerData,
          $$MigrationLedgerTableFilterComposer,
          $$MigrationLedgerTableOrderingComposer,
          $$MigrationLedgerTableAnnotationComposer,
          $$MigrationLedgerTableCreateCompanionBuilder,
          $$MigrationLedgerTableUpdateCompanionBuilder,
          (
            MigrationLedgerData,
            BaseReferences<
              _$KnightDatabase,
              $MigrationLedgerTable,
              MigrationLedgerData
            >,
          ),
          MigrationLedgerData,
          PrefetchHooks Function()
        > {
  $$MigrationLedgerTableTableManager(
    _$KnightDatabase db,
    $MigrationLedgerTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MigrationLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MigrationLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MigrationLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> module = const Value.absent(),
                Value<int> migratedRecords = const Value.absent(),
                Value<int> failedRecords = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MigrationLedgerCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                module: module,
                migratedRecords: migratedRecords,
                failedRecords: failedRecords,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String module,
                required int migratedRecords,
                required int failedRecords,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => MigrationLedgerCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                module: module,
                migratedRecords: migratedRecords,
                failedRecords: failedRecords,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MigrationLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$KnightDatabase,
      $MigrationLedgerTable,
      MigrationLedgerData,
      $$MigrationLedgerTableFilterComposer,
      $$MigrationLedgerTableOrderingComposer,
      $$MigrationLedgerTableAnnotationComposer,
      $$MigrationLedgerTableCreateCompanionBuilder,
      $$MigrationLedgerTableUpdateCompanionBuilder,
      (
        MigrationLedgerData,
        BaseReferences<
          _$KnightDatabase,
          $MigrationLedgerTable,
          MigrationLedgerData
        >,
      ),
      MigrationLedgerData,
      PrefetchHooks Function()
    >;
typedef $$UserProfileTableTableCreateCompanionBuilder =
    UserProfileTableCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<String> name,
      Value<String> role,
      Value<String> focusArea,
      Value<String> workStyle,
      Value<String> healthGoal,
      Value<String> financeGoal,
      Value<String> goalText,
      Value<String> aiTone,
      Value<String> aiDepth,
      required List<String> completedSteps,
      Value<String> fullName,
      Value<String> preferredName,
      Value<String> dateOfBirth,
      Value<String> gender,
      Value<String> height,
      Value<String> weight,
      Value<String> country,
      Value<String> timeZone,
      Value<String> occupation,
      Value<String> company,
      Value<String> workType,
      Value<String> shiftType,
      Value<String> workHours,
      Value<String> sleepGoal,
      Value<String> waterGoal,
      Value<String> exerciseFrequency,
      Value<String> fitnessLevel,
      required List<String> healthGoals,
      Value<String> currency,
      Value<String> monthlyIncome,
      Value<String> monthlyBudget,
      Value<String> savingsGoal,
      required List<String> financialPriorities,
      Value<String> lifeGoals,
      Value<String> learningGoals,
      Value<String> focusAreas,
      Value<String> reminderPreference,
      Value<String> aiPersonality,
      Value<String> notificationPreference,
      Value<String> themePreference,
      Value<String> privacyPreference,
      Value<int> rowid,
    });
typedef $$UserProfileTableTableUpdateCompanionBuilder =
    UserProfileTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<String> name,
      Value<String> role,
      Value<String> focusArea,
      Value<String> workStyle,
      Value<String> healthGoal,
      Value<String> financeGoal,
      Value<String> goalText,
      Value<String> aiTone,
      Value<String> aiDepth,
      Value<List<String>> completedSteps,
      Value<String> fullName,
      Value<String> preferredName,
      Value<String> dateOfBirth,
      Value<String> gender,
      Value<String> height,
      Value<String> weight,
      Value<String> country,
      Value<String> timeZone,
      Value<String> occupation,
      Value<String> company,
      Value<String> workType,
      Value<String> shiftType,
      Value<String> workHours,
      Value<String> sleepGoal,
      Value<String> waterGoal,
      Value<String> exerciseFrequency,
      Value<String> fitnessLevel,
      Value<List<String>> healthGoals,
      Value<String> currency,
      Value<String> monthlyIncome,
      Value<String> monthlyBudget,
      Value<String> savingsGoal,
      Value<List<String>> financialPriorities,
      Value<String> lifeGoals,
      Value<String> learningGoals,
      Value<String> focusAreas,
      Value<String> reminderPreference,
      Value<String> aiPersonality,
      Value<String> notificationPreference,
      Value<String> themePreference,
      Value<String> privacyPreference,
      Value<int> rowid,
    });

class $$UserProfileTableTableFilterComposer
    extends Composer<_$KnightDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focusArea => $composableBuilder(
    column: $table.focusArea,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workStyle => $composableBuilder(
    column: $table.workStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthGoal => $composableBuilder(
    column: $table.healthGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get financeGoal => $composableBuilder(
    column: $table.financeGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalText => $composableBuilder(
    column: $table.goalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiTone => $composableBuilder(
    column: $table.aiTone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiDepth => $composableBuilder(
    column: $table.aiDepth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get completedSteps => $composableBuilder(
    column: $table.completedSteps,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredName => $composableBuilder(
    column: $table.preferredName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workType => $composableBuilder(
    column: $table.workType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftType => $composableBuilder(
    column: $table.shiftType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workHours => $composableBuilder(
    column: $table.workHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sleepGoal => $composableBuilder(
    column: $table.sleepGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waterGoal => $composableBuilder(
    column: $table.waterGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseFrequency => $composableBuilder(
    column: $table.exerciseFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fitnessLevel => $composableBuilder(
    column: $table.fitnessLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get healthGoals => $composableBuilder(
    column: $table.healthGoals,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get monthlyIncome => $composableBuilder(
    column: $table.monthlyIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get monthlyBudget => $composableBuilder(
    column: $table.monthlyBudget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get savingsGoal => $composableBuilder(
    column: $table.savingsGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get financialPriorities => $composableBuilder(
    column: $table.financialPriorities,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get lifeGoals => $composableBuilder(
    column: $table.lifeGoals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningGoals => $composableBuilder(
    column: $table.learningGoals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focusAreas => $composableBuilder(
    column: $table.focusAreas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderPreference => $composableBuilder(
    column: $table.reminderPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiPersonality => $composableBuilder(
    column: $table.aiPersonality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationPreference => $composableBuilder(
    column: $table.notificationPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get privacyPreference => $composableBuilder(
    column: $table.privacyPreference,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableTableOrderingComposer
    extends Composer<_$KnightDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focusArea => $composableBuilder(
    column: $table.focusArea,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workStyle => $composableBuilder(
    column: $table.workStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthGoal => $composableBuilder(
    column: $table.healthGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get financeGoal => $composableBuilder(
    column: $table.financeGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalText => $composableBuilder(
    column: $table.goalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiTone => $composableBuilder(
    column: $table.aiTone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiDepth => $composableBuilder(
    column: $table.aiDepth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedSteps => $composableBuilder(
    column: $table.completedSteps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredName => $composableBuilder(
    column: $table.preferredName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workType => $composableBuilder(
    column: $table.workType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftType => $composableBuilder(
    column: $table.shiftType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workHours => $composableBuilder(
    column: $table.workHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sleepGoal => $composableBuilder(
    column: $table.sleepGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waterGoal => $composableBuilder(
    column: $table.waterGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseFrequency => $composableBuilder(
    column: $table.exerciseFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fitnessLevel => $composableBuilder(
    column: $table.fitnessLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthGoals => $composableBuilder(
    column: $table.healthGoals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get monthlyIncome => $composableBuilder(
    column: $table.monthlyIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get monthlyBudget => $composableBuilder(
    column: $table.monthlyBudget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get savingsGoal => $composableBuilder(
    column: $table.savingsGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get financialPriorities => $composableBuilder(
    column: $table.financialPriorities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lifeGoals => $composableBuilder(
    column: $table.lifeGoals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningGoals => $composableBuilder(
    column: $table.learningGoals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focusAreas => $composableBuilder(
    column: $table.focusAreas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderPreference => $composableBuilder(
    column: $table.reminderPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiPersonality => $composableBuilder(
    column: $table.aiPersonality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationPreference => $composableBuilder(
    column: $table.notificationPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get privacyPreference => $composableBuilder(
    column: $table.privacyPreference,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableTableAnnotationComposer
    extends Composer<_$KnightDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get focusArea =>
      $composableBuilder(column: $table.focusArea, builder: (column) => column);

  GeneratedColumn<String> get workStyle =>
      $composableBuilder(column: $table.workStyle, builder: (column) => column);

  GeneratedColumn<String> get healthGoal => $composableBuilder(
    column: $table.healthGoal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get financeGoal => $composableBuilder(
    column: $table.financeGoal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalText =>
      $composableBuilder(column: $table.goalText, builder: (column) => column);

  GeneratedColumn<String> get aiTone =>
      $composableBuilder(column: $table.aiTone, builder: (column) => column);

  GeneratedColumn<String> get aiDepth =>
      $composableBuilder(column: $table.aiDepth, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get completedSteps =>
      $composableBuilder(
        column: $table.completedSteps,
        builder: (column) => column,
      );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get preferredName => $composableBuilder(
    column: $table.preferredName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get workType =>
      $composableBuilder(column: $table.workType, builder: (column) => column);

  GeneratedColumn<String> get shiftType =>
      $composableBuilder(column: $table.shiftType, builder: (column) => column);

  GeneratedColumn<String> get workHours =>
      $composableBuilder(column: $table.workHours, builder: (column) => column);

  GeneratedColumn<String> get sleepGoal =>
      $composableBuilder(column: $table.sleepGoal, builder: (column) => column);

  GeneratedColumn<String> get waterGoal =>
      $composableBuilder(column: $table.waterGoal, builder: (column) => column);

  GeneratedColumn<String> get exerciseFrequency => $composableBuilder(
    column: $table.exerciseFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fitnessLevel => $composableBuilder(
    column: $table.fitnessLevel,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get healthGoals =>
      $composableBuilder(
        column: $table.healthGoals,
        builder: (column) => column,
      );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get monthlyIncome => $composableBuilder(
    column: $table.monthlyIncome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get monthlyBudget => $composableBuilder(
    column: $table.monthlyBudget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get savingsGoal => $composableBuilder(
    column: $table.savingsGoal,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String>
  get financialPriorities => $composableBuilder(
    column: $table.financialPriorities,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lifeGoals =>
      $composableBuilder(column: $table.lifeGoals, builder: (column) => column);

  GeneratedColumn<String> get learningGoals => $composableBuilder(
    column: $table.learningGoals,
    builder: (column) => column,
  );

  GeneratedColumn<String> get focusAreas => $composableBuilder(
    column: $table.focusAreas,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderPreference => $composableBuilder(
    column: $table.reminderPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiPersonality => $composableBuilder(
    column: $table.aiPersonality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notificationPreference => $composableBuilder(
    column: $table.notificationPreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get privacyPreference => $composableBuilder(
    column: $table.privacyPreference,
    builder: (column) => column,
  );
}

class $$UserProfileTableTableTableManager
    extends
        RootTableManager<
          _$KnightDatabase,
          $UserProfileTableTable,
          UserProfileTableData,
          $$UserProfileTableTableFilterComposer,
          $$UserProfileTableTableOrderingComposer,
          $$UserProfileTableTableAnnotationComposer,
          $$UserProfileTableTableCreateCompanionBuilder,
          $$UserProfileTableTableUpdateCompanionBuilder,
          (
            UserProfileTableData,
            BaseReferences<
              _$KnightDatabase,
              $UserProfileTableTable,
              UserProfileTableData
            >,
          ),
          UserProfileTableData,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableTableManager(
    _$KnightDatabase db,
    $UserProfileTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> focusArea = const Value.absent(),
                Value<String> workStyle = const Value.absent(),
                Value<String> healthGoal = const Value.absent(),
                Value<String> financeGoal = const Value.absent(),
                Value<String> goalText = const Value.absent(),
                Value<String> aiTone = const Value.absent(),
                Value<String> aiDepth = const Value.absent(),
                Value<List<String>> completedSteps = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> preferredName = const Value.absent(),
                Value<String> dateOfBirth = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> height = const Value.absent(),
                Value<String> weight = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<String> occupation = const Value.absent(),
                Value<String> company = const Value.absent(),
                Value<String> workType = const Value.absent(),
                Value<String> shiftType = const Value.absent(),
                Value<String> workHours = const Value.absent(),
                Value<String> sleepGoal = const Value.absent(),
                Value<String> waterGoal = const Value.absent(),
                Value<String> exerciseFrequency = const Value.absent(),
                Value<String> fitnessLevel = const Value.absent(),
                Value<List<String>> healthGoals = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> monthlyIncome = const Value.absent(),
                Value<String> monthlyBudget = const Value.absent(),
                Value<String> savingsGoal = const Value.absent(),
                Value<List<String>> financialPriorities = const Value.absent(),
                Value<String> lifeGoals = const Value.absent(),
                Value<String> learningGoals = const Value.absent(),
                Value<String> focusAreas = const Value.absent(),
                Value<String> reminderPreference = const Value.absent(),
                Value<String> aiPersonality = const Value.absent(),
                Value<String> notificationPreference = const Value.absent(),
                Value<String> themePreference = const Value.absent(),
                Value<String> privacyPreference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfileTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                name: name,
                role: role,
                focusArea: focusArea,
                workStyle: workStyle,
                healthGoal: healthGoal,
                financeGoal: financeGoal,
                goalText: goalText,
                aiTone: aiTone,
                aiDepth: aiDepth,
                completedSteps: completedSteps,
                fullName: fullName,
                preferredName: preferredName,
                dateOfBirth: dateOfBirth,
                gender: gender,
                height: height,
                weight: weight,
                country: country,
                timeZone: timeZone,
                occupation: occupation,
                company: company,
                workType: workType,
                shiftType: shiftType,
                workHours: workHours,
                sleepGoal: sleepGoal,
                waterGoal: waterGoal,
                exerciseFrequency: exerciseFrequency,
                fitnessLevel: fitnessLevel,
                healthGoals: healthGoals,
                currency: currency,
                monthlyIncome: monthlyIncome,
                monthlyBudget: monthlyBudget,
                savingsGoal: savingsGoal,
                financialPriorities: financialPriorities,
                lifeGoals: lifeGoals,
                learningGoals: learningGoals,
                focusAreas: focusAreas,
                reminderPreference: reminderPreference,
                aiPersonality: aiPersonality,
                notificationPreference: notificationPreference,
                themePreference: themePreference,
                privacyPreference: privacyPreference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> focusArea = const Value.absent(),
                Value<String> workStyle = const Value.absent(),
                Value<String> healthGoal = const Value.absent(),
                Value<String> financeGoal = const Value.absent(),
                Value<String> goalText = const Value.absent(),
                Value<String> aiTone = const Value.absent(),
                Value<String> aiDepth = const Value.absent(),
                required List<String> completedSteps,
                Value<String> fullName = const Value.absent(),
                Value<String> preferredName = const Value.absent(),
                Value<String> dateOfBirth = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> height = const Value.absent(),
                Value<String> weight = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<String> occupation = const Value.absent(),
                Value<String> company = const Value.absent(),
                Value<String> workType = const Value.absent(),
                Value<String> shiftType = const Value.absent(),
                Value<String> workHours = const Value.absent(),
                Value<String> sleepGoal = const Value.absent(),
                Value<String> waterGoal = const Value.absent(),
                Value<String> exerciseFrequency = const Value.absent(),
                Value<String> fitnessLevel = const Value.absent(),
                required List<String> healthGoals,
                Value<String> currency = const Value.absent(),
                Value<String> monthlyIncome = const Value.absent(),
                Value<String> monthlyBudget = const Value.absent(),
                Value<String> savingsGoal = const Value.absent(),
                required List<String> financialPriorities,
                Value<String> lifeGoals = const Value.absent(),
                Value<String> learningGoals = const Value.absent(),
                Value<String> focusAreas = const Value.absent(),
                Value<String> reminderPreference = const Value.absent(),
                Value<String> aiPersonality = const Value.absent(),
                Value<String> notificationPreference = const Value.absent(),
                Value<String> themePreference = const Value.absent(),
                Value<String> privacyPreference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfileTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                name: name,
                role: role,
                focusArea: focusArea,
                workStyle: workStyle,
                healthGoal: healthGoal,
                financeGoal: financeGoal,
                goalText: goalText,
                aiTone: aiTone,
                aiDepth: aiDepth,
                completedSteps: completedSteps,
                fullName: fullName,
                preferredName: preferredName,
                dateOfBirth: dateOfBirth,
                gender: gender,
                height: height,
                weight: weight,
                country: country,
                timeZone: timeZone,
                occupation: occupation,
                company: company,
                workType: workType,
                shiftType: shiftType,
                workHours: workHours,
                sleepGoal: sleepGoal,
                waterGoal: waterGoal,
                exerciseFrequency: exerciseFrequency,
                fitnessLevel: fitnessLevel,
                healthGoals: healthGoals,
                currency: currency,
                monthlyIncome: monthlyIncome,
                monthlyBudget: monthlyBudget,
                savingsGoal: savingsGoal,
                financialPriorities: financialPriorities,
                lifeGoals: lifeGoals,
                learningGoals: learningGoals,
                focusAreas: focusAreas,
                reminderPreference: reminderPreference,
                aiPersonality: aiPersonality,
                notificationPreference: notificationPreference,
                themePreference: themePreference,
                privacyPreference: privacyPreference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KnightDatabase,
      $UserProfileTableTable,
      UserProfileTableData,
      $$UserProfileTableTableFilterComposer,
      $$UserProfileTableTableOrderingComposer,
      $$UserProfileTableTableAnnotationComposer,
      $$UserProfileTableTableCreateCompanionBuilder,
      $$UserProfileTableTableUpdateCompanionBuilder,
      (
        UserProfileTableData,
        BaseReferences<
          _$KnightDatabase,
          $UserProfileTableTable,
          UserProfileTableData
        >,
      ),
      UserProfileTableData,
      PrefetchHooks Function()
    >;
typedef $$MemoryTableTableCreateCompanionBuilder =
    MemoryTableCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      required String memoryId,
      required int categoryId,
      required int domainId,
      required String type,
      required String content,
      Value<String?> summary,
      Value<double> importance,
      Value<double> confidence,
      required String source,
      required String provenance,
      required String changeType,
      Value<String?> reasoning,
      Value<String?> delta,
      required DateTime effectiveAt,
      required DateTime recordedAt,
      Value<DateTime?> lastVerifiedAt,
      Value<String?> verificationHistory,
      Value<String?> prevVersionId,
      Value<bool> isLatest,
      Value<bool> verified,
      Value<String?> questionId,
      Value<String> knowledgeState,
      Value<String?> explanation,
      Value<String> tags,
      Value<String?> embedding,
      Value<int> rowid,
    });
typedef $$MemoryTableTableUpdateCompanionBuilder =
    MemoryTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<String> memoryId,
      Value<int> categoryId,
      Value<int> domainId,
      Value<String> type,
      Value<String> content,
      Value<String?> summary,
      Value<double> importance,
      Value<double> confidence,
      Value<String> source,
      Value<String> provenance,
      Value<String> changeType,
      Value<String?> reasoning,
      Value<String?> delta,
      Value<DateTime> effectiveAt,
      Value<DateTime> recordedAt,
      Value<DateTime?> lastVerifiedAt,
      Value<String?> verificationHistory,
      Value<String?> prevVersionId,
      Value<bool> isLatest,
      Value<bool> verified,
      Value<String?> questionId,
      Value<String> knowledgeState,
      Value<String?> explanation,
      Value<String> tags,
      Value<String?> embedding,
      Value<int> rowid,
    });

final class $$MemoryTableTableReferences
    extends
        BaseReferences<_$KnightDatabase, $MemoryTableTable, MemoryTableData> {
  $$MemoryTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MemoryTableTable _prevVersionIdTable(_$KnightDatabase db) =>
      db.memoryTable.createAlias('memories__prev_version_id__memories__id');

  $$MemoryTableTableProcessedTableManager? get prevVersionId {
    final $_column = $_itemColumn<String>('prev_version_id');
    if ($_column == null) return null;
    final manager = $$MemoryTableTableTableManager(
      $_db,
      $_db.memoryTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_prevVersionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AttachmentTableTable, List<AttachmentTableData>>
  _attachmentTableRefsTable(_$KnightDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.attachmentTable,
        aliasName: 'memories__id__attachments__memory_id',
      );

  $$AttachmentTableTableProcessedTableManager get attachmentTableRefs {
    final manager = $$AttachmentTableTableTableManager(
      $_db,
      $_db.attachmentTable,
    ).filter((f) => f.memoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _attachmentTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MemoryTableTableFilterComposer
    extends Composer<_$KnightDatabase, $MemoryTableTable> {
  $$MemoryTableTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memoryId => $composableBuilder(
    column: $table.memoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get domainId => $composableBuilder(
    column: $table.domainId,
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

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changeType => $composableBuilder(
    column: $table.changeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasoning => $composableBuilder(
    column: $table.reasoning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveAt => $composableBuilder(
    column: $table.effectiveAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verificationHistory => $composableBuilder(
    column: $table.verificationHistory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLatest => $composableBuilder(
    column: $table.isLatest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get knowledgeState => $composableBuilder(
    column: $table.knowledgeState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get embedding => $composableBuilder(
    column: $table.embedding,
    builder: (column) => ColumnFilters(column),
  );

  $$MemoryTableTableFilterComposer get prevVersionId {
    final $$MemoryTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prevVersionId,
      referencedTable: $db.memoryTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryTableTableFilterComposer(
            $db: $db,
            $table: $db.memoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> attachmentTableRefs(
    Expression<bool> Function($$AttachmentTableTableFilterComposer f) f,
  ) {
    final $$AttachmentTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachmentTable,
      getReferencedColumn: (t) => t.memoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentTableTableFilterComposer(
            $db: $db,
            $table: $db.attachmentTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryTableTableOrderingComposer
    extends Composer<_$KnightDatabase, $MemoryTableTable> {
  $$MemoryTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memoryId => $composableBuilder(
    column: $table.memoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get domainId => $composableBuilder(
    column: $table.domainId,
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

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changeType => $composableBuilder(
    column: $table.changeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasoning => $composableBuilder(
    column: $table.reasoning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveAt => $composableBuilder(
    column: $table.effectiveAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verificationHistory => $composableBuilder(
    column: $table.verificationHistory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLatest => $composableBuilder(
    column: $table.isLatest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get knowledgeState => $composableBuilder(
    column: $table.knowledgeState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get embedding => $composableBuilder(
    column: $table.embedding,
    builder: (column) => ColumnOrderings(column),
  );

  $$MemoryTableTableOrderingComposer get prevVersionId {
    final $$MemoryTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prevVersionId,
      referencedTable: $db.memoryTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryTableTableOrderingComposer(
            $db: $db,
            $table: $db.memoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryTableTableAnnotationComposer
    extends Composer<_$KnightDatabase, $MemoryTableTable> {
  $$MemoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get memoryId =>
      $composableBuilder(column: $table.memoryId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get domainId =>
      $composableBuilder(column: $table.domainId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<double> get importance => $composableBuilder(
    column: $table.importance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get provenance => $composableBuilder(
    column: $table.provenance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get changeType => $composableBuilder(
    column: $table.changeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasoning =>
      $composableBuilder(column: $table.reasoning, builder: (column) => column);

  GeneratedColumn<String> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveAt => $composableBuilder(
    column: $table.effectiveAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastVerifiedAt => $composableBuilder(
    column: $table.lastVerifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verificationHistory => $composableBuilder(
    column: $table.verificationHistory,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLatest =>
      $composableBuilder(column: $table.isLatest, builder: (column) => column);

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get knowledgeState => $composableBuilder(
    column: $table.knowledgeState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get embedding =>
      $composableBuilder(column: $table.embedding, builder: (column) => column);

  $$MemoryTableTableAnnotationComposer get prevVersionId {
    final $$MemoryTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prevVersionId,
      referencedTable: $db.memoryTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryTableTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> attachmentTableRefs<T extends Object>(
    Expression<T> Function($$AttachmentTableTableAnnotationComposer a) f,
  ) {
    final $$AttachmentTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachmentTable,
      getReferencedColumn: (t) => t.memoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentTableTableAnnotationComposer(
            $db: $db,
            $table: $db.attachmentTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryTableTableTableManager
    extends
        RootTableManager<
          _$KnightDatabase,
          $MemoryTableTable,
          MemoryTableData,
          $$MemoryTableTableFilterComposer,
          $$MemoryTableTableOrderingComposer,
          $$MemoryTableTableAnnotationComposer,
          $$MemoryTableTableCreateCompanionBuilder,
          $$MemoryTableTableUpdateCompanionBuilder,
          (MemoryTableData, $$MemoryTableTableReferences),
          MemoryTableData,
          PrefetchHooks Function({bool prevVersionId, bool attachmentTableRefs})
        > {
  $$MemoryTableTableTableManager(_$KnightDatabase db, $MemoryTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> memoryId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> domainId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<double> importance = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> provenance = const Value.absent(),
                Value<String> changeType = const Value.absent(),
                Value<String?> reasoning = const Value.absent(),
                Value<String?> delta = const Value.absent(),
                Value<DateTime> effectiveAt = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<DateTime?> lastVerifiedAt = const Value.absent(),
                Value<String?> verificationHistory = const Value.absent(),
                Value<String?> prevVersionId = const Value.absent(),
                Value<bool> isLatest = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String?> questionId = const Value.absent(),
                Value<String> knowledgeState = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String?> embedding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                memoryId: memoryId,
                categoryId: categoryId,
                domainId: domainId,
                type: type,
                content: content,
                summary: summary,
                importance: importance,
                confidence: confidence,
                source: source,
                provenance: provenance,
                changeType: changeType,
                reasoning: reasoning,
                delta: delta,
                effectiveAt: effectiveAt,
                recordedAt: recordedAt,
                lastVerifiedAt: lastVerifiedAt,
                verificationHistory: verificationHistory,
                prevVersionId: prevVersionId,
                isLatest: isLatest,
                verified: verified,
                questionId: questionId,
                knowledgeState: knowledgeState,
                explanation: explanation,
                tags: tags,
                embedding: embedding,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String memoryId,
                required int categoryId,
                required int domainId,
                required String type,
                required String content,
                Value<String?> summary = const Value.absent(),
                Value<double> importance = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                required String source,
                required String provenance,
                required String changeType,
                Value<String?> reasoning = const Value.absent(),
                Value<String?> delta = const Value.absent(),
                required DateTime effectiveAt,
                required DateTime recordedAt,
                Value<DateTime?> lastVerifiedAt = const Value.absent(),
                Value<String?> verificationHistory = const Value.absent(),
                Value<String?> prevVersionId = const Value.absent(),
                Value<bool> isLatest = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String?> questionId = const Value.absent(),
                Value<String> knowledgeState = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String?> embedding = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                memoryId: memoryId,
                categoryId: categoryId,
                domainId: domainId,
                type: type,
                content: content,
                summary: summary,
                importance: importance,
                confidence: confidence,
                source: source,
                provenance: provenance,
                changeType: changeType,
                reasoning: reasoning,
                delta: delta,
                effectiveAt: effectiveAt,
                recordedAt: recordedAt,
                lastVerifiedAt: lastVerifiedAt,
                verificationHistory: verificationHistory,
                prevVersionId: prevVersionId,
                isLatest: isLatest,
                verified: verified,
                questionId: questionId,
                knowledgeState: knowledgeState,
                explanation: explanation,
                tags: tags,
                embedding: embedding,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MemoryTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({prevVersionId = false, attachmentTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (attachmentTableRefs) db.attachmentTable,
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
                        if (prevVersionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.prevVersionId,
                                    referencedTable:
                                        $$MemoryTableTableReferences
                                            ._prevVersionIdTable(db),
                                    referencedColumn:
                                        $$MemoryTableTableReferences
                                            ._prevVersionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (attachmentTableRefs)
                        await $_getPrefetchedData<
                          MemoryTableData,
                          $MemoryTableTable,
                          AttachmentTableData
                        >(
                          currentTable: table,
                          referencedTable: $$MemoryTableTableReferences
                              ._attachmentTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MemoryTableTableReferences(
                                db,
                                table,
                                p0,
                              ).attachmentTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MemoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KnightDatabase,
      $MemoryTableTable,
      MemoryTableData,
      $$MemoryTableTableFilterComposer,
      $$MemoryTableTableOrderingComposer,
      $$MemoryTableTableAnnotationComposer,
      $$MemoryTableTableCreateCompanionBuilder,
      $$MemoryTableTableUpdateCompanionBuilder,
      (MemoryTableData, $$MemoryTableTableReferences),
      MemoryTableData,
      PrefetchHooks Function({bool prevVersionId, bool attachmentTableRefs})
    >;
typedef $$MemoryRelationTableTableCreateCompanionBuilder =
    MemoryRelationTableCompanion Function({
      required String id,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      required String sourceId,
      required String targetId,
      required String type,
      Value<double> strength,
      Value<String> metadata,
      Value<int> rowid,
    });
typedef $$MemoryRelationTableTableUpdateCompanionBuilder =
    MemoryRelationTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<String> sourceId,
      Value<String> targetId,
      Value<String> type,
      Value<double> strength,
      Value<String> metadata,
      Value<int> rowid,
    });

class $$MemoryRelationTableTableFilterComposer
    extends Composer<_$KnightDatabase, $MemoryRelationTableTable> {
  $$MemoryRelationTableTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemoryRelationTableTableOrderingComposer
    extends Composer<_$KnightDatabase, $MemoryRelationTableTable> {
  $$MemoryRelationTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemoryRelationTableTableAnnotationComposer
    extends Composer<_$KnightDatabase, $MemoryRelationTableTable> {
  $$MemoryRelationTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$MemoryRelationTableTableTableManager
    extends
        RootTableManager<
          _$KnightDatabase,
          $MemoryRelationTableTable,
          MemoryRelationData,
          $$MemoryRelationTableTableFilterComposer,
          $$MemoryRelationTableTableOrderingComposer,
          $$MemoryRelationTableTableAnnotationComposer,
          $$MemoryRelationTableTableCreateCompanionBuilder,
          $$MemoryRelationTableTableUpdateCompanionBuilder,
          (
            MemoryRelationData,
            BaseReferences<
              _$KnightDatabase,
              $MemoryRelationTableTable,
              MemoryRelationData
            >,
          ),
          MemoryRelationData,
          PrefetchHooks Function()
        > {
  $$MemoryRelationTableTableTableManager(
    _$KnightDatabase db,
    $MemoryRelationTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryRelationTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryRelationTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MemoryRelationTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> strength = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryRelationTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                sourceId: sourceId,
                targetId: targetId,
                type: type,
                strength: strength,
                metadata: metadata,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String sourceId,
                required String targetId,
                required String type,
                Value<double> strength = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoryRelationTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                sourceId: sourceId,
                targetId: targetId,
                type: type,
                strength: strength,
                metadata: metadata,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemoryRelationTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KnightDatabase,
      $MemoryRelationTableTable,
      MemoryRelationData,
      $$MemoryRelationTableTableFilterComposer,
      $$MemoryRelationTableTableOrderingComposer,
      $$MemoryRelationTableTableAnnotationComposer,
      $$MemoryRelationTableTableCreateCompanionBuilder,
      $$MemoryRelationTableTableUpdateCompanionBuilder,
      (
        MemoryRelationData,
        BaseReferences<
          _$KnightDatabase,
          $MemoryRelationTableTable,
          MemoryRelationData
        >,
      ),
      MemoryRelationData,
      PrefetchHooks Function()
    >;
typedef $$EvidenceTableTableCreateCompanionBuilder =
    EvidenceTableCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      required String caid,
      required String originalName,
      required String mimeType,
      required int fileSize,
      required DateTime ingestedAt,
      required String storagePath,
      Value<String> extractionData,
      Value<int> rowid,
    });
typedef $$EvidenceTableTableUpdateCompanionBuilder =
    EvidenceTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<String> caid,
      Value<String> originalName,
      Value<String> mimeType,
      Value<int> fileSize,
      Value<DateTime> ingestedAt,
      Value<String> storagePath,
      Value<String> extractionData,
      Value<int> rowid,
    });

final class $$EvidenceTableTableReferences
    extends
        BaseReferences<
          _$KnightDatabase,
          $EvidenceTableTable,
          EvidenceTableData
        > {
  $$EvidenceTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$AttachmentTableTable, List<AttachmentTableData>>
  _attachmentTableRefsTable(_$KnightDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.attachmentTable,
        aliasName: 'evidence__caid__attachments__caid',
      );

  $$AttachmentTableTableProcessedTableManager get attachmentTableRefs {
    final manager = $$AttachmentTableTableTableManager(
      $_db,
      $_db.attachmentTable,
    ).filter((f) => f.caid.caid.sqlEquals($_itemColumn<String>('caid')!));

    final cache = $_typedResult.readTableOrNull(
      _attachmentTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EvidenceTableTableFilterComposer
    extends Composer<_$KnightDatabase, $EvidenceTableTable> {
  $$EvidenceTableTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caid => $composableBuilder(
    column: $table.caid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ingestedAt => $composableBuilder(
    column: $table.ingestedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractionData => $composableBuilder(
    column: $table.extractionData,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> attachmentTableRefs(
    Expression<bool> Function($$AttachmentTableTableFilterComposer f) f,
  ) {
    final $$AttachmentTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caid,
      referencedTable: $db.attachmentTable,
      getReferencedColumn: (t) => t.caid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentTableTableFilterComposer(
            $db: $db,
            $table: $db.attachmentTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EvidenceTableTableOrderingComposer
    extends Composer<_$KnightDatabase, $EvidenceTableTable> {
  $$EvidenceTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caid => $composableBuilder(
    column: $table.caid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ingestedAt => $composableBuilder(
    column: $table.ingestedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractionData => $composableBuilder(
    column: $table.extractionData,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EvidenceTableTableAnnotationComposer
    extends Composer<_$KnightDatabase, $EvidenceTableTable> {
  $$EvidenceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get caid =>
      $composableBuilder(column: $table.caid, builder: (column) => column);

  GeneratedColumn<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get ingestedAt => $composableBuilder(
    column: $table.ingestedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractionData => $composableBuilder(
    column: $table.extractionData,
    builder: (column) => column,
  );

  Expression<T> attachmentTableRefs<T extends Object>(
    Expression<T> Function($$AttachmentTableTableAnnotationComposer a) f,
  ) {
    final $$AttachmentTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caid,
      referencedTable: $db.attachmentTable,
      getReferencedColumn: (t) => t.caid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentTableTableAnnotationComposer(
            $db: $db,
            $table: $db.attachmentTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EvidenceTableTableTableManager
    extends
        RootTableManager<
          _$KnightDatabase,
          $EvidenceTableTable,
          EvidenceTableData,
          $$EvidenceTableTableFilterComposer,
          $$EvidenceTableTableOrderingComposer,
          $$EvidenceTableTableAnnotationComposer,
          $$EvidenceTableTableCreateCompanionBuilder,
          $$EvidenceTableTableUpdateCompanionBuilder,
          (EvidenceTableData, $$EvidenceTableTableReferences),
          EvidenceTableData,
          PrefetchHooks Function({bool attachmentTableRefs})
        > {
  $$EvidenceTableTableTableManager(
    _$KnightDatabase db,
    $EvidenceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidenceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidenceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidenceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> caid = const Value.absent(),
                Value<String> originalName = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<DateTime> ingestedAt = const Value.absent(),
                Value<String> storagePath = const Value.absent(),
                Value<String> extractionData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                caid: caid,
                originalName: originalName,
                mimeType: mimeType,
                fileSize: fileSize,
                ingestedAt: ingestedAt,
                storagePath: storagePath,
                extractionData: extractionData,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String caid,
                required String originalName,
                required String mimeType,
                required int fileSize,
                required DateTime ingestedAt,
                required String storagePath,
                Value<String> extractionData = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                caid: caid,
                originalName: originalName,
                mimeType: mimeType,
                fileSize: fileSize,
                ingestedAt: ingestedAt,
                storagePath: storagePath,
                extractionData: extractionData,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EvidenceTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attachmentTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attachmentTableRefs) db.attachmentTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attachmentTableRefs)
                    await $_getPrefetchedData<
                      EvidenceTableData,
                      $EvidenceTableTable,
                      AttachmentTableData
                    >(
                      currentTable: table,
                      referencedTable: $$EvidenceTableTableReferences
                          ._attachmentTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EvidenceTableTableReferences(
                            db,
                            table,
                            p0,
                          ).attachmentTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.caid == item.caid),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EvidenceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KnightDatabase,
      $EvidenceTableTable,
      EvidenceTableData,
      $$EvidenceTableTableFilterComposer,
      $$EvidenceTableTableOrderingComposer,
      $$EvidenceTableTableAnnotationComposer,
      $$EvidenceTableTableCreateCompanionBuilder,
      $$EvidenceTableTableUpdateCompanionBuilder,
      (EvidenceTableData, $$EvidenceTableTableReferences),
      EvidenceTableData,
      PrefetchHooks Function({bool attachmentTableRefs})
    >;
typedef $$AttachmentTableTableCreateCompanionBuilder =
    AttachmentTableCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      required String memoryId,
      required String caid,
      Value<String?> fragment,
      Value<int> rowid,
    });
typedef $$AttachmentTableTableUpdateCompanionBuilder =
    AttachmentTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<String> memoryId,
      Value<String> caid,
      Value<String?> fragment,
      Value<int> rowid,
    });

final class $$AttachmentTableTableReferences
    extends
        BaseReferences<
          _$KnightDatabase,
          $AttachmentTableTable,
          AttachmentTableData
        > {
  $$AttachmentTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MemoryTableTable _memoryIdTable(_$KnightDatabase db) =>
      db.memoryTable.createAlias('attachments__memory_id__memories__id');

  $$MemoryTableTableProcessedTableManager get memoryId {
    final $_column = $_itemColumn<String>('memory_id')!;

    final manager = $$MemoryTableTableTableManager(
      $_db,
      $_db.memoryTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EvidenceTableTable _caidTable(_$KnightDatabase db) =>
      db.evidenceTable.createAlias('attachments__caid__evidence__caid');

  $$EvidenceTableTableProcessedTableManager get caid {
    final $_column = $_itemColumn<String>('caid')!;

    final manager = $$EvidenceTableTableTableManager(
      $_db,
      $_db.evidenceTable,
    ).filter((f) => f.caid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttachmentTableTableFilterComposer
    extends Composer<_$KnightDatabase, $AttachmentTableTable> {
  $$AttachmentTableTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fragment => $composableBuilder(
    column: $table.fragment,
    builder: (column) => ColumnFilters(column),
  );

  $$MemoryTableTableFilterComposer get memoryId {
    final $$MemoryTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memoryId,
      referencedTable: $db.memoryTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryTableTableFilterComposer(
            $db: $db,
            $table: $db.memoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EvidenceTableTableFilterComposer get caid {
    final $$EvidenceTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caid,
      referencedTable: $db.evidenceTable,
      getReferencedColumn: (t) => t.caid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceTableTableFilterComposer(
            $db: $db,
            $table: $db.evidenceTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentTableTableOrderingComposer
    extends Composer<_$KnightDatabase, $AttachmentTableTable> {
  $$AttachmentTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fragment => $composableBuilder(
    column: $table.fragment,
    builder: (column) => ColumnOrderings(column),
  );

  $$MemoryTableTableOrderingComposer get memoryId {
    final $$MemoryTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memoryId,
      referencedTable: $db.memoryTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryTableTableOrderingComposer(
            $db: $db,
            $table: $db.memoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EvidenceTableTableOrderingComposer get caid {
    final $$EvidenceTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caid,
      referencedTable: $db.evidenceTable,
      getReferencedColumn: (t) => t.caid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceTableTableOrderingComposer(
            $db: $db,
            $table: $db.evidenceTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentTableTableAnnotationComposer
    extends Composer<_$KnightDatabase, $AttachmentTableTable> {
  $$AttachmentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get fragment =>
      $composableBuilder(column: $table.fragment, builder: (column) => column);

  $$MemoryTableTableAnnotationComposer get memoryId {
    final $$MemoryTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memoryId,
      referencedTable: $db.memoryTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryTableTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EvidenceTableTableAnnotationComposer get caid {
    final $$EvidenceTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caid,
      referencedTable: $db.evidenceTable,
      getReferencedColumn: (t) => t.caid,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EvidenceTableTableAnnotationComposer(
            $db: $db,
            $table: $db.evidenceTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentTableTableTableManager
    extends
        RootTableManager<
          _$KnightDatabase,
          $AttachmentTableTable,
          AttachmentTableData,
          $$AttachmentTableTableFilterComposer,
          $$AttachmentTableTableOrderingComposer,
          $$AttachmentTableTableAnnotationComposer,
          $$AttachmentTableTableCreateCompanionBuilder,
          $$AttachmentTableTableUpdateCompanionBuilder,
          (AttachmentTableData, $$AttachmentTableTableReferences),
          AttachmentTableData,
          PrefetchHooks Function({bool memoryId, bool caid})
        > {
  $$AttachmentTableTableTableManager(
    _$KnightDatabase db,
    $AttachmentTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> memoryId = const Value.absent(),
                Value<String> caid = const Value.absent(),
                Value<String?> fragment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                memoryId: memoryId,
                caid: caid,
                fragment: fragment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String memoryId,
                required String caid,
                Value<String?> fragment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                memoryId: memoryId,
                caid: caid,
                fragment: fragment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttachmentTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memoryId = false, caid = false}) {
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
                    if (memoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memoryId,
                                referencedTable:
                                    $$AttachmentTableTableReferences
                                        ._memoryIdTable(db),
                                referencedColumn:
                                    $$AttachmentTableTableReferences
                                        ._memoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (caid) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.caid,
                                referencedTable:
                                    $$AttachmentTableTableReferences._caidTable(
                                      db,
                                    ),
                                referencedColumn:
                                    $$AttachmentTableTableReferences
                                        ._caidTable(db)
                                        .caid,
                              )
                              as T;
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

typedef $$AttachmentTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KnightDatabase,
      $AttachmentTableTable,
      AttachmentTableData,
      $$AttachmentTableTableFilterComposer,
      $$AttachmentTableTableOrderingComposer,
      $$AttachmentTableTableAnnotationComposer,
      $$AttachmentTableTableCreateCompanionBuilder,
      $$AttachmentTableTableUpdateCompanionBuilder,
      (AttachmentTableData, $$AttachmentTableTableReferences),
      AttachmentTableData,
      PrefetchHooks Function({bool memoryId, bool caid})
    >;
typedef $$AuditLogTableTableCreateCompanionBuilder =
    AuditLogTableCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      required DateTime timestamp,
      required String operation,
      required String tableNameRef,
      required String recordId,
      Value<String?> details,
      Value<int> rowid,
    });
typedef $$AuditLogTableTableUpdateCompanionBuilder =
    AuditLogTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<DateTime> timestamp,
      Value<String> operation,
      Value<String> tableNameRef,
      Value<String> recordId,
      Value<String?> details,
      Value<int> rowid,
    });

class $$AuditLogTableTableFilterComposer
    extends Composer<_$KnightDatabase, $AuditLogTableTable> {
  $$AuditLogTableTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableNameRef => $composableBuilder(
    column: $table.tableNameRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableTableOrderingComposer
    extends Composer<_$KnightDatabase, $AuditLogTableTable> {
  $$AuditLogTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableNameRef => $composableBuilder(
    column: $table.tableNameRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableTableAnnotationComposer
    extends Composer<_$KnightDatabase, $AuditLogTableTable> {
  $$AuditLogTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get tableNameRef => $composableBuilder(
    column: $table.tableNameRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);
}

class $$AuditLogTableTableTableManager
    extends
        RootTableManager<
          _$KnightDatabase,
          $AuditLogTableTable,
          AuditLogData,
          $$AuditLogTableTableFilterComposer,
          $$AuditLogTableTableOrderingComposer,
          $$AuditLogTableTableAnnotationComposer,
          $$AuditLogTableTableCreateCompanionBuilder,
          $$AuditLogTableTableUpdateCompanionBuilder,
          (
            AuditLogData,
            BaseReferences<_$KnightDatabase, $AuditLogTableTable, AuditLogData>,
          ),
          AuditLogData,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableTableManager(
    _$KnightDatabase db,
    $AuditLogTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> tableNameRef = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                timestamp: timestamp,
                operation: operation,
                tableNameRef: tableNameRef,
                recordId: recordId,
                details: details,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required DateTime timestamp,
                required String operation,
                required String tableNameRef,
                required String recordId,
                Value<String?> details = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                timestamp: timestamp,
                operation: operation,
                tableNameRef: tableNameRef,
                recordId: recordId,
                details: details,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KnightDatabase,
      $AuditLogTableTable,
      AuditLogData,
      $$AuditLogTableTableFilterComposer,
      $$AuditLogTableTableOrderingComposer,
      $$AuditLogTableTableAnnotationComposer,
      $$AuditLogTableTableCreateCompanionBuilder,
      $$AuditLogTableTableUpdateCompanionBuilder,
      (
        AuditLogData,
        BaseReferences<_$KnightDatabase, $AuditLogTableTable, AuditLogData>,
      ),
      AuditLogData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableTableCreateCompanionBuilder =
    SyncQueueTableCompanion Function({
      required String id,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      required String recordId,
      required String targetTable,
      required String action,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$SyncQueueTableTableUpdateCompanionBuilder =
    SyncQueueTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<String> recordId,
      Value<String> targetTable,
      Value<String> action,
      Value<String> status,
      Value<int> rowid,
    });

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$KnightDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$KnightDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$KnightDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SyncQueueTableTableTableManager
    extends
        RootTableManager<
          _$KnightDatabase,
          $SyncQueueTableTable,
          SyncQueueData,
          $$SyncQueueTableTableFilterComposer,
          $$SyncQueueTableTableOrderingComposer,
          $$SyncQueueTableTableAnnotationComposer,
          $$SyncQueueTableTableCreateCompanionBuilder,
          $$SyncQueueTableTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<
              _$KnightDatabase,
              $SyncQueueTableTable,
              SyncQueueData
            >,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableTableManager(
    _$KnightDatabase db,
    $SyncQueueTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                recordId: recordId,
                targetTable: targetTable,
                action: action,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String recordId,
                required String targetTable,
                required String action,
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                recordId: recordId,
                targetTable: targetTable,
                action: action,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KnightDatabase,
      $SyncQueueTableTable,
      SyncQueueData,
      $$SyncQueueTableTableFilterComposer,
      $$SyncQueueTableTableOrderingComposer,
      $$SyncQueueTableTableAnnotationComposer,
      $$SyncQueueTableTableCreateCompanionBuilder,
      $$SyncQueueTableTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$KnightDatabase, $SyncQueueTableTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$QuestionStatusTableTableCreateCompanionBuilder =
    QuestionStatusTableCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      required String questionId,
      Value<bool> isAnswered,
      Value<bool> isSkipped,
      Value<DateTime?> lastOffered,
      Value<String?> memoryId,
      Value<int> rowid,
    });
typedef $$QuestionStatusTableTableUpdateCompanionBuilder =
    QuestionStatusTableCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<String> syncStatus,
      Value<String?> deviceId,
      Value<String> questionId,
      Value<bool> isAnswered,
      Value<bool> isSkipped,
      Value<DateTime?> lastOffered,
      Value<String?> memoryId,
      Value<int> rowid,
    });

class $$QuestionStatusTableTableFilterComposer
    extends Composer<_$KnightDatabase, $QuestionStatusTableTable> {
  $$QuestionStatusTableTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAnswered => $composableBuilder(
    column: $table.isAnswered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOffered => $composableBuilder(
    column: $table.lastOffered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memoryId => $composableBuilder(
    column: $table.memoryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionStatusTableTableOrderingComposer
    extends Composer<_$KnightDatabase, $QuestionStatusTableTable> {
  $$QuestionStatusTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAnswered => $composableBuilder(
    column: $table.isAnswered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOffered => $composableBuilder(
    column: $table.lastOffered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memoryId => $composableBuilder(
    column: $table.memoryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionStatusTableTableAnnotationComposer
    extends Composer<_$KnightDatabase, $QuestionStatusTableTable> {
  $$QuestionStatusTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAnswered => $composableBuilder(
    column: $table.isAnswered,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSkipped =>
      $composableBuilder(column: $table.isSkipped, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOffered => $composableBuilder(
    column: $table.lastOffered,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memoryId =>
      $composableBuilder(column: $table.memoryId, builder: (column) => column);
}

class $$QuestionStatusTableTableTableManager
    extends
        RootTableManager<
          _$KnightDatabase,
          $QuestionStatusTableTable,
          QuestionStatusTableData,
          $$QuestionStatusTableTableFilterComposer,
          $$QuestionStatusTableTableOrderingComposer,
          $$QuestionStatusTableTableAnnotationComposer,
          $$QuestionStatusTableTableCreateCompanionBuilder,
          $$QuestionStatusTableTableUpdateCompanionBuilder,
          (
            QuestionStatusTableData,
            BaseReferences<
              _$KnightDatabase,
              $QuestionStatusTableTable,
              QuestionStatusTableData
            >,
          ),
          QuestionStatusTableData,
          PrefetchHooks Function()
        > {
  $$QuestionStatusTableTableTableManager(
    _$KnightDatabase db,
    $QuestionStatusTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionStatusTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionStatusTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$QuestionStatusTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<bool> isAnswered = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
                Value<DateTime?> lastOffered = const Value.absent(),
                Value<String?> memoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionStatusTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                questionId: questionId,
                isAnswered: isAnswered,
                isSkipped: isSkipped,
                lastOffered: lastOffered,
                memoryId: memoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                required String questionId,
                Value<bool> isAnswered = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
                Value<DateTime?> lastOffered = const Value.absent(),
                Value<String?> memoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionStatusTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                deviceId: deviceId,
                questionId: questionId,
                isAnswered: isAnswered,
                isSkipped: isSkipped,
                lastOffered: lastOffered,
                memoryId: memoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionStatusTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KnightDatabase,
      $QuestionStatusTableTable,
      QuestionStatusTableData,
      $$QuestionStatusTableTableFilterComposer,
      $$QuestionStatusTableTableOrderingComposer,
      $$QuestionStatusTableTableAnnotationComposer,
      $$QuestionStatusTableTableCreateCompanionBuilder,
      $$QuestionStatusTableTableUpdateCompanionBuilder,
      (
        QuestionStatusTableData,
        BaseReferences<
          _$KnightDatabase,
          $QuestionStatusTableTable,
          QuestionStatusTableData
        >,
      ),
      QuestionStatusTableData,
      PrefetchHooks Function()
    >;

class $KnightDatabaseManager {
  final _$KnightDatabase _db;
  $KnightDatabaseManager(this._db);
  $$MigrationLedgerTableTableManager get migrationLedger =>
      $$MigrationLedgerTableTableManager(_db, _db.migrationLedger);
  $$UserProfileTableTableTableManager get userProfileTable =>
      $$UserProfileTableTableTableManager(_db, _db.userProfileTable);
  $$MemoryTableTableTableManager get memoryTable =>
      $$MemoryTableTableTableManager(_db, _db.memoryTable);
  $$MemoryRelationTableTableTableManager get memoryRelationTable =>
      $$MemoryRelationTableTableTableManager(_db, _db.memoryRelationTable);
  $$EvidenceTableTableTableManager get evidenceTable =>
      $$EvidenceTableTableTableManager(_db, _db.evidenceTable);
  $$AttachmentTableTableTableManager get attachmentTable =>
      $$AttachmentTableTableTableManager(_db, _db.attachmentTable);
  $$AuditLogTableTableTableManager get auditLogTable =>
      $$AuditLogTableTableTableManager(_db, _db.auditLogTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
  $$QuestionStatusTableTableTableManager get questionStatusTable =>
      $$QuestionStatusTableTableTableManager(_db, _db.questionStatusTable);
}
