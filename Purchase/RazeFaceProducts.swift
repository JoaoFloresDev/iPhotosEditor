import Foundation

public struct RazeFaceProducts {
  
  public static let SwiftShopping = "NoAds.iPhotos"
  
  private static let productIdentifiers: Set<ProductIdentifier> = [RazeFaceProducts.SwiftShopping]

  public static let store = IAPHelper(productIds: RazeFaceProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
