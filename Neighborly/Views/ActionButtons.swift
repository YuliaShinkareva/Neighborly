//
//  ActionButtons.swift
//  Neighborly
//
//  Created by yulias on 03/07/2024.
//

import SwiftUI
import MapKit

struct ActionButtons: View {
    
    let mapItem: MKMapItem
    
    var body: some View {
        
        HStack (spacing: 16) {
            if let phone = mapItem.phoneNumber {
                Button {
                    let numbericPhoneNumber = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                    makeCall(phone: numbericPhoneNumber)
                } label: {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Call")
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.systemBlue))
                
                Button {
                    MKMapItem.openMaps(with: [mapItem])
                } label: {
                    HStack {
                        Image(systemName: "car.circle.fill")
                        Text("Show Route")
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.systemMint))
                
                Spacer()
                
            }
        }
    }
}

#Preview {
    ActionButtons(mapItem: PreviewData.park)
}
