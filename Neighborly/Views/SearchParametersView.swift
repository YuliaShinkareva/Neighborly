//
//  SearchParametersView.swift
//  Neighborly
//
//  Created by yulias on 03/07/2024.
//

import SwiftUI

struct SearchParametersView: View {
    
    let searchOptions = [
        "Restaurants": "fork.knife",
        "Hotels": "bed.double.fill",
        "Coffee": "cup.and.saucer.fill",
        "Petrol": "fuelpump.fill",
        "Shopping": "bag.fill",
        "Parks": "leaf.fill",
        "Pharmacy": "cross.case.fill",
        "Gyms": "figure.gymnastics",
        "Banks": "banknote.fill",
        "Museums": "building.columns.fill"
    ]
    
    let onSelected: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(searchOptions.sorted(by: >), id: \.0) { key, value in
                    Button(action: {
                        onSelected(key)
                    }, label: {
                        HStack {
                            Image(systemName: value)
                            Text(key)
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(Color(.systemGray5))
                    .foregroundStyle(.black)
                    .padding(4)
                }
            }
        }
    }
}


#Preview {
    SearchParametersView(onSelected: { _ in })
}
