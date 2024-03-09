import 'package:financial_goals/src/model/document_firestore_model.dart';
import 'package:financial_goals/src/modules/transaction/data/interface/itransaction_service.dart';
import 'package:financial_goals/src/modules/transaction/model/transaction_model.dart';
import 'package:financial_goals/src/modules/transaction/state/update_transaction_state.dart';
import 'package:flutter/material.dart';

class UpdateTransactionController
    extends ValueNotifier<UpdateTransactionState> {
  final ITransactionService _transactionService;

  UpdateTransactionController(
    this._transactionService,
  ) : super(UpdateTransactionInitialState());

  Future<DocumentFirestoreModel<TransactionModel>?> update(
    DocumentFirestoreModel<TransactionModel> transaction,
  ) async {
    try {
      value = UpdateTransactionLoadingState();
      await _transactionService.update(transaction);
      value = UpdateTransactionSuccessState();
      return transaction;
    } catch (error) {
      value = UpdateTransactionErrorState(
        'ocorreu um erro ao atualizar a meta',
      );
      return null;
    }
  }

  Future<bool> delete(
    DocumentFirestoreModel<TransactionModel> transaction,
  ) async {
    try {
      value = UpdateTransactionLoadingState();
      await _transactionService.delete(transaction);
      value = UpdateTransactionSuccessState();
      return true;
    } catch (error) {
      value = UpdateTransactionErrorState('ocorreu um erro ao deletar a meta');
      return false;
    }
  }
}
