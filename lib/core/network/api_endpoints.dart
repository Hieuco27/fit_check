class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://kltn-2025-ehsx.onrender.com/api';

  // Auth
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authRefreshToken = '/auth/refresh-token';

  // Profile
  static const String userProfile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String changePassword = '/profile/change-password';

  // Wardrobe
  static const String wardrobeItems = '/wardrobe/items';
  static const String uploadImage = '/wardrobe/upload-image';

  // Outfit generation
  static const String generateOutfit = '/outfit/generate';

  // Fit check
  static const String fitCheck = '/fit-check';
  static const String createFitCheck = '/fit-check/create';
}
