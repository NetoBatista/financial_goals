import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/transaction/data/interface/itransaction_service.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:financial_goals/src/modules/transaction/state/create_transaction_state.dart';
import 'package:flutter/material.dart';

class CreateTransactionController
    extends ValueNotifier<CreateTransactionState> {
  final ITransactionService _transactionService;

  CreateTransactionController(
    this._transactionService,
  ) : super(CreateTransactionInitialState());
  Future<DocumentFirestoreModel<TransactionModel>?> create(
      TransactionModel transaction) async {
    try {
      value = CreateTransactionLoadingState();
      var response = await _transactionService.create(transaction);
      value = CreateTransactionSuccessState();
      return response;
    } catch (error) {
      value =
          CreateTransactionErrorState('ocorreu um erro ao cadastrar a meta');
      return null;
    }
  }
}
