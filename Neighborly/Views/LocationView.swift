//
//  LocationView.swift
//  Neighborly
//
//  Created by yulias on 03/07/2024.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    let mapItem: MKMapItem
    
    private var address: String {
        let placemark = mapItem.placemark
        let line1 =  "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")"
        let line2 = "\(placemark.postalCode ?? "" ) \(placemark.locality ?? ""), \(placemark.country ?? "" )"
        return "\(line1)\n\(line2)"
    }
    
    private var distance: Measurement<UnitLength>? {
        
        guard let userLocation = LocationManager.shared.manager.location,
              let destinationLocation = mapItem.placemark.location
        else {
            return nil
        }
        return calculateDistance(from: userLocation, to: destinationLocation)
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mapItem.name ?? "")
                        .font(.headline)
                    Text(address)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                
                if let distance {
                    Text(distance, formatter: MeasurementFormatter.distance)
                        .font(.callout)
                        .foregroundStyle(Color(red: 0/255, green: 103/255, blue: 79/255))
                }
            }
        }
        .background(Color(UIColor.systemBackground))
        
    }
}

#Preview {
    LocationView(mapItem: PreviewData.park)
}
