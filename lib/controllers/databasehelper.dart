import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:testemobile/models/mytreeview.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mytreeview.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE mytreeview ( 
      ${MyTreeViewFields.id} $idType, 
      ${MyTreeViewFields.level} $intType,
      ${MyTreeViewFields.name} $textType,
      ${MyTreeViewFields.parent} $intType
    )
    ''');
  }

  Future<MyTreeView> create(MyTreeView node) async {
    final db = await instance.database;
    final id = await db.insert('mytreeview', node.toJson());
    return node.copyWith(id: id);
  }

  Future<MyTreeView?> readNode(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'mytreeview',
      columns: MyTreeViewFields.values,
      where: '${MyTreeViewFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MyTreeView.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<MyTreeView>> readAllNodes() async {
    final db = await instance.database;

    final result = await db.query('mytreeview');

    return result.map((json) => MyTreeView.fromJson(json)).toList();
  }

  Future<int> update(MyTreeView node) async {
    final db = await instance.database;

    return db.update(
      'mytreeview',
      node.toJson(),
      where: '${MyTreeViewFields.id} = ?',
      whereArgs: [node.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'mytreeview',
      where: '${MyTreeViewFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<void> deleteAllTreeNodes() async {
    final db = await database;
    await db.delete('mytreeview');
  }

  Future<void> insertTreeNode(MyTreeView node) async {
    final db = await database;
    await db.insert(
      'mytreeview',
      node.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTreeNodes(List<MyTreeView> nodes) async {
    final db = await database;
    Batch batch = db.batch();
    for (var node in nodes) {
      batch.insert(
        'mytreeview',
        node.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }
}
