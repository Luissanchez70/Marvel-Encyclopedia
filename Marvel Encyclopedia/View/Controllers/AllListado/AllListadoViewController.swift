//
//  AllListadoViewController.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 08/05/2024.
//

import UIKit
import Combine
class AllListadoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moreResultsButton: UIButton!
    
    var resource:[Any] =  []
    var cancelebles: Set<AnyCancellable> = []
    
    var viewModel : AllListadoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for testes purposes
            //viewModel = AllListadoViewModel(allListModel: AllListadoModel(id: 1009144, type: .character, targetTyoe: .comic))
        
        setTableView()
        bind()
        guard let viewModel  else { return  }
        viewModel.requestMoreResults()
    }
    
    func setTableView(){
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ResourcesViewCell", bundle: nil), forCellReuseIdentifier: "ResourcesViewCell")
    }
    
    func bind() {
        viewModel?.resource.sink(receiveValue: { resource in
            self.resource = resource
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateMoreResultsButton()
            }
        }).store(in: &cancelebles)
        
    }
    
    func updateMoreResultsButton() {
        guard let viewModel else { return }
        if viewModel.getMoreResults() {
            moreResultsButton.isHidden = false
        } else {
            moreResultsButton.isHidden = true
        }
    }
    
    @IBAction func moreResultsPressed(_ sender: UIButton) {
        guard let viewModel else { return }
        viewModel.requestMoreResults()
    }
    
}

extension AllListadoViewController : UITableViewDataSource {
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
