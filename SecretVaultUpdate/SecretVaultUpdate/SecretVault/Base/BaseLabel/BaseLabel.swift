import UIKit

class BaseLabel: UILabel {
    
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
    
    
    // MARK: - Setup label
    open func setupLabel() {
        
    }
    
    open func setupConstraint() {
        
    }
}


// MARK: - Public methods
extension BaseLabel {
    
}


// MARK: - Private methods
extension BaseLabel {
    
    private func setup() {
        self.setupLabel()
        self.setupConstraint()
    }
    
    private func updateFrame() {
        
    }
}

