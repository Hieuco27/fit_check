import 'package:equatable/equatable.dart';

/// Entity đại diện cho model hệ thống (ảnh demo có sẵn)
class SystemModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String gender;   // 'female' | 'male'
  final String bodyType; // 'slim' | 'regular' | 'plus'

  const SystemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.gender,
    required this.bodyType,
  });

  /// Danh sách model demo mock — sẽ thay bằng API sau
  static const List<SystemModel> mockModels = [
    SystemModel(
      id: 'f1',
      name: 'Linh',
      imageUrl:
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&auto=format&fit=crop&q=80',
      gender: 'female',
      bodyType: 'slim',
    ),
    SystemModel(
      id: 'f2',
      name: 'Mai',
      imageUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&auto=format&fit=crop&q=80',
      gender: 'female',
      bodyType: 'regular',
    ),
    SystemModel(
      id: 'm1',
      name: 'Minh',
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80',
      gender: 'male',
      bodyType: 'regular',
    ),
  ];

  @override
  List<Object?> get props => [id, name, imageUrl, gender, bodyType];
}
