/// REST endpoints for the NexgenAI backend (Laravel API).
/// Extracted from the production web client at brainvoai.com.
abstract final class Endpoints {
  static const baseUrl = 'https://api.brainvoai.com/api/';

  // Auth
  static const login = 'login';
  static const register = 'register';
  static const logout = 'logout';
  static const forgotPassword = 'forgot-password';
  static const resetPassword = 'reset-password';
  static const updatePassword = 'password';
  static const resendVerification = 'email/verification-notification';

  // User
  static const user = 'user';
  static const updateUser = 'update-user';
  static const transactions = 'user/transactions';

  // Website / billing
  static const packages = 'packages';
  static const settings = 'settings';
  static const blogs = 'blogs';
  static String blog(int id) => 'blog/$id';
  static String createPaymentIntent(int packageId) =>
      'createPaymentIntent?package_id=$packageId';

  // Media & interior design (Replicate-style prediction polling)
  static const medias = 'medias';
  static String media(int id) => 'medias/$id';
  static const createInteriorPrediction = 'create-interior-prediction';
  static String getPrediction(String id) => 'get-prediction/$id';
}
