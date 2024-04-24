//
//  DetailsViewController.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 19/04/2024.
//

import UIKit
import Combine

class DetailsViewController: UIViewController{
   
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var resourceSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var marvelCharacter: MarvelCharacter?
    var viewModel : DetailsViewModel?
    var cancelebles: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    @IBAction func onClickSegmentControl(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            viewModel?.getResourcesComics()
        case 1:
            viewModel?.getResourcesSeries()
        default:
            // TODO: the rest of the lists need to be made
            print("Otros")
        }
    }
    
}
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let resource = viewModel?.resources else { return 0 }
        return resource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourcesItem", for: indexPath) as! ResourcesItem
        guard let resource = viewModel?.resources else { return cell }
        selectedObject(resource, indexPath, cell)
        return cell
    }
    
    private func selectedObject(_ resource: [Any], _ indexPath: IndexPath, _ cell: ResourcesItem) {
        if let comic = resource[indexPath.row] as? Comic {
            cell.configure(character: comic)
        } else if let serie = resource[indexPath.row] as? Series {
            cell.configure(character: serie)
        }
    }
}

private extension DetailsViewController {
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        loadDetails()
    }
    
    func loadDetails() {
        guard let character = marvelCharacter else { return }
        viewModel = DetailsViewModel(marvelCharacter: character)
        name.text = character.name
        desc.text = character.description
        imageDownload(character: character)
        
        cancelebles = viewModel?.$resources.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func imageDownload(character: MarvelCharacter) {
        
        let base = character.thumbnail.path.replacingOccurrences(of: "http:", with: "https:")
        ApiClient().downloadImage(urlBase: "\(base).\(character.thumbnail.extension)") { image in
            DispatchQueue.main.async { [weak self] in
                self?.image.image = image
            }
        }
    }
}
