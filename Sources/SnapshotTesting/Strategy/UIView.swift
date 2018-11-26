#if os(iOS) || os(tvOS)
import UIKit

extension Strategy where Snapshottable == UIView, Format == UIImage {
  public static var image: Strategy {
    return .image()
  }

  public static func image(
    drawingHierarchyInKeyWindow: Bool = false,
    precision: Float = 1,
    size: CGSize? = nil,
    traits: UITraitCollection = .init()
    )
    -> Strategy {

      return SimpleStrategy.image(precision: precision).asyncPullback { view in
        snapshotView(
          config: .init(safeArea: .zero, size: size ?? view.frame.size, traits: .unspecified),
          traits: traits,
          view: view,
          viewController: .init()
        )
      }
  }
}

extension Strategy where Snapshottable == UIView, Format == String {
  public static var recursiveDescription: Strategy<UIView, String> {
    return SimpleStrategy.lines.pullback { view in
      view.setNeedsLayout()
      view.layoutIfNeeded()
      return purgePointers(
        view.perform(Selector(("recursiveDescription"))).retain().takeUnretainedValue()
          as! String
      )
    }
  }
}

extension UIView: DefaultSnapshottable {
  public static let defaultStrategy: Strategy<UIView, UIImage> = .image
}
#endif
