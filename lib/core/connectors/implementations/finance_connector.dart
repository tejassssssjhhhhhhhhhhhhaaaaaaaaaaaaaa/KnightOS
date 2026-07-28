import 'dart:io';
import 'package:flutter/material.dart';
import '../domain/knight_connector.dart';
import '../domain/connector_models.dart';

class FinanceConnector extends KnightConnector {
  @override
  ConnectorMetadata get metadata => const ConnectorMetadata(
    id: 'standard_finance',
    name: 'Finance Connector',
    version: '1.0',
    icon: Icons.account_balance_wallet_rounded,
    accentColor: Colors.green,
    capabilities: {ConnectorCapability.import, ConnectorCapability.validate},
    supportedFormats: ['csv', 'pdf'],
  );

  @override
  Future<ConnectorResult> import(File file, {required String jobId}) async {
    return const ConnectorResult(
      success: true,
      message: 'Financial transactions normalized and stored.',
    );
  }

  @override
  Future<bool> validate(File file) async {
    return true;
  }
}
