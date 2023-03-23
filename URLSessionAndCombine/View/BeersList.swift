//
//  RepoListView.swift
//  URLSessionAndCombine
//
//  Created by july on 2023/3/23.
//

import SwiftUI

struct BeersList: View {
    let beers: [Beer]
    let isLoading: Bool 
    let onScrolledAtBottom: (() -> Void)
    
    //The body contains a list and a loading indicator below it.
    var body: some View {
        List {
            beersList
            if isLoading {
                loadingIndicator
            }
        }
    }
    
    private var beersList: some View {
        ForEach(beers) { beer in
            BeerRow(beer: beer)
                .onAppear {
                    if self.beers.last == beer {
                        self.onScrolledAtBottom()
                    }
                }
            
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

/*
struct BeersList_Previews: PreviewProvider {
    static var previews: some View {
        BeersList(beers: [Beer][0], isLoading: true, onScrolledAtBottom: () -> Void)
            .environmentObject(BeerViewModel())
    }
}
*/
