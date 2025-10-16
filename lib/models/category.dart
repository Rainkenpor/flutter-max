class Category {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final List<Category>? subcategories;
  final int? depth;
  final String? parentId;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.subcategories,
    this.depth,
    this.parentId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] ?? json['categoryId'] ?? '').toString(),
      name: json['title'] ?? json['name'] ?? json['categoryName'] ?? '',
      description: json['description'],
      image:  (json['icon'] ?? json['image'] ?? json['imageUrl']),
      subcategories: json['children'] != null
          ? (json['children'] as List)
              .map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList()
          : (json['subcategories'] != null
              ? (json['subcategories'] as List)
                  .map((e) => Category.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null),
      depth: json['depth'] ?? json['level'],
      parentId: (json['parentId'] ?? json['parentCategoryId'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'subcategories': subcategories?.map((e) => e.toJson()).toList(),
      'depth': depth,
      'parentId': parentId,
    };
  }

  bool get hasSubcategories => 
      subcategories != null && subcategories!.isNotEmpty;
}
