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
    var viewModel : DetailsViewModel?
    
    var cancelebles: Set<AnyCancellable> = []
    var selectedKey = "None"
    var selectedResource : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ResourcesViewCell", bundle: nil), forCellReuseIdentifier: "ResourcesViewCell")
        
        setBinds()
        setupView()
    }
    
    
    @IBAction func onClickSegmentControl(_ sender: UISegmentedControl) {
        guard let viewModel  else { return  }
        let index = sender.selectedSegmentIndex
        selectedKey = sender.titleForSegment(at: index) ?? "Title not found received nill "
        selectedResource = viewModel.resources.value[selectedKey] ?? []
        print(selectedKey)
        tableView.reloadData()
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedResource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourcesViewCell", for: indexPath) as! ResourcesViewCell
        selectedObject(selectedResource, indexPath, cell)
        return cell
    }
    
    private func selectedObject(_ resource: [Any], _ indexPath: IndexPath, _ cell: ResourcesViewCell) {
        var item : ResourcesItemViewModel?
        if let comic = resource[indexPath.row] as? Comic {
            item = ResourcesItemViewModel(from: comic)
        } else if let serie = resource[indexPath.row] as? Series {
            item = ResourcesItemViewModel(from: serie)
        } else if let storie = resource[indexPath.row] as? Storie {
            item = ResourcesItemViewModel(from: storie)
        } else if let event = resource[indexPath.row] as? Event {
            item = ResourcesItemViewModel(from: event)
        }
        guard let item  else { return  }
        cell.configure(resorceItem: item)
    }
}

private extension DetailsViewController {
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        loadDetails()
    }
    
    func loadDetails() {
        guard let viewModel  else { return }
        name.text = viewModel.getName()
        desc.text = viewModel.getDesc()
        imageDownload(thumbnail: viewModel.getThumbnail())
        viewModel.fetchResources()
    }
    
    private func imageDownload(thumbnail: Thumbnail) {
        
        let base = thumbnail.path.replacingOccurrences(of: "http:", with: "https:")
        ApiClient().downloadImage(urlBase: "\(base).\(thumbnail.extension)") { image in
            DispatchQueue.main.async { [weak self] in
                self?.image.image = image
            }
        }
    }
}

extension  DetailsViewController{ // trying with combine
    func setBinds() {
        guard let viewModel  else { return }
        viewModel.resources.sink(receiveValue: { received in
            self.setSegmentedControl(resources : received)
        }).store(in: &cancelebles)
    }
    
    func setSegmentedControl(resources : [String:[Any]]) {
        resourceSelector.removeAllSegments()
        for (name , items) in resources {
            if !items.isEmpty {
                resourceSelector.insertSegment(withTitle: name, at: 0, animated: false)
            }
        }
    }
}
