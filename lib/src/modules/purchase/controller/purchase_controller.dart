import 'dart:async';
import 'dart:convert';

import 'package:financial_goals/src/modules/auth/data/interface/iauth_service.dart';
import 'package:financial_goals/src/modules/purchase/interface/ipurchase_service.dart';
import 'package:financial_goals/src/modules/purchase/model/purchase_model.dart';
import 'package:financial_goals/src/modules/purchase/state/purchase_state.dart';
import 'package:financial_goals/src/modules/purchase/store/purchase_store.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseController extends ValueNotifier<PurchaseState> {
  final IPurchaseService _purchaseService;
  final IAuthService _authService;
  final PurchaseStore _purchaseStore;
  PurchaseController(
    this._purchaseService,
    this._authService,
    this._purchaseStore,
  ) : super(PurchaseInitialState());

  var ids = <String>{'premium'};
  final _inAppPurchase = InAppPurchase.instance;
  ProductDetails? productDetails;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<void> init() async {
    value = PurchaseLoadingState();

    if (_purchaseStore.purchase.value != null) {
      value = PurchasePremiumState();
      return;
    }

    var response = await _inAppPurchase.queryProductDetails(ids);

    if (response.productDetails.isNotEmpty) {
      productDetails = response.productDetails.first;
      value = PurchaseInitialState();
    } else {
      value = PurchaseErrorState('produto não encontrado');
    }

    _subscription = _inAppPurchase.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (Object error) {},
    );
  }

  void disposeSubscription() => _subscription?.cancel();

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    if (productDetails == null) {
      return;
    }
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        value = PurchaseLoadingState();
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.canceled) {
        value = PurchaseErrorState(
          'pagamento cancelado',
        );
        continue;
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        value = PurchaseErrorState(
          'erro ao realizar o pagamento',
        );
        continue;
      }

      if (purchaseDetails.status != PurchaseStatus.purchased) {
        value = PurchaseErrorState(
          'erro ao realizar o pagamento',
        );
        continue;
      }

      if (purchaseDetails.productID != productDetails!.id) {
        continue;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }

      value = PurchasePremiumState();

      var user = _authService.getCurrentCredential()!;

      var receipt = jsonEncode({
        'localVerificationData':
            purchaseDetails.verificationData.localVerificationData,
        'serverVerificationData':
            purchaseDetails.verificationData.serverVerificationData,
        'source': purchaseDetails.verificationData.source,
      });

      var purchaseModel = PurchaseModel(
        userId: user.uid,
        receipt: receipt,
      );

      var response = await _purchaseService.create(purchaseModel);
      _purchaseStore.purchase.set(response);
    }
  }

  Future<void> buyProduct() async {
    if (productDetails == null) {
      return;
    }

    var purchaseParam = PurchaseParam(productDetails: productDetails!);
    await _inAppPurchase.restorePurchases();
    await _inAppPurchase.buyConsumable(
      purchaseParam: purchaseParam,
    );
  }

  Future<bool> continueToPayment() async {
    var user = _authService.getCurrentCredential();
    if (user == null || user.isAnonymous) {
      await _authService.signInGoogle();
    }
    user = _authService.getCurrentCredential();
    return user != null && !user.isAnonymous;
  }
}
