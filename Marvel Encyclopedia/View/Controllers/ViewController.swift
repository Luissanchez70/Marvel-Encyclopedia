//
//  ViewController.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 19/4/24.
//

import UIKit
import Combine

// FIXME: - Cambiar el nombre a algo más representativo: (por ejemplo CharactersListViewController)
class ViewController: UIViewController, UITableViewDataSource {
    
    // FIXME: - Las variables deberían de ir en minúscula. Las mayúsculas las reservamos para nombres de clase.
    @IBOutlet weak var CharacterSearchBar: UISearchBar!
    
    // FIXME: - Las variables deberían de ir en minúscula. Las mayúsculas las reservamos para nombres de clase.
    @IBOutlet weak var CharacterTable: UITableView!
    private let mainViewModel = MainViewModel()
    
    // FIXME: - Los View controller no deberían de tener variables de estado. Revisa el uso de esta variable porque seguramente no sirva.
    private var marvelCharacter: MarvelCharacter? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sugerencia: - Si vais a trabajar con Storyboard, estas delegaciones yo las movería allí. Si decidís trabajar con interfaces por código. Aquí estaría bien.
        CharacterTable.dataSource = self
        CharacterTable.delegate = self
            
        dataSource()
    }
    
    // FIXME: - Esta función yo la llamaría "bind", "createSuscriptions", "createObservers"... pero dataSource no describe lo que hace la función
    private func dataSource() {
        mainViewModel.$characterList.sink { list in
            DispatchQueue.main.async {
                self.CharacterTable.reloadData()
            }
        }.store(in: &cancellables)
        // FIXME: Esta llamada la sacaría de esta función, porque no cumple el principio de responsabilidad única. Si estamos creando suscripciones no tiene lugar una llamada a generación de datos. La movería a viewDidLoad
        mainViewModel.getCharacters()
    }
}

// FIXME: - Cuidado con las extensiones de protocolos y los métodos que incluyen:
// - tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int: Es un método de UITableViewDataSource
// - tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell: Es un método de UITableViewDataSource
// - tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath): Es un método de UITableViewDelegate
// Separar esta extensión en 2 una por protocolo, y cada una con sus funciones. De esta forma si hay un cambio y se prescinde del protocolo o cambia sabemos qué extensión tocar.

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.characterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterItem", for: indexPath) as! CharacterItem
        let character = mainViewModel.characterList[indexPath.row]
        cell.configure(charater: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = mainViewModel.characterList[indexPath.row]
        
        // FIXME: - Este sistema de navegación y prepare(for segue: UIStoryboardSegue, sender: Any?) son complementarios, o uno o el otro. Ambos no son necesarios
        let dvc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        dvc.viewModel = DetailsViewModel(detailableObject: MarvelCharacterModel(character))
        self.navigationController?.pushViewController(dvc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue",
           let dvc = segue.destination as? DetailsViewController {
             guard let marvelCharacter else { return  }
             dvc.viewModel = DetailsViewModel(detailableObject: MarvelCharacterModel(marvelCharacter))
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            mainViewModel.getCharacters()
        } else {
            mainViewModel.getCharactersFilter(filter: searchText)
        }
    }
}
