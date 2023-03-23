//
//  RepositoriesViewModel.swift
//  URLSessionAndCombine
//
//  Created by july on 2023/3/23.
//

import SwiftUI
import Combine

enum PunkAPI {
    static let pageSize = 25 //每页多少条
    
    static func searchBeers(page: Int) -> AnyPublisher<[Beer], Error> {
        let url = URL(string:"https://api.punkapi.com/v2/beers?page=\(page)&per_page=\(Self.pageSize)")!
        return URLSession.shared
            .dataTaskPublisher(for: url) // 1. Create a publisher that wraps a URL session data task
            .tryMap { try JSONDecoder().decode([Beer].self, from: $0.data) }// 2.Decode the response as BeerSearchResult. This is an intermediate type created for the purpose of parsing JSON.
            .receive(on: DispatchQueue.main) // 3.Receive response on the main thread.
            .eraseToAnyPublisher()
    }
}



//1.
class BeerViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    // 2.
    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        
        PunkAPI.searchBeers(page: state.page)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
            switch completion {
            case .finished:
                break
            case .failure:
                state.canLoadNextPage = false
            }
        }
    private func onReceive(_ batch: [Beer]) {
            state.beers += batch
            state.page += 1
            state.canLoadNextPage = batch.count == PunkAPI.pageSize
        }

    // 3.The state contains all the information to render a view.
    struct State {
        var beers: [Beer] = []
        var page: Int = 1
        var canLoadNextPage = true
    }
}
