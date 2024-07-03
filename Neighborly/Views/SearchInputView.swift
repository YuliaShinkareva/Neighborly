//
//  SearchInputView.swift
//  Neighborly
//
//  Created by yulias on 03/07/2024.
//

import SwiftUI

struct SearchInputView: View {
    
    @Binding var search: String
    @Binding var isSearching: Bool
    
    var body: some View {
        
        VStack(spacing: -10) {
            TextField("Search", text: $search)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    isSearching = true
                }
            SearchParametersView { searchParameter in
                search = searchParameter
                isSearching = true
            }
            .padding([.leading], 10)
            .padding([.bottom], 20)
        }
    }
}

#Preview {
    SearchInputView(search: .constant("gym"), isSearching: .constant(true))
}
