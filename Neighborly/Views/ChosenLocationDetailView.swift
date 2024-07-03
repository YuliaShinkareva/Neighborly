//
//  ChosenLocationDetailView.swift
//  Neighborly
//
//  Created by yulias on 03/07/2024.
//

import SwiftUI
import MapKit

struct ChosenLocationDetailView: View {
    
    @Binding var mapItem: MKMapItem?
    
    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                if let mapItem {
                    LocationView(mapItem: mapItem)
                }
            }
            Image(systemName: "xmark.circle.fill")
                .padding([.trailing], 10)
                .onTapGesture {
                    mapItem = nil
                }
        }
        .padding()
    }
}

#Preview {
    let park = Binding<MKMapItem?>(
        get: { PreviewData.park },
        set: { _ in }
    )
    return ChosenLocationDetailView(mapItem: park)
}
