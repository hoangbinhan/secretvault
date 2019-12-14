import UIKit

class BaseNavigationController: UINavigationController {

    // MARK: - Properties
    
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
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
    
    private func setupNavigationBar(){
        self.navigationBar.barStyle = .blackOpaque
        UINavigationBar.appearance().tintColor = Color.navTint
    }

}


// MARK: - Public methods
extension BaseNavigationController {
    
}


// MARK: - Private methods
extension BaseNavigationController {
    
}
