//
//  DetailsViewController.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 19/04/2024.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var resourceSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var marvelCharacter: MarvelCharacter?
    var viewModel : DetailsViewModel? // set viewModel in prepare
    var cancelebles: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDetails()
        //setupBinders()
        //viewModel?.getResources()
       
    }
    
    private func setupBinders()  {
        viewModel?.$name.sink { [weak self] name in
            self?.name.text = name
        }.store(in: &cancelebles)
        
        viewModel?.$resources.sink{ [weak self] resources in
            for resource in resources ?? [] {
                for x in resources! {
                    print(x)
                }
            }
        }.store(in: &cancelebles)
    }
}
private extension DetailsViewController {
    
    func loadDetails() {
        guard let character = marvelCharacter else { return }
        viewModel = DetailsViewModel(marvelCharacter: character)
        name.text = character.name
        desc.text = character.description
        let base = character.thumbnail.path.replacingOccurrences(of: "http:", with: "https:")
        ApiClient().downloadImage(urlBase: "\(base).\(character.thumbnail.extension)") { image in
            DispatchQueue.main.async { [weak self] in
                self?.image.image = image
            }
        }
    }
}
