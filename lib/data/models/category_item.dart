class CategoryItem {
  final String slug;
  final String name;
  final String url;

  const CategoryItem({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      slug: (json['slug'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      url: (json['url'] as String?) ?? '',
    );
  }
}
