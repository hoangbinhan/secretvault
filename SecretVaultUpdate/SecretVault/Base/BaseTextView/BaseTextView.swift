import UIKit

class BaseTextView: UITextView {
    
    // MARK: - Properties
    
    
    
    // MARK: - Initializers
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero, textContainer: nil)
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }
    
    
    // MARK: - Setup button
    open func setupTextView() {
        
    }
    
    open func setupConstraint() {
        
    }
}


// MARK: - Public methods
extension BaseTextView {
    
}


// MARK: - Private methods
extension BaseTextView {
    
    private func setup() {
        self.setupTextView()
        self.setupConstraint()
    }
    
    private func updateFrame() {
        
    }
}

