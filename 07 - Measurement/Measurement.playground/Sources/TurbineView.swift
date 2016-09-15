import UIKit
import QuartzCore

public class TurbineView: UIView {
    
    fileprivate var stalkView = UIView()
    fileprivate var bladesImageView = UIImageView()
    
    public var bladeRotationPerSecond: Measurement<UnitAngle> = Measurement(value: 0, unit: UnitAngle.degrees) {
        didSet {
            rotate()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        drawTurbine()
        rotate()
    }
}

extension TurbineView {
    
    /// Draws the stick from the ground to the blades of the turbine
    fileprivate func drawTurbine() {

        // Position
        let stalkStart: CGFloat = 50
        let stalkWidth: CGFloat = 10
        
        /** Stalk **/
        stalkView.backgroundColor = .white
        addSubview(stalkView)
        stalkView.frame = CGRect(x: 80,
                                 y: stalkStart,
                                 width: stalkWidth,
                                 height: bounds.height - stalkStart)
        
        /** Blades **/
        bladesImageView.image = UIImage(named: "Blades")
        bladesImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.66)
        addSubview(bladesImageView)
        
        bladesImageView.frame = CGRect(x: 35,
                                       y: stalkStart - 60,
                                       width: 100,
                                       height: 100)
    }
}

extension TurbineView {
    fileprivate func rotate() {
        // Remove any existing animations
        bladesImageView.layer.removeAllAnimations()
        
        // Create new animation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = bladeRotationPerSecond.converted(to: .radians).value
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity
        
        bladesImageView.layer.add(rotationAnimation, forKey: "BladesRotationAnimation")
    }
}
