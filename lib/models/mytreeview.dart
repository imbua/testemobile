class MyTreeViewFields {
  static final List<String> values = [
    id, level, name, parent
  ];

  static const String id = 'id';
  static const String level = 'level';
  static const String name = 'name';
  static const String parent = 'parent';
}

class MyTreeView {
  final int id;
  final int level;
  final String name;
  final int? parent;
  List<MyTreeView> children;

  MyTreeView({
    required this.id,
    required this.level,
    required this.name,
    this.parent,
    List<MyTreeView>? children,
  }) : children = children ?? [];

  MyTreeView copyWith({
    int? id,
    int? level,
    String? name,
    int? parent,
    List<MyTreeView>? children,
  }) {
    return MyTreeView(
      id: id ?? this.id,
      level: level ?? this.level,
      name: name ?? this.name,
      parent: parent ?? this.parent,
      children: children ?? this.children,
    );
  }

  factory MyTreeView.fromJson(Map<String, dynamic> json) {
    return MyTreeView(
      id: json[MyTreeViewFields.id] as int,
      level: json[MyTreeViewFields.level] as int,
      name: json[MyTreeViewFields.name] as String,
      parent: json[MyTreeViewFields.parent] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      MyTreeViewFields.id: id,
      MyTreeViewFields.level: level,
      MyTreeViewFields.name: name,
      MyTreeViewFields.parent: parent,
    };
  }

  static List<MyTreeView> fromJsonList(List<dynamic> jsonList) {
    List<MyTreeView> list =
        jsonList.map((json) => MyTreeView.fromJson(json)).toList();
    return _buildTree(list);
  }

  static List<MyTreeView> _buildTree(List<MyTreeView> list) {
    Map<int, MyTreeView> map = {for (var item in list) item.id: item};
    List<MyTreeView> rootNodes = [];

    for (var item in list) {
      if (item.parent == null) {
        rootNodes.add(item);
      } else {
        if (map.containsKey(item.parent!)) {
          map[item.parent!]!.children.add(item);
        }
      }
    }
    return rootNodes;
  }
}
