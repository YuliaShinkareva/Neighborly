//
//  PlaceListView.swift
//  Neighborly
//
//  Created by yulias on 03/07/2024.
//

import SwiftUI
import MapKit

struct PlaceListView: View {
    
    let mapItems: [MKMapItem]
    @Binding var chosenLocation: MKMapItem?
    
    private var sortedItems: [MKMapItem] {
        
        guard let userLocation = LocationManager.shared.manager.location else {
            return mapItems
        }
        
        return mapItems.sorted { lhs, rhs in
           guard let lhsLocation = lhs.placemark.location,
                 let rhsLocation = rhs.placemark.location else {
               return false
           }
            
            let lhsDistance = userLocation.distance(from: lhsLocation)
            let rhsDistance = userLocation.distance(from: rhsLocation)
            
            return lhsDistance < rhsDistance
        }
    }
    
    var body: some View {
        
        List(sortedItems, id: \.self, selection: $chosenLocation) { mapItem in
            LocationView(mapItem: mapItem)
        }
    }
}

#Preview {
    
    let park = Binding<MKMapItem?>(
        get: { PreviewData.park },
        set: { _ in }
    )
    return PlaceListView(mapItems: [PreviewData.park], chosenLocation: park)
}
