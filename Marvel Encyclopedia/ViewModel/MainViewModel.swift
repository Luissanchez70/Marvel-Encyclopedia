//
//  MainViewModel.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 22/4/24.
//

import Foundation
import UIKit
import Combine

class MainViewModel {
    
    @Published var characterList: [MarvelCharacter] = []
    private var cancellables = Set<AnyCancellable>()
    private let marvelCharacterUseCase: MarvelCharacterUseCase
    
    init() {
        marvelCharacterUseCase = MarvelCharacterUseCase()
    }
    
    func getCharacters() {
// Sugerencia: Lo que has puesto, se puede cambiar por esto: Primero reemplazas el error por un array vacío,
// lo asignas al publicador que te interese
// y almacenas la suscripción.
// Perderías el print del error, pero eso si queréis lo valoramos en una evolución de la aplicación.
/*
        marvelCharacterUseCase.execute()
            .replaceError(with: [])
            .assign(to: \.characterList, on: self)
            .store(in: &cancellables)
*/
        
        marvelCharacterUseCase.execute().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("--> \(error.localizedDescription)")
            }
        } receiveValue: { list in
            self.characterList = list
        }.store(in: &cancellables)
    }
    
    
    // Se puede hacer exactamente lo mismo.
    func getCharactersFilter(filter: String) {
        let whereClause = "nameStartsWith=\(filter)&"
        marvelCharacterUseCase.execute(whereClause: whereClause).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("--> \(error.localizedDescription)")
            }
        } receiveValue: { list in
            self.characterList = list
        }.store(in: &cancellables)
    }
}

// Como comenarios no me gusta esta forma de crear las suscripciones porque se van almacenando sin control en el set cancellables.
// Me explico: si el usuario hace una búsqueda, se llamará a getCharactersFilter y este método creará una suscripción que acabará (por el store) en el set cancellables.
// Si después cambia su búsqueda y hace otra, se crea una segunda suscripción y se almacena en cancellables pero la primera sigue ahí.
// Así sucesivamente, podríamos tener una saturación de suscripciones sin sentido, ya que sólo es necesario tener la suscripción activa.
// Lo reemplazaría el código por:

/*
 - private var cancellables = Set<AnyCancellable>()
 + private let getCharactersSubscription: AnyCancellable? = nil
 
 getCharactersSubscription = marvelCharacterUseCase.execute()
     .replaceError(with: [])
     .assign(to: \.characterList, on: self)

 getCharactersSubscription = marvelCharacterUseCase.execute(whereClause: whereClause)
     .replaceError(with: [])
     .assign(to: \.characterList, on: self)

 */

// De esta forma sólo mantenemos una suscripción y cuando se crea una nueva, se destruye la otra.
