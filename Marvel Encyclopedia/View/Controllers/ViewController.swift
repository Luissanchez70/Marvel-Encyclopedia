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
}

