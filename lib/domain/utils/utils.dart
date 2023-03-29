// helper method to copy a list of assets
import '../concepts/asset.dart';
import '../concepts/loan.dart';

List<Asset> copyAssetArray(List<Asset> assetList) {
  List<Asset> copiedAssetList = [];
  for (Asset asset in assetList) {
    copiedAssetList.add(asset.copyWith());
  }
  return copiedAssetList;
}

// helper method to copy a list of loans
List<Loan> copyLoanArray(List<Loan> loanList) {
  List<Loan> copiedLoanList = [];
  for (Loan loan in loanList) {
    copiedLoanList.add(loan.copyWith());
  }
  return copiedLoanList;
}
