// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordTextMeta = const VerificationMeta(
    'wordText',
  );
  @override
  late final GeneratedColumn<String> wordText = GeneratedColumn<String>(
    'word_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortMeaningMeta = const VerificationMeta(
    'shortMeaning',
  );
  @override
  late final GeneratedColumn<String> shortMeaning = GeneratedColumn<String>(
    'short_meaning',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partsOfSpeechMeta = const VerificationMeta(
    'partsOfSpeech',
  );
  @override
  late final GeneratedColumn<String> partsOfSpeech = GeneratedColumn<String>(
    'parts_of_speech',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordText,
    languageCode,
    shortMeaning,
    partsOfSpeech,
    createdAt,
    updatedAt,
    deletedAt,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<Word> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word_text')) {
      context.handle(
        _wordTextMeta,
        wordText.isAcceptableOrUnknown(data['word_text']!, _wordTextMeta),
      );
    } else if (isInserting) {
      context.missing(_wordTextMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('short_meaning')) {
      context.handle(
        _shortMeaningMeta,
        shortMeaning.isAcceptableOrUnknown(
          data['short_meaning']!,
          _shortMeaningMeta,
        ),
      );
    }
    if (data.containsKey('parts_of_speech')) {
      context.handle(
        _partsOfSpeechMeta,
        partsOfSpeech.isAcceptableOrUnknown(
          data['parts_of_speech']!,
          _partsOfSpeechMeta,
        ),
      );
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
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      wordText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}word_text'],
          )!,
      languageCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}language_code'],
          )!,
      shortMeaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_meaning'],
      ),
      partsOfSpeech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parts_of_speech'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      isFavorite:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_favorite'],
          )!,
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
  final String id;
  final String wordText;
  final String languageCode;
  final String? shortMeaning;
  final String? partsOfSpeech;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final bool isFavorite;
  const Word({
    required this.id,
    required this.wordText,
    required this.languageCode,
    this.shortMeaning,
    this.partsOfSpeech,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word_text'] = Variable<String>(wordText);
    map['language_code'] = Variable<String>(languageCode);
    if (!nullToAbsent || shortMeaning != null) {
      map['short_meaning'] = Variable<String>(shortMeaning);
    }
    if (!nullToAbsent || partsOfSpeech != null) {
      map['parts_of_speech'] = Variable<String>(partsOfSpeech);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      wordText: Value(wordText),
      languageCode: Value(languageCode),
      shortMeaning:
          shortMeaning == null && nullToAbsent
              ? const Value.absent()
              : Value(shortMeaning),
      partsOfSpeech:
          partsOfSpeech == null && nullToAbsent
              ? const Value.absent()
              : Value(partsOfSpeech),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
      isFavorite: Value(isFavorite),
    );
  }

  factory Word.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<String>(json['id']),
      wordText: serializer.fromJson<String>(json['wordText']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      shortMeaning: serializer.fromJson<String?>(json['shortMeaning']),
      partsOfSpeech: serializer.fromJson<String?>(json['partsOfSpeech']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wordText': serializer.toJson<String>(wordText),
      'languageCode': serializer.toJson<String>(languageCode),
      'shortMeaning': serializer.toJson<String?>(shortMeaning),
      'partsOfSpeech': serializer.toJson<String?>(partsOfSpeech),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  Word copyWith({
    String? id,
    String? wordText,
    String? languageCode,
    Value<String?> shortMeaning = const Value.absent(),
    Value<String?> partsOfSpeech = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    bool? isFavorite,
  }) => Word(
    id: id ?? this.id,
    wordText: wordText ?? this.wordText,
    languageCode: languageCode ?? this.languageCode,
    shortMeaning: shortMeaning.present ? shortMeaning.value : this.shortMeaning,
    partsOfSpeech:
        partsOfSpeech.present ? partsOfSpeech.value : this.partsOfSpeech,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      wordText: data.wordText.present ? data.wordText.value : this.wordText,
      languageCode:
          data.languageCode.present
              ? data.languageCode.value
              : this.languageCode,
      shortMeaning:
          data.shortMeaning.present
              ? data.shortMeaning.value
              : this.shortMeaning,
      partsOfSpeech:
          data.partsOfSpeech.present
              ? data.partsOfSpeech.value
              : this.partsOfSpeech,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('wordText: $wordText, ')
          ..write('languageCode: $languageCode, ')
          ..write('shortMeaning: $shortMeaning, ')
          ..write('partsOfSpeech: $partsOfSpeech, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wordText,
    languageCode,
    shortMeaning,
    partsOfSpeech,
    createdAt,
    updatedAt,
    deletedAt,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.wordText == this.wordText &&
          other.languageCode == this.languageCode &&
          other.shortMeaning == this.shortMeaning &&
          other.partsOfSpeech == this.partsOfSpeech &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.isFavorite == this.isFavorite);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<String> id;
  final Value<String> wordText;
  final Value<String> languageCode;
  final Value<String?> shortMeaning;
  final Value<String?> partsOfSpeech;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.wordText = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.shortMeaning = const Value.absent(),
    this.partsOfSpeech = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordsCompanion.insert({
    required String id,
    required String wordText,
    required String languageCode,
    this.shortMeaning = const Value.absent(),
    this.partsOfSpeech = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wordText = Value(wordText),
       languageCode = Value(languageCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Word> custom({
    Expression<String>? id,
    Expression<String>? wordText,
    Expression<String>? languageCode,
    Expression<String>? shortMeaning,
    Expression<String>? partsOfSpeech,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordText != null) 'word_text': wordText,
      if (languageCode != null) 'language_code': languageCode,
      if (shortMeaning != null) 'short_meaning': shortMeaning,
      if (partsOfSpeech != null) 'parts_of_speech': partsOfSpeech,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordsCompanion copyWith({
    Value<String>? id,
    Value<String>? wordText,
    Value<String>? languageCode,
    Value<String?>? shortMeaning,
    Value<String?>? partsOfSpeech,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      wordText: wordText ?? this.wordText,
      languageCode: languageCode ?? this.languageCode,
      shortMeaning: shortMeaning ?? this.shortMeaning,
      partsOfSpeech: partsOfSpeech ?? this.partsOfSpeech,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wordText.present) {
      map['word_text'] = Variable<String>(wordText.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (shortMeaning.present) {
      map['short_meaning'] = Variable<String>(shortMeaning.value);
    }
    if (partsOfSpeech.present) {
      map['parts_of_speech'] = Variable<String>(partsOfSpeech.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('wordText: $wordText, ')
          ..write('languageCode: $languageCode, ')
          ..write('shortMeaning: $shortMeaning, ')
          ..write('partsOfSpeech: $partsOfSpeech, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LanguagesTable extends Languages
    with TableInfo<$LanguagesTable, Language> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LanguagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [code, displayName, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'languages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Language> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Language map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Language(
      code:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}code'],
          )!,
      displayName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}display_name'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $LanguagesTable createAlias(String alias) {
    return $LanguagesTable(attachedDatabase, alias);
  }
}

class Language extends DataClass implements Insertable<Language> {
  final String code;
  final String displayName;
  final int createdAt;
  const Language({
    required this.code,
    required this.displayName,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  LanguagesCompanion toCompanion(bool nullToAbsent) {
    return LanguagesCompanion(
      code: Value(code),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
    );
  }

  factory Language.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Language(
      code: serializer.fromJson<String>(json['code']),
      displayName: serializer.fromJson<String>(json['displayName']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'displayName': serializer.toJson<String>(displayName),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Language copyWith({String? code, String? displayName, int? createdAt}) =>
      Language(
        code: code ?? this.code,
        displayName: displayName ?? this.displayName,
        createdAt: createdAt ?? this.createdAt,
      );
  Language copyWithCompanion(LanguagesCompanion data) {
    return Language(
      code: data.code.present ? data.code.value : this.code,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Language(')
          ..write('code: $code, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, displayName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Language &&
          other.code == this.code &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt);
}

class LanguagesCompanion extends UpdateCompanion<Language> {
  final Value<String> code;
  final Value<String> displayName;
  final Value<int> createdAt;
  final Value<int> rowid;
  const LanguagesCompanion({
    this.code = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LanguagesCompanion.insert({
    required String code,
    required String displayName,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       displayName = Value(displayName),
       createdAt = Value(createdAt);
  static Insertable<Language> custom({
    Expression<String>? code,
    Expression<String>? displayName,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LanguagesCompanion copyWith({
    Value<String>? code,
    Value<String>? displayName,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return LanguagesCompanion(
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguagesCompanion(')
          ..write('code: $code, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WordMetadataTable extends WordMetadata
    with TableInfo<$WordMetadataTable, WordMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    wordId,
    metadataJson,
    source,
    version,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_metadataJsonMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  WordMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordMetadataData(
      wordId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}word_id'],
          )!,
      metadataJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}metadata_json'],
          )!,
      source:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source'],
          )!,
      version:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}version'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $WordMetadataTable createAlias(String alias) {
    return $WordMetadataTable(attachedDatabase, alias);
  }
}

class WordMetadataData extends DataClass
    implements Insertable<WordMetadataData> {
  final String wordId;
  final String metadataJson;
  final String source;
  final int version;
  final int updatedAt;
  const WordMetadataData({
    required this.wordId,
    required this.metadataJson,
    required this.source,
    required this.version,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['metadata_json'] = Variable<String>(metadataJson);
    map['source'] = Variable<String>(source);
    map['version'] = Variable<int>(version);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  WordMetadataCompanion toCompanion(bool nullToAbsent) {
    return WordMetadataCompanion(
      wordId: Value(wordId),
      metadataJson: Value(metadataJson),
      source: Value(source),
      version: Value(version),
      updatedAt: Value(updatedAt),
    );
  }

  factory WordMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordMetadataData(
      wordId: serializer.fromJson<String>(json['wordId']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      source: serializer.fromJson<String>(json['source']),
      version: serializer.fromJson<int>(json['version']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'source': serializer.toJson<String>(source),
      'version': serializer.toJson<int>(version),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  WordMetadataData copyWith({
    String? wordId,
    String? metadataJson,
    String? source,
    int? version,
    int? updatedAt,
  }) => WordMetadataData(
    wordId: wordId ?? this.wordId,
    metadataJson: metadataJson ?? this.metadataJson,
    source: source ?? this.source,
    version: version ?? this.version,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WordMetadataData copyWithCompanion(WordMetadataCompanion data) {
    return WordMetadataData(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      metadataJson:
          data.metadataJson.present
              ? data.metadataJson.value
              : this.metadataJson,
      source: data.source.present ? data.source.value : this.source,
      version: data.version.present ? data.version.value : this.version,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordMetadataData(')
          ..write('wordId: $wordId, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('source: $source, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(wordId, metadataJson, source, version, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordMetadataData &&
          other.wordId == this.wordId &&
          other.metadataJson == this.metadataJson &&
          other.source == this.source &&
          other.version == this.version &&
          other.updatedAt == this.updatedAt);
}

class WordMetadataCompanion extends UpdateCompanion<WordMetadataData> {
  final Value<String> wordId;
  final Value<String> metadataJson;
  final Value<String> source;
  final Value<int> version;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const WordMetadataCompanion({
    this.wordId = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.source = const Value.absent(),
    this.version = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordMetadataCompanion.insert({
    required String wordId,
    required String metadataJson,
    required String source,
    required int version,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId),
       metadataJson = Value(metadataJson),
       source = Value(source),
       version = Value(version),
       updatedAt = Value(updatedAt);
  static Insertable<WordMetadataData> custom({
    Expression<String>? wordId,
    Expression<String>? metadataJson,
    Expression<String>? source,
    Expression<int>? version,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (source != null) 'source': source,
      if (version != null) 'version': version,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordMetadataCompanion copyWith({
    Value<String>? wordId,
    Value<String>? metadataJson,
    Value<String>? source,
    Value<int>? version,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return WordMetadataCompanion(
      wordId: wordId ?? this.wordId,
      metadataJson: metadataJson ?? this.metadataJson,
      source: source ?? this.source,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordMetadataCompanion(')
          ..write('wordId: $wordId, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('source: $source, ')
          ..write('version: $version, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WordLearningProgressTable extends WordLearningProgress
    with TableInfo<$WordLearningProgressTable, WordLearningProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordLearningProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _learningStatusMeta = const VerificationMeta(
    'learningStatus',
  );
  @override
  late final GeneratedColumn<String> learningStatus = GeneratedColumn<String>(
    'learning_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unlearned'),
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _incorrectCountMeta = const VerificationMeta(
    'incorrectCount',
  );
  @override
  late final GeneratedColumn<int> incorrectCount = GeneratedColumn<int>(
    'incorrect_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<int> lastReviewedAt = GeneratedColumn<int>(
    'last_reviewed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    wordId,
    learningStatus,
    correctCount,
    incorrectCount,
    lastReviewedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_learning_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordLearningProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('learning_status')) {
      context.handle(
        _learningStatusMeta,
        learningStatus.isAcceptableOrUnknown(
          data['learning_status']!,
          _learningStatusMeta,
        ),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    if (data.containsKey('incorrect_count')) {
      context.handle(
        _incorrectCountMeta,
        incorrectCount.isAcceptableOrUnknown(
          data['incorrect_count']!,
          _incorrectCountMeta,
        ),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
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
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  WordLearningProgressData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordLearningProgressData(
      wordId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}word_id'],
          )!,
      learningStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}learning_status'],
          )!,
      correctCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}correct_count'],
          )!,
      incorrectCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}incorrect_count'],
          )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_reviewed_at'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $WordLearningProgressTable createAlias(String alias) {
    return $WordLearningProgressTable(attachedDatabase, alias);
  }
}

class WordLearningProgressData extends DataClass
    implements Insertable<WordLearningProgressData> {
  final String wordId;

  /// 'unlearned' | 'learned'
  final String learningStatus;
  final int correctCount;
  final int incorrectCount;
  final int? lastReviewedAt;
  final int createdAt;
  final int updatedAt;
  const WordLearningProgressData({
    required this.wordId,
    required this.learningStatus,
    required this.correctCount,
    required this.incorrectCount,
    this.lastReviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['learning_status'] = Variable<String>(learningStatus);
    map['correct_count'] = Variable<int>(correctCount);
    map['incorrect_count'] = Variable<int>(incorrectCount);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<int>(lastReviewedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  WordLearningProgressCompanion toCompanion(bool nullToAbsent) {
    return WordLearningProgressCompanion(
      wordId: Value(wordId),
      learningStatus: Value(learningStatus),
      correctCount: Value(correctCount),
      incorrectCount: Value(incorrectCount),
      lastReviewedAt:
          lastReviewedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastReviewedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WordLearningProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordLearningProgressData(
      wordId: serializer.fromJson<String>(json['wordId']),
      learningStatus: serializer.fromJson<String>(json['learningStatus']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      incorrectCount: serializer.fromJson<int>(json['incorrectCount']),
      lastReviewedAt: serializer.fromJson<int?>(json['lastReviewedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'learningStatus': serializer.toJson<String>(learningStatus),
      'correctCount': serializer.toJson<int>(correctCount),
      'incorrectCount': serializer.toJson<int>(incorrectCount),
      'lastReviewedAt': serializer.toJson<int?>(lastReviewedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  WordLearningProgressData copyWith({
    String? wordId,
    String? learningStatus,
    int? correctCount,
    int? incorrectCount,
    Value<int?> lastReviewedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => WordLearningProgressData(
    wordId: wordId ?? this.wordId,
    learningStatus: learningStatus ?? this.learningStatus,
    correctCount: correctCount ?? this.correctCount,
    incorrectCount: incorrectCount ?? this.incorrectCount,
    lastReviewedAt:
        lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WordLearningProgressData copyWithCompanion(
    WordLearningProgressCompanion data,
  ) {
    return WordLearningProgressData(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      learningStatus:
          data.learningStatus.present
              ? data.learningStatus.value
              : this.learningStatus,
      correctCount:
          data.correctCount.present
              ? data.correctCount.value
              : this.correctCount,
      incorrectCount:
          data.incorrectCount.present
              ? data.incorrectCount.value
              : this.incorrectCount,
      lastReviewedAt:
          data.lastReviewedAt.present
              ? data.lastReviewedAt.value
              : this.lastReviewedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordLearningProgressData(')
          ..write('wordId: $wordId, ')
          ..write('learningStatus: $learningStatus, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    wordId,
    learningStatus,
    correctCount,
    incorrectCount,
    lastReviewedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordLearningProgressData &&
          other.wordId == this.wordId &&
          other.learningStatus == this.learningStatus &&
          other.correctCount == this.correctCount &&
          other.incorrectCount == this.incorrectCount &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WordLearningProgressCompanion
    extends UpdateCompanion<WordLearningProgressData> {
  final Value<String> wordId;
  final Value<String> learningStatus;
  final Value<int> correctCount;
  final Value<int> incorrectCount;
  final Value<int?> lastReviewedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const WordLearningProgressCompanion({
    this.wordId = const Value.absent(),
    this.learningStatus = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordLearningProgressCompanion.insert({
    required String wordId,
    this.learningStatus = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WordLearningProgressData> custom({
    Expression<String>? wordId,
    Expression<String>? learningStatus,
    Expression<int>? correctCount,
    Expression<int>? incorrectCount,
    Expression<int>? lastReviewedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (learningStatus != null) 'learning_status': learningStatus,
      if (correctCount != null) 'correct_count': correctCount,
      if (incorrectCount != null) 'incorrect_count': incorrectCount,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordLearningProgressCompanion copyWith({
    Value<String>? wordId,
    Value<String>? learningStatus,
    Value<int>? correctCount,
    Value<int>? incorrectCount,
    Value<int?>? lastReviewedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return WordLearningProgressCompanion(
      wordId: wordId ?? this.wordId,
      learningStatus: learningStatus ?? this.learningStatus,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (learningStatus.present) {
      map['learning_status'] = Variable<String>(learningStatus.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (incorrectCount.present) {
      map['incorrect_count'] = Variable<int>(incorrectCount.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<int>(lastReviewedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordLearningProgressCompanion(')
          ..write('wordId: $wordId, ')
          ..write('learningStatus: $learningStatus, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
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
  late final $WordsTable words = $WordsTable(this);
  late final $LanguagesTable languages = $LanguagesTable(this);
  late final $WordMetadataTable wordMetadata = $WordMetadataTable(this);
  late final $WordLearningProgressTable wordLearningProgress =
      $WordLearningProgressTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    words,
    languages,
    wordMetadata,
    wordLearningProgress,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'words',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('word_metadata', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WordsTableCreateCompanionBuilder =
    WordsCompanion Function({
      required String id,
      required String wordText,
      required String languageCode,
      Value<String?> shortMeaning,
      Value<String?> partsOfSpeech,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<bool> isFavorite,
      Value<int> rowid,
    });
typedef $$WordsTableUpdateCompanionBuilder =
    WordsCompanion Function({
      Value<String> id,
      Value<String> wordText,
      Value<String> languageCode,
      Value<String?> shortMeaning,
      Value<String?> partsOfSpeech,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<bool> isFavorite,
      Value<int> rowid,
    });

final class $$WordsTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTable, Word> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WordMetadataTable, List<WordMetadataData>>
  _wordMetadataRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wordMetadata,
    aliasName: $_aliasNameGenerator(db.words.id, db.wordMetadata.wordId),
  );

  $$WordMetadataTableProcessedTableManager get wordMetadataRefs {
    final manager = $$WordMetadataTableTableManager(
      $_db,
      $_db.wordMetadata,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordMetadataRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
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

  ColumnFilters<String> get wordText => $composableBuilder(
    column: $table.wordText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortMeaning => $composableBuilder(
    column: $table.shortMeaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partsOfSpeech => $composableBuilder(
    column: $table.partsOfSpeech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> wordMetadataRefs(
    Expression<bool> Function($$WordMetadataTableFilterComposer f) f,
  ) {
    final $$WordMetadataTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordMetadata,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordMetadataTableFilterComposer(
            $db: $db,
            $table: $db.wordMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
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

  ColumnOrderings<String> get wordText => $composableBuilder(
    column: $table.wordText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortMeaning => $composableBuilder(
    column: $table.shortMeaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partsOfSpeech => $composableBuilder(
    column: $table.partsOfSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wordText =>
      $composableBuilder(column: $table.wordText, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shortMeaning => $composableBuilder(
    column: $table.shortMeaning,
    builder: (column) => column,
  );

  GeneratedColumn<String> get partsOfSpeech => $composableBuilder(
    column: $table.partsOfSpeech,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  Expression<T> wordMetadataRefs<T extends Object>(
    Expression<T> Function($$WordMetadataTableAnnotationComposer a) f,
  ) {
    final $$WordMetadataTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordMetadata,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordMetadataTableAnnotationComposer(
            $db: $db,
            $table: $db.wordMetadata,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          Word,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (Word, $$WordsTableReferences),
          Word,
          PrefetchHooks Function({bool wordMetadataRefs})
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> wordText = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String?> shortMeaning = const Value.absent(),
                Value<String?> partsOfSpeech = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                wordText: wordText,
                languageCode: languageCode,
                shortMeaning: shortMeaning,
                partsOfSpeech: partsOfSpeech,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String wordText,
                required String languageCode,
                Value<String?> shortMeaning = const Value.absent(),
                Value<String?> partsOfSpeech = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion.insert(
                id: id,
                wordText: wordText,
                languageCode: languageCode,
                shortMeaning: shortMeaning,
                partsOfSpeech: partsOfSpeech,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WordsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({wordMetadataRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (wordMetadataRefs) db.wordMetadata],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (wordMetadataRefs)
                    await $_getPrefetchedData<
                      Word,
                      $WordsTable,
                      WordMetadataData
                    >(
                      currentTable: table,
                      referencedTable: $$WordsTableReferences
                          ._wordMetadataRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).wordMetadataRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.wordId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      Word,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (Word, $$WordsTableReferences),
      Word,
      PrefetchHooks Function({bool wordMetadataRefs})
    >;
typedef $$LanguagesTableCreateCompanionBuilder =
    LanguagesCompanion Function({
      required String code,
      required String displayName,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$LanguagesTableUpdateCompanionBuilder =
    LanguagesCompanion Function({
      Value<String> code,
      Value<String> displayName,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$LanguagesTableFilterComposer
    extends Composer<_$AppDatabase, $LanguagesTable> {
  $$LanguagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LanguagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LanguagesTable> {
  $$LanguagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LanguagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LanguagesTable> {
  $$LanguagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LanguagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LanguagesTable,
          Language,
          $$LanguagesTableFilterComposer,
          $$LanguagesTableOrderingComposer,
          $$LanguagesTableAnnotationComposer,
          $$LanguagesTableCreateCompanionBuilder,
          $$LanguagesTableUpdateCompanionBuilder,
          (Language, BaseReferences<_$AppDatabase, $LanguagesTable, Language>),
          Language,
          PrefetchHooks Function()
        > {
  $$LanguagesTableTableManager(_$AppDatabase db, $LanguagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LanguagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LanguagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$LanguagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LanguagesCompanion(
                code: code,
                displayName: displayName,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String displayName,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LanguagesCompanion.insert(
                code: code,
                displayName: displayName,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LanguagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LanguagesTable,
      Language,
      $$LanguagesTableFilterComposer,
      $$LanguagesTableOrderingComposer,
      $$LanguagesTableAnnotationComposer,
      $$LanguagesTableCreateCompanionBuilder,
      $$LanguagesTableUpdateCompanionBuilder,
      (Language, BaseReferences<_$AppDatabase, $LanguagesTable, Language>),
      Language,
      PrefetchHooks Function()
    >;
typedef $$WordMetadataTableCreateCompanionBuilder =
    WordMetadataCompanion Function({
      required String wordId,
      required String metadataJson,
      required String source,
      required int version,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$WordMetadataTableUpdateCompanionBuilder =
    WordMetadataCompanion Function({
      Value<String> wordId,
      Value<String> metadataJson,
      Value<String> source,
      Value<int> version,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$WordMetadataTableReferences
    extends
        BaseReferences<_$AppDatabase, $WordMetadataTable, WordMetadataData> {
  $$WordMetadataTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) => db.words.createAlias(
    $_aliasNameGenerator(db.wordMetadata.wordId, db.words.id),
  );

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WordMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $WordMetadataTable> {
  $$WordMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $WordMetadataTable> {
  $$WordMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordMetadataTable> {
  $$WordMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordMetadataTable,
          WordMetadataData,
          $$WordMetadataTableFilterComposer,
          $$WordMetadataTableOrderingComposer,
          $$WordMetadataTableAnnotationComposer,
          $$WordMetadataTableCreateCompanionBuilder,
          $$WordMetadataTableUpdateCompanionBuilder,
          (WordMetadataData, $$WordMetadataTableReferences),
          WordMetadataData,
          PrefetchHooks Function({bool wordId})
        > {
  $$WordMetadataTableTableManager(_$AppDatabase db, $WordMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WordMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WordMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$WordMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> wordId = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordMetadataCompanion(
                wordId: wordId,
                metadataJson: metadataJson,
                source: source,
                version: version,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String wordId,
                required String metadataJson,
                required String source,
                required int version,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WordMetadataCompanion.insert(
                wordId: wordId,
                metadataJson: metadataJson,
                source: source,
                version: version,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WordMetadataTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (wordId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.wordId,
                            referencedTable: $$WordMetadataTableReferences
                                ._wordIdTable(db),
                            referencedColumn:
                                $$WordMetadataTableReferences
                                    ._wordIdTable(db)
                                    .id,
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

typedef $$WordMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordMetadataTable,
      WordMetadataData,
      $$WordMetadataTableFilterComposer,
      $$WordMetadataTableOrderingComposer,
      $$WordMetadataTableAnnotationComposer,
      $$WordMetadataTableCreateCompanionBuilder,
      $$WordMetadataTableUpdateCompanionBuilder,
      (WordMetadataData, $$WordMetadataTableReferences),
      WordMetadataData,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$WordLearningProgressTableCreateCompanionBuilder =
    WordLearningProgressCompanion Function({
      required String wordId,
      Value<String> learningStatus,
      Value<int> correctCount,
      Value<int> incorrectCount,
      Value<int?> lastReviewedAt,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$WordLearningProgressTableUpdateCompanionBuilder =
    WordLearningProgressCompanion Function({
      Value<String> wordId,
      Value<String> learningStatus,
      Value<int> correctCount,
      Value<int> incorrectCount,
      Value<int?> lastReviewedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$WordLearningProgressTableFilterComposer
    extends Composer<_$AppDatabase, $WordLearningProgressTable> {
  $$WordLearningProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningStatus => $composableBuilder(
    column: $table.learningStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordLearningProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $WordLearningProgressTable> {
  $$WordLearningProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningStatus => $composableBuilder(
    column: $table.learningStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordLearningProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordLearningProgressTable> {
  $$WordLearningProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get learningStatus => $composableBuilder(
    column: $table.learningStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WordLearningProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordLearningProgressTable,
          WordLearningProgressData,
          $$WordLearningProgressTableFilterComposer,
          $$WordLearningProgressTableOrderingComposer,
          $$WordLearningProgressTableAnnotationComposer,
          $$WordLearningProgressTableCreateCompanionBuilder,
          $$WordLearningProgressTableUpdateCompanionBuilder,
          (
            WordLearningProgressData,
            BaseReferences<
              _$AppDatabase,
              $WordLearningProgressTable,
              WordLearningProgressData
            >,
          ),
          WordLearningProgressData,
          PrefetchHooks Function()
        > {
  $$WordLearningProgressTableTableManager(
    _$AppDatabase db,
    $WordLearningProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WordLearningProgressTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$WordLearningProgressTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$WordLearningProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> wordId = const Value.absent(),
                Value<String> learningStatus = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> incorrectCount = const Value.absent(),
                Value<int?> lastReviewedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordLearningProgressCompanion(
                wordId: wordId,
                learningStatus: learningStatus,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                lastReviewedAt: lastReviewedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String wordId,
                Value<String> learningStatus = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> incorrectCount = const Value.absent(),
                Value<int?> lastReviewedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WordLearningProgressCompanion.insert(
                wordId: wordId,
                learningStatus: learningStatus,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                lastReviewedAt: lastReviewedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordLearningProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordLearningProgressTable,
      WordLearningProgressData,
      $$WordLearningProgressTableFilterComposer,
      $$WordLearningProgressTableOrderingComposer,
      $$WordLearningProgressTableAnnotationComposer,
      $$WordLearningProgressTableCreateCompanionBuilder,
      $$WordLearningProgressTableUpdateCompanionBuilder,
      (
        WordLearningProgressData,
        BaseReferences<
          _$AppDatabase,
          $WordLearningProgressTable,
          WordLearningProgressData
        >,
      ),
      WordLearningProgressData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$LanguagesTableTableManager get languages =>
      $$LanguagesTableTableManager(_db, _db.languages);
  $$WordMetadataTableTableManager get wordMetadata =>
      $$WordMetadataTableTableManager(_db, _db.wordMetadata);
  $$WordLearningProgressTableTableManager get wordLearningProgress =>
      $$WordLearningProgressTableTableManager(_db, _db.wordLearningProgress);
}
