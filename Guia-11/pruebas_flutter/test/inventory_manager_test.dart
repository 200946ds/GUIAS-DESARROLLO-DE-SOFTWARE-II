import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:pruebas_flutter/models/product.dart';
import 'package:pruebas_flutter/services/stock_api_service.dart';
import 'package:pruebas_flutter/services/location_service.dart';
import 'package:pruebas_flutter/services/coupon_repository.dart';
import 'package:pruebas_flutter/inventory/inventory_manager.dart';

class MockStockApiService extends Mock implements StockApiService {}
class MockLocationService extends Mock implements LocationService {}
class MockCouponRepository extends Mock implements CouponRepository {}

void main() {
  late InventoryManager manager;
  late MockStockApiService mockStock;
  late MockLocationService mockLocation;
  late MockCouponRepository mockCoupon;

  final product = const Product(id: 'p1', name: 'Laptop', price: 1000.0);

  setUp(() {
    mockStock = MockStockApiService();
    mockLocation = MockLocationService();
    mockCoupon = MockCouponRepository();

    manager = InventoryManager(
      stockApi: mockStock,
      locationService: mockLocation,
      couponRepository: mockCoupon,
    );
  });

  group('InventoryManager - addProduct', () {
    test('debe agregar producto cuando hay stock suficiente', () async {
      when(() => mockStock.getAvailableStock('p1'))
          .thenAnswer((_) async => 10);

      await manager.addProduct(product, 3);

      expect(manager.cart.length, 1);
      expect(manager.cart.first.quantity, 3);
      verify(() => mockStock.getAvailableStock('p1')).called(1);
    });

    test('debe lanzar InsufficientStockException si no hay stock', () async {
      when(() => mockStock.getAvailableStock('p1'))
          .thenAnswer((_) async => 2);

      expect(
        () => manager.addProduct(product, 5),
        throwsA(isA<InsufficientStockException>()),
      );
    });

    test('debe lanzar ArgumentError si cantidad <= 0', () async {
      expect(
        () => manager.addProduct(product, 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('debe acumular cantidad si el producto ya está en el carrito', () async {
      when(() => mockStock.getAvailableStock('p1'))
          .thenAnswer((_) async => 20);

      await manager.addProduct(product, 2);
      await manager.addProduct(product, 3);

      expect(manager.cart.length, 1);
      expect(manager.cart.first.quantity, 5);
    });
  });

  group('InventoryManager - calculateTotal', () {
    test('debe calcular total con impuesto de Perú (18%)', () async {
      when(() => mockStock.getAvailableStock('p1'))
          .thenAnswer((_) async => 10);
      when(() => mockLocation.getRegion()).thenAnswer((_) async => 'PE');

      await manager.addProduct(product, 1); // 1000
      final total = await manager.calculateTotal();

      // 1000 * 1.18 = 1180
      expect(total, 1180.0);
    });

    test('debe calcular total con impuesto de US (8%)', () async {
      when(() => mockStock.getAvailableStock('p1'))
          .thenAnswer((_) async => 10);
      when(() => mockLocation.getRegion()).thenAnswer((_) async => 'US');

      await manager.addProduct(product, 1);
      final total = await manager.calculateTotal();

      expect(total, 1080.0);
    });

    test('debe aplicar descuento de cupón válido', () async {
      when(() => mockStock.getAvailableStock('p1'))
          .thenAnswer((_) async => 10);
      when(() => mockLocation.getRegion()).thenAnswer((_) async => 'PE');
      when(() => mockCoupon.isCouponValid('DESC10'))
          .thenAnswer((_) async => true);
      when(() => mockCoupon.getDiscountPercentage('DESC10'))
          .thenAnswer((_) async => 0.10);

      await manager.addProduct(product, 1);
      final total = await manager.calculateTotal(couponCode: 'DESC10');

      // 1000 * 1.18 = 1180 → 10% descuento → 1062
      expect(total, 1062.0);
    });

    test('debe lanzar ArgumentError si el cupón es inválido', () async {
      when(() => mockStock.getAvailableStock('p1'))
          .thenAnswer((_) async => 10);
      when(() => mockLocation.getRegion()).thenAnswer((_) async => 'PE');
      when(() => mockCoupon.isCouponValid('VENCIDO'))
          .thenAnswer((_) async => false);

      await manager.addProduct(product, 1);

      expect(
        () => manager.calculateTotal(couponCode: 'VENCIDO'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('debe retornar 0 si el carrito está vacío', () async {
      final total = await manager.calculateTotal();
      expect(total, 0.0);
    });
  });
}