//
//  PreviewData.swift
//  Neighborly
//
//  Created by yulias on 03/07/2024.
//

import SwiftUI
import MapKit
import Contacts

struct PreviewData {
    
    static var park: MKMapItem {
        
        let coordinate = CLLocationCoordinate2D(
            latitude: 52.21484418546369,
            longitude: 21.03290482549105
        )
        
        let addressDictionary: [String: Any] = [
            CNPostalAddressStreetKey: "Agrykola 1",
            CNPostalAddressPostalCodeKey: "00-460",
            CNPostalAddressCityKey: "Warszawa",
            CNPostalAddressCountryKey: "Polska"
        ]
        
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Łazienki Królewskie"
        return mapItem
    }
}
