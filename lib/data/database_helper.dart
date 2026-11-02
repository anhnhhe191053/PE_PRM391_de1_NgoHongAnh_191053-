import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('task_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            is_completed INTEGER NOT NULL
          )
        ''');

        // Khởi tạo sẵn dữ liệu mẫu đúng đề bài
        await db.insert('tasks', {
          'title': 'Làm bài tập Flutter',
          'description': 'Hoàn thành trước thứ Sáu',
          'is_completed': 0,
        });
        await db.insert('tasks', {
          'title': 'Ôn tập Riverpod',
          'description': 'Xem lại bài giảng MVVM',
          'is_completed': 0,
        });
        await db.insert('tasks', {
          'title': 'Chuẩn bị bài thuyết trình',
          'description': 'Nhóm 4 - Chủ đề Firebase',
          'is_completed': 0,
        });
        await db.insert('tasks', {
          'title': 'Viết báo cáo môn học',
          'description': 'Nộp trên LMS',
          'is_completed': 0,
        });
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query('tasks');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}