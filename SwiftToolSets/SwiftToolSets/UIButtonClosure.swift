import Foundation
import UIKit

public typealias UIButtonTargetClosure = ((UIButton) -> ())?

class UIButtonClosure: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: UIButtonTargetClosure) {
        self.closure = closure
    }
}

extension UIButton {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIButtonClosure else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIButtonClosure(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addTargetClosure(closure: UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(self.closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure?(self)
    }
}
