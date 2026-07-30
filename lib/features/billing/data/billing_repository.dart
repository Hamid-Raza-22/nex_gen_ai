import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/endpoints.dart';

final billingRepositoryProvider = Provider<BillingRepository>(
  (ref) => BillingRepository(ref.watch(dioProvider)),
);

final packagesProvider = FutureProvider<List<CreditPackage>>(
  (ref) => ref.watch(billingRepositoryProvider).getPackages(),
);

final transactionsProvider = FutureProvider<List<Transaction>>(
  (ref) => ref.watch(billingRepositoryProvider).getTransactions(),
);

class CreditPackage {
  const CreditPackage({
    required this.id,
    required this.name,
    required this.amount,
    this.description,
    this.numOfWords,
    this.numOfTokens,
  });

  final int id;
  final String name;
  final num amount;
  final String? description;
  final num? numOfWords;
  final num? numOfTokens;

  factory CreditPackage.fromJson(Map<String, dynamic> json) => CreditPackage(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ?? '',
        amount: json['amount'] as num? ?? 0,
        description: json['description'] as String?,
        numOfWords: json['num_of_words'] as num?,
        numOfTokens: json['num_of_tokens'] as num?,
      );
}

class Transaction {
  const Transaction({
    required this.id,
    required this.amount,
    this.packageName,
    this.status,
    this.createdAt,
  });

  final int id;
  final num amount;
  final String? packageName;
  final String? status;
  final DateTime? createdAt;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: (json['id'] as num?)?.toInt() ?? 0,
        amount: json['amount'] as num? ?? 0,
        packageName: json['package_name'] as String? ??
            (json['package'] as Map?)?['name'] as String?,
        status: json['status'] as String?,
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      );
}

class BillingRepository {
  const BillingRepository(this._dio);

  final Dio _dio;

  Future<List<CreditPackage>> getPackages() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(Endpoints.packages);
      final data = res.data?['data'] as List? ?? const [];
      return data
          .map((e) => CreditPackage.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<Transaction>> getTransactions() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(Endpoints.transactions);
      final data = res.data?['data'] as List? ?? const [];
      return data
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
