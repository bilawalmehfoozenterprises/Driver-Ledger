import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'driver_ledger.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        parent_name TEXT,
        parent_phone TEXT,
        monthly_fee REAL NOT NULL,
        shift INTEGER NOT NULL,
        pickup_location TEXT,
        dropoff_location TEXT,
        join_date TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE monthly_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        expected_fee REAL NOT NULL,
        vacation_days INTEGER NOT NULL DEFAULT 0,
        deduction_amount REAL NOT NULL DEFAULT 0,
        total_paid REAL NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students(id),
        UNIQUE(student_id, month, year)
      )
    ''');
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      final tableInfo = await db.rawQuery('PRAGMA table_info(students)');
      final columns = tableInfo
          .map((column) => column['name'] as String)
          .toSet();

      final monthlyFeeColumn = columns.contains('monthly_fee')
          ? 'monthly_fee'
          : 'current_fee';
      final pickupLocationColumn = columns.contains('pickup_location')
          ? 'pickup_location'
          : 'NULL';
      final dropoffLocationColumn = columns.contains('dropoff_location')
          ? 'dropoff_location'
          : 'NULL';
      final joinDateColumn = columns.contains('join_date')
          ? 'join_date'
          : 'created_at';

      await db.execute('''
        CREATE TABLE students_v2 (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          parent_name TEXT,
          parent_phone TEXT,
          monthly_fee REAL NOT NULL,
          shift INTEGER NOT NULL,
          pickup_location TEXT,
          dropoff_location TEXT,
          join_date TEXT NOT NULL,
          is_active INTEGER NOT NULL DEFAULT 1,
          created_at TEXT NOT NULL
        )
      ''');
      await db.execute('''
        INSERT INTO students_v2
        SELECT id, name, parent_name, parent_phone, $monthlyFeeColumn, shift,
          $pickupLocationColumn, $dropoffLocationColumn, $joinDateColumn,
          is_active, created_at
        FROM students
      ''');
      await db.execute('DROP TABLE students');
      await db.execute('ALTER TABLE students_v2 RENAME TO students');
    }
  }
}
