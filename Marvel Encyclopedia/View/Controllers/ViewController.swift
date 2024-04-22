//
//  ViewController.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 19/4/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        holi()
    }
    
    func holi() {
        // Esto es una prueba para ver que esta dando los datos correctamente
        Task {
            do {
                let response:ResponseCharacter? = try await ApiClient().executeApi()
                if response != nil{
                    guard let lista = response?.data.results else { return }
                    
                    for x in lista {
                        print(x.name)
                    }
                }else {
                    print("nada")
                }
            } catch let error{
                print(error.localizedDescription)
            
            }
            
           
        }
    }


}

