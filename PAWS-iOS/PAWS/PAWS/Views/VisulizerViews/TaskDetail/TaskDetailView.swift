//
//  TaskDetailView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 11/10/21.
//

import SwiftUI
import CoreBluetooth

struct TaskDetailView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    @ObservedObject var task : Mode
    
    @State var number : Int = 0
    var modeArray = ["Fast FFT", "Slow FFT", "Time", "Text", "Rainbow"]
    @State var rgbColour = RGB(r: 1, g: 1, b: 1)
    @State var brightness: CGFloat = 1
    @State var editingFlag = false
    @State private var selectedColor = 0
    

    var body: some View {
        List() {
            Section(header: Text("Rename mode:")) {
                TextField("Title", text: $task.title,
                 onCommit: {print("New task title entered.")})
            }
            Section(header: Text("Select visualizer display mode:")) {
                Picker(selection: $task.displayModeAsInt, label: Text("Select visualizer display mode")) {
                    ForEach(0 ..< modeArray.count) {
                        Text(self.modeArray[$0])
                    }.onChange(of: task.displayMode, perform: { _ in
                        task.displayMode = Int16(task.displayMode)
                    })
                }.pickerStyle(SegmentedPickerStyle())
            }
            if task.displayModeAsInt != 4 {
                Section(header: Text("Pick a Color to display:")) {
                    ColourWheel(radius: 300, rgbColour: $rgbColour, brightness: $brightness).foregroundColor(Color(.displayP3, red: 0, green: 0, blue: 0)).listRowBackground(Color(.displayP3, red: rgbColour.r, green: rgbColour.g, blue: rgbColour.b))
                }
                Button("Update Color"){
                    task.newModeColorR = rgbColour.r
                    task.newModeColorG = rgbColour.g
                    task.newModeColorB = rgbColour.b
                    task.color = "\(task.newModeColorR*255)_\(task.newModeColorG*255)_\(task.newModeColorB*255)"
                    if task.isSelected {
                        self.bleManager.connectedPeripheral.peripheral.writeValue(("\(task.color)_\(task.displayMode)_\(task.message)" as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics.first(where: { Characteristic in
                            return Characteristic.uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e"))
                        })!.characteristic, type: CBCharacteristicWriteType.withResponse)
                    }
                    self.editingFlag = true
                }
                .listRowBackground(Color(.systemGray4))
                .foregroundColor(Color(.displayP3, red: task.newModeColorR, green: task.newModeColorG, blue: task.newModeColorB))
            }
            if task.displayModeAsInt == 3 {
                if self.bleManager.isConnected {
                    Section(header: Text("Enter a message to Display:")) {
                        VStack {
                            if editingFlag {
                                Text("Sent: \(task.message)")
                            }
                            TextField("Your message", text: $task.message)
                        }
                        Button("Send") {
                            self.bleManager.connectedPeripheral.peripheral.writeValue(("\(task.color)_\(task.displayMode)_\(task.message)" as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics.first(where: { Characteristic in
                                return Characteristic.uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e"))
                            })!.characteristic, type: CBCharacteristicWriteType.withResponse)
                            self.editingFlag = true
                        }.foregroundColor(Color(.displayP3, red: task.newModeColorR, green: task.newModeColorG, blue: task.newModeColorB))
                    }
                }
            }
        }
        .navigationBarTitle("\(task.title)", displayMode: .inline)
    }
}

internal protocol HSBColorPickerDelegate : NSObjectProtocol {
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizer.State)
}

@IBDesignable
class HSBColorPicker : UIView {

    weak internal var delegate: HSBColorPickerDelegate?
    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3

    @IBInspectable var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }


    private func initialize() {

        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        for y in stride(from: (0 as CGFloat), to: rect.height, by: elementSize) {

            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height

            for x in stride(from: (0 as CGFloat), to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }

    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    func getPointForColor(color:UIColor) -> CGPoint {
        var hue:CGFloat=0;
        var saturation:CGFloat=0;
        var brightness:CGFloat=0;
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);

        var yPos:CGFloat = 0
        let halfHeight = (self.bounds.height / 2)

        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }

        let xPos = hue * self.bounds.width

        return CGPoint(x: xPos, y: yPos)
    }

    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)

        self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
    }
}
