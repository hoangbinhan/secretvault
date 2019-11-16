import Foundation
import UIKit

class BaseTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
}

// MARK: - Public methods
extension BaseTabBarController {
    
}


// MARK: - Private methods
extension BaseTabBarController {
    
    private func setUpTabBar() {
        
    }
    
}
