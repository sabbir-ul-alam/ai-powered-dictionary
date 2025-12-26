import 'package:drift/drift.dart';

class Languages extends Table {
  TextColumn get code => text()();

  TextColumn get displayName =>
      text().named('display_name')();

  IntColumn get createdAt =>
      integer().named('created_at')();

  @override
  Set<Column> get primaryKey => {code};
}
