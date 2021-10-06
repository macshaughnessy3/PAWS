//
//  VisulizerView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI
import CocoaMQTT
let mqttClient = CocoaMQTT(clientID: "App", host: "172.22.37.4", port: 1883)


struct VisulizerView: View {
    struct SelectableItem: Identifiable {
        let id = UUID().uuidString
        var name: String
    }
    
    var body: some View {
        NavigationView{
            Form{
            Button("Connect"){
                print("yo")
                _ = mqttClient.connect()
            }
            Button("Mode 1")
                {
                    print("9dl")
                    mqttClient.publish("raspberrypi/mode", withString: "mode1")
                }
            Button("Mode 2")
                {
                    print("9dl")
                    mqttClient.publish("raspberrypi/mode", withString: "mode2")
                }
            Button("Mode 3")
                {
                    print("9dl")
                    mqttClient.publish("raspberrypi/mode", withString: "mode3")
                }
            Button("Mode 4")
                {
                    print("9dl")
                    mqttClient.publish("raspberrypi/mode", withString: "mode3")
                }
            Button("Mode 5")
                {
                    print("9dl")
                    mqttClient.publish("raspberrypi/mode", withString: "mode4")
                }
            }
            .navigationBarTitle(Text("My Visuals"))
            .navigationBarItems(leading:ClemsonLogoView())

        }
    }
}

