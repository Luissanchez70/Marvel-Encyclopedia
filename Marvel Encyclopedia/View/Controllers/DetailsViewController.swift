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
    var characterId: Int?
    var viewModel : DetailsViewModel? // set viewModel in prepare
    var cancelebles: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinders()
        print("---> \(characterId)")
        viewModel?.getResources()
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
