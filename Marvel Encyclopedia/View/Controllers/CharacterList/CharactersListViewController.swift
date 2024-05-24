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
    @IBOutlet weak var noResustsWarning: UIView!
    private let mainViewModel = CharactersListViewModel()
    private var getCancellable: AnyCancellable?
    private var getCancellablePage: AnyCancellable?

   
    override func viewDidLoad() {
        super.viewDidLoad()
        customTitle()
        setBind()
        mainViewModel.getCharacters(currentPage: pageControl.currentPage)
        pageControllerSetUp()
        characterSearchBar.isHidden = true
        characterTable.register(UINib(nibName: "CharacterItem", bundle: nil), forCellReuseIdentifier: "CharacterItem")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        characterSearchBar.isHidden = true
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
    
    @IBAction func searchNavigationBar(_ sender: Any) {
        characterSearchBar.isHidden = false
    }
}

// MARK: -  Table setup
extension CharactersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainViewModel.characterList.isEmpty {
            noResustsWarning.isHidden = false
        } else {
            noResustsWarning.isHidden = true
        }
        return mainViewModel.characterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterItem", for: indexPath)
                as? CharacterItem else {
            let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
            defaultCell.textLabel?.text = "error"
            return defaultCell
        }
        if indexPath.row < mainViewModel.characterList.count {
            let character = mainViewModel.characterList[indexPath.row]
            cell.configure(charater: character)
        }
        
        return cell
    }
}

extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = mainViewModel.characterList[indexPath.row]
        let detailsViewC = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        detailsViewC.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: character, resourceTye: .character))
        detailsViewC.title = "Character: \(character.name)"
        self.navigationController?.pushViewController(detailsViewC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CharactersListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pageControl.currentPage = 0
        if searchText.isEmpty {
            mainViewModel.getCharacters(currentPage: pageControl.currentPage)
        } else {
            mainViewModel.getCharactersFilter(filter: searchText, currentPage: pageControl.currentPage)
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
        if let searchText = characterSearchBar.text, !searchText.isEmpty {
            mainViewModel.getCharactersFilter(filter: searchText, currentPage: sender.currentPage)
        } else {
            mainViewModel.getCharacters(currentPage: sender.currentPage)
        }
    }
}

// MARK: UINavigationBar
// Configurar fuente personalizada para UINavigationBar
extension CharactersListViewController {
    func customTitle() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = "Characters List"
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        
        if let customFont = UIFont(name: "Acme-Regular", size: 25) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: customFont
            ]
            self.navigationController?.navigationBar.titleTextAttributes = attributes
        }
    }
    
}





