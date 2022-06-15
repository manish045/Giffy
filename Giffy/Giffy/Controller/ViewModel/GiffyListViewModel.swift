//
//  GiffyListViewModel.swift
//  Giffy
//
//  Created by Manish Tamta on 15/06/2022.
//

import Foundation

protocol GiffyListViewModelInput {
    
}

protocol GiffyListViewModelOutput {
    
}

protocol DefaultGiffyListViewModel: GiffyListViewModelInput, GiffyListViewModelOutput {}

final class GiffyListViewModel: DefaultGiffyListViewModel {
    
    var coordinator: GiffyListViewCoordinatorInput
    
    init(coordinator: GiffyListViewCoordinatorInput) {
        self.coordinator = coordinator
    }
}
