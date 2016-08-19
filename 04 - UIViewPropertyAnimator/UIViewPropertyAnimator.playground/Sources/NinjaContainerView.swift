import UIKit

public class NinjaContainerView: UIView {
    
    public let ninja: UIImageView = {
        let image = UIImage(named: "ninja")
        let view = UIImageView(image: image)
        view.frame = CGRect(x: 0, y: 0, width: 45, height: 39)
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Position ninja in the bottom left of the view
        ninja.center = {
            let x = (frame.minX + ninja.bounds.midX)
            let y = (frame.maxY - ninja.bounds.midY)
            return CGPoint(x: x, y: y)
        }()
        
        // Add image to the container
        addSubview(ninja)
        
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Moves the ninja view to the bottom right of its container, positioned just inside.
    public func moveNinjaToBottomRight() {
        ninja.center = {
            let x = (frame.maxX - ninja.bounds.midX)
            let y = (frame.maxY - ninja.bounds.midY)
            return CGPoint(x: x, y: y)
        }()
    }
}
