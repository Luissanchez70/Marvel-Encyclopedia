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
    @IBOutlet weak var fullListButton: UIButton!
    
    var viewModel : DetailsViewModel?
    
    var cancelebles: Set<AnyCancellable> = []
    var selectedKey = "None"
    var selectedResource : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullListButton.isHidden = true
        setupView()
    }
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        guard let viewModel  else { return  }
        let index = sender.selectedSegmentIndex
        selectedKey = sender.titleForSegment(at: index) ?? "Title not found received nill "
        selectedResource = viewModel.resources.value[selectedKey] ?? []
        if selectedResource.count == 5 {
            fullListButton.isHidden = false
        } else {
            fullListButton.isHidden = true
        }
        tableView.reloadData()
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedResource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nvc = DetailsViewController()
        
        if let comic = selectedResource[indexPath.row] as? Comic {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: comic, resourceTye: .comic))
        } else if let series = selectedResource[indexPath.row] as? Series {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: series, resourceTye: .serie))
        } else if let creator = selectedResource[indexPath.row] as? Creator {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: creator, resourceTye: .creator))
        } else if let event = selectedResource[indexPath.row] as? Event {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: event, resourceTye: .event))
        } else if let character = selectedResource[indexPath.row] as? Character {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: character, resourceTye: .character))
        } else if let story = selectedResource[indexPath.row] as? Storie {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: story, resourceTye: .story))
        }
        
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResourcesViewCell", for: indexPath)
                as? ResourcesViewCell else {
            let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
            defaultCell.textLabel?.text = "error"
            return defaultCell
        }
        selectedObject(selectedResource, indexPath, cell)
        return cell
    }
    
    private func selectedObject(_ resource: [Any], _ indexPath: IndexPath, _ cell: ResourcesViewCell) {
        var item : ResourcesItemViewModel?
        if let resource = resource[indexPath.row] as? ResourceItem {
            item = ResourcesItemViewModel(from: resource)
        }else if let character = resource[indexPath.row] as? Character {
            item = ResourcesItemViewModel(from: character)
        }else if let creator = resource[indexPath.row] as? Creator {
            item = ResourcesItemViewModel(from: creator)
        }
        guard let item  else { return }
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
extension  DetailsViewController {
    func setBinds() {
        guard let viewModel  else { return }
        viewModel.resources.sink(receiveValue: { received in
            self.setSegmentedControl(resources : received)
        }).store(in: &cancelebles)
        
        viewModel.thumbnail.sink(receiveValue: { image in
            self.image.image = image
        }).store(in: &cancelebles)
    }
    func setSegmentedControl(resources : [String:[Any]]) {
        DispatchQueue.main.async {
            self.resourceSelector.removeAllSegments()
            let sortedKeys = resources.keys.sorted(by: <)
            for  key in sortedKeys {
                if let items = resources[key] {
                    if  !items.isEmpty {
                        self.resourceSelector.insertSegment(withTitle: key, at: 0, animated: false)
                    }
                }
            }
        }
        
    }
}
