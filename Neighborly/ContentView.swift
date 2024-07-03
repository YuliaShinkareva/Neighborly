//
//  ContentView.swift
//  Neighborly
//
//  Created by yulias on 02/07/2024.
//

import SwiftUI
import MapKit

enum ScreenMode {
    
    case list
    case detail
}

struct ContentView: View {
    
    @State private var query: String = ""
    @State private var selectedDetent: PresentationDetent = .fraction(0.15)
    @State private var locationManager = LocationManager.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isSearching: Bool = false
    @State private var mapItems: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var chosenLocation: MKMapItem?
    @State private var screenMode: ScreenMode = .list
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var route: MKRoute?
    
    private func search() async {
        
        do {
            mapItems = try await performSearch(searchTerm: query, visibleRegion: visibleRegion)
            isSearching = false
        } catch {
            mapItems = []
            print(error.localizedDescription)
            isSearching = false
        }
    }
    
    private func requestCalculateDirections() async {
        
        route = nil
        
        if let chosenLocation {
            guard let currentUserLocation = locationManager.manager.location else { return }
            let startingMapItem = MKMapItem(placemark: MKPlacemark(coordinate: currentUserLocation.coordinate))
            
            self.route = await calculateDirections(from: startingMapItem, to: chosenLocation)
        }
    }
    
    var body: some View {
        
        ZStack {
            Map(position: $position, selection: $chosenLocation) {
                ForEach(mapItems, id: \.self) { mapItem in
                    Marker(item: mapItem)
                }
                
                if let route {
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 5)
                }
                
                UserAnnotation()
            }
            .mapControls{
                MapUserLocationButton()
            }
            .onChange(of: locationManager.region, {
                position = .region(locationManager.region)
            })
            .sheet(isPresented: .constant(true), content: {
                VStack {
                    switch screenMode {
                    case .list:
                        SearchInputView(search: $query, isSearching: $isSearching)
                        PlaceListView(mapItems: mapItems, chosenLocation: $chosenLocation)
                    case .detail:
                        ChosenLocationDetailView(mapItem: $chosenLocation)
                        
                        if selectedDetent == .medium || selectedDetent == .large {
                            if let chosenLocation {
                                ActionButtons(mapItem: chosenLocation)
                                    .padding()
                            }
                            LookAroundPreview(initialScene: lookAroundScene)
                        }
                    }
                    Spacer()
                }
                .presentationDetents([.fraction(0.15), .medium, .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            })
        }
        .onChange(of: chosenLocation, {
            if chosenLocation != nil {
                screenMode = .detail
            } else {
                screenMode = .list
            }
        })
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .task(id: chosenLocation) {
            lookAroundScene = nil
            if let chosenLocation {
                let request = MKLookAroundSceneRequest(mapItem: chosenLocation)
                lookAroundScene = try? await request.scene
                await requestCalculateDirections()
            }
        }
        .task(id: isSearching, {
            if isSearching {
                await search()
            }
        })
    }
}

#Preview {
    ContentView()
}
