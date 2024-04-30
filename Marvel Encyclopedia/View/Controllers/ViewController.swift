//
//  ViewController.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 19/4/24.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var CharacterSearchBar: UISearchBar!
    @IBOutlet weak var CharacterTable: UITableView!
    private let mainViewModel = MainViewModel()
    private var marvelCharacter: Character? = nil
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CharacterTable.dataSource = self
        CharacterTable.delegate = self
        
        dataSource()
    }
    
    private func dataSource() {
        mainViewModel.$characterList.sink { list in
            DispatchQueue.main.async {
                self.CharacterTable.reloadData()
            }
        }.store(in: &cancellables)
        mainViewModel.getCharacters()
    }
}
// MARK: -  Table setup
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
// MARK: -  SearchBar setup
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            mainViewModel.getCharacters()
        } else {
            mainViewModel.getCharactersFilter(filter: searchText)
        }
    }
}
