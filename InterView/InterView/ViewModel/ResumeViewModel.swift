//
//  NasaViewModel.swift
//  InterView
//
//  Created by Christopher Woods on 2/1/25.
//


//
//  NasaViewModel.swift
//  NasaAPI
//
//  Created by Christopher Woods on 11/2/23.
//

import Foundation


class NasaViewModel: ObservableObject{
    @Published var picture = ""
    @Published var date = ""
    
    
    private let service = NasaDataService()
    
    init() {
        fetchPicture()
        
        
    }
    
    func fetchPicture() {
        service.fetchPicture() { image in
            DispatchQueue.main.async{
                self.picture = image
            }
        }
        
    }
    
    func setCurrent(current: String){
        service.setDate(current: current)
        fetchPicture()
    }
}
