import '../models/product.dart';
import '../services/stock_api_service.dart';
import '../services/location_service.dart';
import '../services/coupon_repository.dart';

class InsufficientStockException implements Exception {
  final String message;
  InsufficientStockException(this.message);

  @override
  String toString() => message;
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class InventoryManager {
  final StockApiService stockApi;
  final LocationService locationService;
  final CouponRepository couponRepository;

  final List<CartItem> _cart = [];

  InventoryManager({
    required this.stockApi,
    required this.locationService,
    required this.couponRepository,
  });

  List<CartItem> get cart => List.unmodifiable(_cart);

  Future<void> addProduct(Product product, int quantity) async {
    if (quantity <= 0) {
      throw ArgumentError('La cantidad debe ser mayor a 0');
    }

    final available = await stockApi.getAvailableStock(product.id);
    final alreadyInCart = _cart
        .where((item) => item.product.id == product.id)
        .fold(0, (sum, item) => sum + item.quantity);

    if (alreadyInCart + quantity > available) {
      throw InsufficientStockException(
        'Stock insuficiente. Disponible: $available, solicitado: ${alreadyInCart + quantity}',
      );
    }

    final existing = _cart.where((item) => item.product.id == product.id);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _cart.add(CartItem(product: product, quantity: quantity));
    }
  }

  Future<double> calculateTotal({String? couponCode}) async {
    if (_cart.isEmpty) return 0.0;

    double subtotal = _cart.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    // Impuesto según región
    final region = await locationService.getRegion();
    final taxRate = switch (region) {
      'PE' => 0.18, // IGV
      'US' => 0.08,
      'EU' => 0.21,
      _ => 0.10,
    };

    double total = subtotal * (1 + taxRate);

    // Cupón
    if (couponCode != null && couponCode.isNotEmpty) {
      final isValid = await couponRepository.isCouponValid(couponCode);
      if (!isValid) {
        throw ArgumentError('Cupón inválido o vencido');
      }
      final discount = await couponRepository.getDiscountPercentage(couponCode);
      total = total * (1 - discount);
    }

    return double.parse(total.toStringAsFixed(2));
  }

  void clearCart() => _cart.clear();
}