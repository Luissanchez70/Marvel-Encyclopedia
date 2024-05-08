//
//  AllListadoViewController.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 08/05/2024.
//

import UIKit

class MAllListadoViewModel {
    
}

class AllListadoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moreResultsButton: UIButton!
    
    var viewModel : MAllListadoViewModel?
    var resource : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ResourcesViewCell", bundle: nil), forCellReuseIdentifier: "ResourcesViewCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourcesViewCell", for: indexPath) as! ResourcesViewCell
        if index < resource.count {
            selectedObject(resource[index], cell)
        }
        return cell
    }
    
    private func selectedObject(_ resource: Any, _ cell: ResourcesViewCell) {
        var item: ResourcesItemViewModel?
        if let resourceItem  = resource as? ResourceItem {
            item = ResourcesItemViewModel(from: resourceItem)
        }else if let character = resource as? Character {
            item = ResourcesItemViewModel(from: character)
        }else if let creator = resource as? Creator {
            item = ResourcesItemViewModel(from: creator)
        }
        guard let item  else { return }
        cell.configure(resorceItem: item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resource.count
    }
}
