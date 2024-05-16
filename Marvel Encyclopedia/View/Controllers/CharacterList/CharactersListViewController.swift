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
    @IBOutlet weak var pageControl: UIPageControl!
    private let mainViewModel = CharactersListViewModel()
    private var getCancellable: AnyCancellable?
    private var getCancellablePage: AnyCancellable?

   
    override func viewDidLoad() {
        super.viewDidLoad()
        setBind()
        mainViewModel.getCharacters(currentPage: pageControl.currentPage)
        pageControllerSetUp()
        characterTable.register(UINib(nibName: "CharacterItem", bundle: nil), forCellReuseIdentifier: "CharacterItem")
    }
    private func setBind() {
        getCancellable = mainViewModel.$characterList.sink { list in
            DispatchQueue.main.async {
                self.characterTable.reloadData()
            }
        }
        getCancellablePage = mainViewModel.$numberPage.sink { num in
            DispatchQueue.main.async {
                self.pageControl.numberOfPages = num
            }
        }
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
            mainViewModel.getCharacters(currentPage: pageControl.currentPage)
        } else {
            mainViewModel.getCharactersFilter(filter: searchText)
        }
    }
}
// MARK: - UIPageControl
extension CharactersListViewController {
    
    func pageControllerSetUp(){
        pageControl.numberOfPages = 10
        pageControl.currentPage = 0
        
    }
    
    @IBAction func onclickPage(_ sender: UIPageControl) {
        
        let page = sender.currentPage
        
        mainViewModel.getCharacters(currentPage: page)
        mainViewModel.getCharactersFilter(filter: characterSearchBar.text!)
        
    }
}

