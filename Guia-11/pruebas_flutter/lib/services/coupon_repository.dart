abstract class CouponRepository {
  Future<bool> isCouponValid(String code);
  Future<double> getDiscountPercentage(String code); // 0.0 - 1.0
}