//
//  ViewController.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 19/4/24.
//

import UIKit
import Combine

class CharactersListViewController: UIViewController {
    
    @IBOutlet weak var characterSearchBar: UISearchBar!
    @IBOutlet weak var characterTable: UITableView!
    private let mainViewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBind()
        loadChatacter()
    }
    private func loadChatacter() {
        mainViewModel.getCharacters()
    }
    
    private func setBind() {
        mainViewModel.$characterList.sink { list in
            DispatchQueue.main.async {
                self.characterTable.reloadData()
            }
        }.store(in: &cancellables)
    }
}
extension CharactersListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.characterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterItem", for: indexPath) as! CharacterItem
        let character = mainViewModel.characterList[indexPath.row]
        cell.configure(charater: character)
        return cell
    }
}
extension CharactersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = mainViewModel.characterList[indexPath.row]
        let dvc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        dvc.viewModel = DetailsViewModel(detailableObject: MarvelCharacterModel(character))
        self.navigationController?.pushViewController(dvc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CharactersListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            mainViewModel.getCharacters()
        } else {
            mainViewModel.getCharactersFilter(filter: searchText)
        }
    }
}
