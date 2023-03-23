//
//  RepositoryRow.swift
//  URLSessionAndCombine
//
//  Created by july on 2023/3/23.
//

import SwiftUI

struct BeerRow: View {
    var beer: Beer
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(beer.name)
            Text(beer.tagline)
                .foregroundColor(.secondary)
        }
    }
}

