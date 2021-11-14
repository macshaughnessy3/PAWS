//
//  CreateModeView.swift
//  PAWS
//
//  Created by macseansc3 on 11/10/21.
//

import Foundation
import SwiftUI

struct CreateModeSheet: View {
    @ObservedObject var viewModel = MainListViewModel()
    @State var number : Int = 0
    @State var displayColor: Color = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    @State var selectedPriority = 0

    var body: some View {
        List() {
            Section {
                TextField("Mode Name", text: $viewModel.newTaskTitle,
                 onCommit: {print("New task title entered.")})
            }
            
//            ColorPicker("test", selection: $displayColor, supportsOpacity: false)
            FinalView()
            
            Section {
                NavigationLink(destination: Text("Priority")) {
                    Text("Priority")
                    Spacer()
                    Text("Low")
                        .foregroundColor(.gray)
                }
            }
            DismissingView()
        }
    }
}

struct DismissingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = MainListViewModel()

    var body: some View {
        Button("Dismiss Me") {
            presentationMode.wrappedValue.dismiss()
            viewModel.addItem()
        }
    }
}

//struct CreateModeSheet: PreviewProvider {
//    static var previews: some View {
//        TaskDetailView()
//    }
//}
//internal protocol HSBColorPickerDelegate : NSObjectProtocol {
//    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizer.State)
//}
//
//@IBDesignable
//class HSBColorPicker : UIView {
//
//    weak internal var delegate: HSBColorPickerDelegate?
//    let saturationExponentTop:Float = 2.0
//    let saturationExponentBottom:Float = 1.3
//
//    @IBInspectable var elementSize: CGFloat = 1.0 {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
//
//
//    private func initialize() {
//
//        self.clipsToBounds = true
//        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
//        touchGesture.minimumPressDuration = 0
//        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
//        self.addGestureRecognizer(touchGesture)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initialize()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        initialize()
//    }
//
//    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
//
//        for y in stride(from: (0 as CGFloat), to: rect.height, by: elementSize) {
//
//            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
//            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
//            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
//
//            for x in stride(from: (0 as CGFloat), to: rect.width, by: elementSize) {
//                let hue = x / rect.width
//                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
//                context!.setFillColor(color.cgColor)
//                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
//            }
//        }
//    }
//
//    func getColorAtPoint(point:CGPoint) -> UIColor {
//        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
//                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
//        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
//            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
//        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
//        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
//        let hue = roundedPoint.x / self.bounds.width
//        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
//    }
//
//    func getPointForColor(color:UIColor) -> CGPoint {
//        var hue:CGFloat=0;
//        var saturation:CGFloat=0;
//        var brightness:CGFloat=0;
//        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
//
//        var yPos:CGFloat = 0
//        let halfHeight = (self.bounds.height / 2)
//
//        if (brightness >= 0.99) {
//            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
//            yPos = CGFloat(percentageY) * halfHeight
//        } else {
//            //use brightness to get Y
//            yPos = halfHeight + halfHeight * (1.0 - brightness)
//        }
//
//        let xPos = hue * self.bounds.width
//
//        return CGPoint(x: xPos, y: yPos)
//    }
//
//    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
//        let point = gestureRecognizer.location(in: self)
//        let color = getColorAtPoint(point: point)
//
//        self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
//    }
//}
