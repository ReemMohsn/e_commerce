abstract final class ApiEndPoints {
  static const String serverUrl = 'https://supermarket-dan1.onrender.com/';
  static const String baseUrl = '${serverUrl}api/v1/';

  static const String signUp = 'auth/signUp';
  static const String signIn = 'auth/signIn';
  static const String requestResetCode = 'auth/resetPassCode';
  static const String activatePasswordReset = 'auth/activeResetPass';
  static const String resetPassword = 'auth/resetPassword';

  static const String homeCategories = 'home/categories';
  static const String homeProducts = 'home/products';
  static const String homeBrands = 'home/brand';
  static const String productsFilter = 'home/productsFilter';

  static String productDetails(int productId) => '$homeProducts/$productId';

  static const String profile = 'portfoilo/userData';
  static const String editProfile = 'portfoilo/editUserData';
}
