class RecentTry {
  final String title;
  final String timeAgo;
  final String imageUrl;
  final bool isAiGenerated;

  const RecentTry({
    required this.title,
    required this.timeAgo,
    required this.imageUrl,
    this.isAiGenerated = true,
  });
}
