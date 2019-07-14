import Foundation
import UIKit
import CarPlay

class CustomNavigationViewController: UIViewController {
    var mainView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Just an example of showing your own views in the VC that you are setting as root on the CPMapContentWindow
        if mainView == nil {
            mainView = Bundle.main.loadNibNamed("CarplayView", owner: self, options: nil)?.first as? UIView
            mainView?.frame = view.bounds
            if let mainViewUnwrapped = mainView {self.view.addSubview(mainViewUnwrapped)}
        }
    }
    
    
}
