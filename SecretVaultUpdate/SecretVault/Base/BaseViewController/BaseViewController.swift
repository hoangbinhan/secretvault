import UIKit

class BaseViewController: UIViewController {

    // MARK: - Properties
    var lastTimeDataFetched: Date?

    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Setup views
    open func setupViews() {
        
    }
    
    open func setupConstraints() {
        
    }
    
    open func setupData() {
        
    }
    
    open func onRefreshData() {
        
    }
    
    @objc private func willEnterForeground() {

    }

}

// MARK: - Public methods
extension BaseViewController {
    
}


// MARK: - Private methods
extension BaseViewController {
    
}
