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
    private let mainViewModel = CharactersListViewModel()
    private var getCancellables: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBind()
        mainViewModel.getCharacters()
        characterTable.register(UINib(nibName: "CharacterItem", bundle: nil), forCellReuseIdentifier: "CharacterItem")
    }
    private func setBind() {
        getCancellables = mainViewModel.$characterList.sink { list in
            DispatchQueue.main.async {
                self.characterTable.reloadData()
            }
        }
    }
    @IBAction func testButtonPressed(_ sender: UIBarButtonItem) {
        
        let nvc = AllListadoViewController()
        navigationController?.pushViewController(nvc, animated: true)
    }
}
// MARK: -  Table setup
extension CharactersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.characterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterItem", for: indexPath)
                as? CharacterItem else {
            let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
            defaultCell.textLabel?.text = "error"
            return defaultCell
        }
        let character = mainViewModel.characterList[indexPath.row]
        cell.configure(charater: character)
        return cell
    }
}

extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = mainViewModel.characterList[indexPath.row]
        let detailsViewC = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        detailsViewC.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: character, resourceTye: .character))
        self.navigationController?.pushViewController(detailsViewC, animated: true)
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


