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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resourceSelector: UISegmentedControl!
    
    var viewModel : DetailsViewModel?
    
    var cancelebles: Set<AnyCancellable> = []
    var selectedKey = "None"
    var selectedResource : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        guard let viewModel  else { return  }
        let index = sender.selectedSegmentIndex
        selectedKey = sender.titleForSegment(at: index) ?? "Title not found received nill "
        selectedResource = viewModel.resources.value[selectedKey] ?? []
        tableView.reloadData()
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedResource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let comic = selectedResource[indexPath.row] as? Comic {
            let nvc = DetailsViewController()
            nvc.viewModel = DetailsViewModel(detailableObject: ComicModel(comic))
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourcesViewCell", for: indexPath) as! ResourcesViewCell
        selectedObject(selectedResource, indexPath, cell)
        return cell
    }
    
    private func selectedObject(_ resource: [Any], _ indexPath: IndexPath, _ cell: ResourcesViewCell) {
        var item : ResourcesItemViewModel?
        if let resource = resource[indexPath.row] as? ResourceItem {
            item = ResourcesItemViewModel(from: resource)
        }else if let character = resource[indexPath.row] as? MarvelCharacter {
            item = ResourcesItemViewModel(from: character)
        }else if let creator = resource[indexPath.row] as? Creator {
            item = ResourcesItemViewModel(from: creator)
        }
        guard let item  else { return  }
        cell.configure(resorceItem: item)
    }
}

private extension DetailsViewController {
    
    func setupView() {
        name.text = ""
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ResourcesViewCell", bundle: nil), forCellReuseIdentifier: "ResourcesViewCell")
        loadDetails()
        setBinds()
    }
    
    func loadDetails() {
        guard let viewModel  else { return }
        name.text = viewModel.getName()
        desc.text = viewModel.getDesc()
        viewModel.fetThumbnail()
        viewModel.fetchResources()
    }
    
}

extension  DetailsViewController{ // trying with combine
    func setBinds() {
        guard let viewModel  else { return }
        viewModel.resources.sink(receiveValue: { received in
            self.setSegmentedControl(resources : received)
        }).store(in: &cancelebles)
        
        viewModel.thumbnail.sink { image in
            DispatchQueue.main.async { [weak self] in
                self?.image.image = image
            }
        }.store(in: &cancelebles)
    }
    
    func setSegmentedControl(resources : [String:[Any]]) {
        resourceSelector.removeAllSegments()
        for (name , items) in resources {
            if !items.isEmpty {
                resourceSelector.insertSegment(withTitle: name, at: 0, animated: false)
            }
        }
        if !resources.isEmpty {
            selectedKey = resourceSelector.titleForSegment(at: 0) ?? "Title not found received nill "
            selectedResource = viewModel!.resources.value[selectedKey] ?? []
            tableView.reloadData()
        }
    }
}
