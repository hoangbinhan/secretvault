import UIKit
import Kingfisher

class BaseImageView: UIImageView {
    
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
    open func setupButton() {
        
    }
    
    open func setupConstraint() {
        
    }
    
}


// MARK: - Public methods
extension BaseImageView {
    
    public func setImage(with url: URL?, placeholder: UIImage? = nil) {
        self.kf.setImage(with: url, placeholder: placeholder)
    }
    
}


// MARK: - Private methods
extension BaseImageView {
    
    private func setup() {
        self.setupButton()
        self.setupConstraint()
    }
    
    private func updateFrame() {
        
    }
    
}
