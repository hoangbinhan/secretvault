import UIKit

class BaseView: UIView {
    
    // MARK: - Properties
    private var view: UIView!
    
    
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
    
    
    // MARK: - Setup view
    open func setupView() {
        
    }
    
    open func setupConstraint() {
        
    }
}


// MARK: - Public methods
extension BaseView {
    
}


// MARK: - Private methods
extension BaseView {
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        guard bundle.path(forResource: nibName, ofType: "nib") != nil else {
            return nil
        }
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func setup() {
        if let v = self.loadViewFromNib() {
            view = v
            view.frame = bounds
            addSubview(view)
        }
        
        self.setupView()
        self.setupConstraint()
    }
    
    private func updateFrame() {
        
    }
    
}
