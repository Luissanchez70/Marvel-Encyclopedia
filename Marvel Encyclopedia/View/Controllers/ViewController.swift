//
//  ViewController.swift
//  Marvel Encyclopedia
//
//  Created by Luis Fernando Sanchez Muñoz on 19/4/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var CharacterSearchBar: UISearchBar!
    @IBOutlet weak var CharacterTable: UITableView!
    private let mainViewModel = MainViewModel()
    private var marvelCharacter: MarvelCharacter? = nil
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CharacterTable.dataSource = self
        CharacterTable.delegate = self
        mainViewModel.getCharacters { success in
            if success {
                DispatchQueue.main.async {self.CharacterTable.reloadData()}
            }
        }
    }
}
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainViewModel.getList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterItem", for: indexPath) as! CharacterItem
        let character = mainViewModel.getList()[indexPath.row]
        cell.configure(charater: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = mainViewModel.getList()[indexPath.row]
        marvelCharacter = character
        performSegue(withIdentifier: "ShowDetailSegue", sender: character)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue",
           let dvc = segue.destination as? DetailsViewController {
            dvc.marvelCharacter = marvelCharacter
        }
    }
}
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            mainViewModel.getCharacters { success in
                if success {
                    DispatchQueue.main.async {self.CharacterTable.reloadData()}
                }
            }
        } else {
            mainViewModel.getCharactersFilter(filter: searchText) { success in
                if success {
                    DispatchQueue.main.async {self.CharacterTable.reloadData()}
                }
            }
        }
    }
}
