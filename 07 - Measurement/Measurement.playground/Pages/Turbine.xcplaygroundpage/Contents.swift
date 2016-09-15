//: [Previous](@previous)

import UIKit
import PlaygroundSupport

class TurbineViewController: UIViewController {
    
    let turbine = TurbineView()
    let windSpeedSlider = UISlider(frame: CGRect(x: 50, y: 100, width: 150, height: 40))
    let windSpeedLabel = UILabel(frame: CGRect(x: 50, y: 150, width: 300, height: 30))
    let powerGeneratedLabel = UILabel(frame: CGRect(x: 50, y: 200, width: 300, height: 30))
    
    override func viewDidLoad() {
        // Add our turbine view
        view.addSubview(turbine)
        addTurbineConstraints()
        
        // Configure the wind speed slider
        windSpeedSlider.minimumValue = 0
        windSpeedSlider.maximumValue = 20
        windSpeedSlider.value = 10
        
        windSpeedSlider.addTarget(self, action: #selector(handleWindSpeedChange), for: .valueChanged)
        view.addSubview(windSpeedSlider)
        
        // Add labels
        view.addSubview(windSpeedLabel)
        view.addSubview(powerGeneratedLabel)
        
        // Initial display
        handleWindSpeedChange(slider: windSpeedSlider)
    }
    
    private func addTurbineConstraints() {
        //: Set up our constraints
        turbine.translatesAutoresizingMaskIntoConstraints = false
        turbine.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
        turbine.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor).isActive = true
        turbine.heightAnchor.constraint(equalTo: controller.view.heightAnchor, multiplier: 0.5).isActive = true
        turbine.widthAnchor.constraint(equalTo: controller.view.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    /// Responds to changes in value slider
    func handleWindSpeedChange(slider: UISlider) {
        let windSpeed = Measurement(value: Double(slider.value), unit: UnitSpeed.metersPerSecond)
        
        let measurementFormatter: MeasurementFormatter = {
            let formatter = MeasurementFormatter()
            formatter.unitOptions = .providedUnit
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumIntegerDigits = 1
            numberFormatter.minimumFractionDigits = 1
            numberFormatter.maximumFractionDigits = 1
            formatter.numberFormatter = numberFormatter
            
            return formatter
        }()
        
        let metersPerSecond = measurementFormatter.string(from: windSpeed)
        let milesPerHour = measurementFormatter.string(from: windSpeed.converted(to: .milesPerHour))
        
        windSpeedLabel.text = "Wind speed: \(metersPerSecond) (\(milesPerHour))"
        
        calculateTurbineRotation()
    }
    
    func calculateTurbineRotation() {
        // If we assume max value of slider = 1 rotation per second
        let ratio = windSpeedSlider.value / windSpeedSlider.maximumValue
        
        let fullRotation = Measurement(value: 360, unit: UnitAngle.degrees)
        
        let rotationAnglePerSecond = fullRotation * Double(ratio)
        
        turbine.bladeRotationPerSecond = rotationAnglePerSecond
    }
}


//: Let's set up our view controller which we'll add our components to
let controller = TurbineViewController()
controller.view.bounds = CGRect(x: 0, y: 0, width: 300, height: 400)
controller.view.backgroundColor = UIColor(red:0.53, green:0.80, blue:0.92, alpha:1.00)

//: Display controller in the Assistant view
PlaygroundPage.current.liveView = controller

//: [Next](@next)
