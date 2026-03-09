class AudioModel {
  final String id;
  final String title;
  final String subtitle;
  final String url;
  final String imageUrl;

  AudioModel({
    required this.id,
    required this.title,
    required this.url,
    this.subtitle = 'تطبيق إسلامي',
    this.imageUrl = 'https://plus.unsplash.com/premium_vector-1724144958848-1461be6003fc?q=80&w=2360&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 
  });
}