import UIKit

class BaseTextField: UITextField {
    
    // MARK: - Properties
    
    
    
    // MARK: - Initializers
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }
    
    
    // MARK: - Setup button
    open func setupTextField() {
        
    }
    
    open func setupConstraint() {
        
    }
}


// MARK: - Public methods
extension BaseTextField {
    
}


// MARK: - Private methods
extension BaseTextField {
    
    private func setup() {
        self.setupTextField()
        self.setupConstraint()
    }
    
    private func updateFrame() {
        
    }
}

extension UITextField {
    
    func defaultSetup() {
        self.autocapitalizationType = .words
        self.autocorrectionType = .default
        self.keyboardType = .default
        self.keyboardAppearance = .dark
        self.returnKeyType = .done
        self.enablesReturnKeyAutomatically = true
    }
}
