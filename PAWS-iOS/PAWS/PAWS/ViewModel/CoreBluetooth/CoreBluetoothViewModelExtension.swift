//
//  CoreBluetoothViewModelExtension.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 11/03/21.
//

import SwiftUI
import CoreBluetooth

extension CoreBluetoothViewModel {
    func navigationToDetailView(isDetailViewLinkActive: Binding<Bool>) -> some View {
        let navigationToDetailView = NavigationLink("", destination: DetailView(), isActive: isDetailViewLinkActive).frame(width: 0, height: 0)
        return navigationToDetailView
    }
}

extension CoreBluetoothViewModel {
    func UIButtonView(proxy: GeometryProxy, text: String) -> some View {
        let UIButtonView =
            VStack {
                Text(text)
                    .frame(width: proxy.size.width / 1.1, height: 50, alignment: .center)
                    .foregroundColor(Color.blue)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
            }
        return UIButtonView
    }
}
