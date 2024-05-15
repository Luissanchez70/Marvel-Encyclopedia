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

    var cancelebles: Set<AnyCancellable> = []
    var selectedKey = "None"
    var selectedResource: [Any] = []
    
    var viewModel: DetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullListButton.isHidden = true
        setupView()
    }
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        selectedKey = sender.titleForSegment(at: index) ?? "Title not found received nill "
        selectSegmentfor(key: selectedKey)
    }
    
    func selectSegmentfor(key : String) {
        guard let viewModel  else { return  }
        selectedResource = viewModel.resources.value[key] ?? []
        if selectedResource.count == 5 {
            fullListButton.isHidden = false
        } else {
            fullListButton.isHidden = true
        }
        tableView.reloadData()
    }
    
    @IBAction func IrAllListadoPressed(_ sender: UIButton) {
        let nvc = AllListadoViewController()
        guard let viewModel else  { return }
        let id = viewModel.getID()
        let type = viewModel.getType()
        guard let targetType = ResourceType(rawValue: selectedKey) else { return }
                
        let model = AllListadoViewModel(allListModel: AllListadoModel(id: id, type: type, targetTyoe: targetType))
        nvc.viewModel = model
        self.navigationController?.pushViewController(nvc, animated: true)
    }
}
extension DetailsViewController: UITableViewDelegate {
    
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

extension DetailsViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedResource.count
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
        setDesc()
        desc.text = viewModel.getDesc()
        viewModel.fetThumbnail()
        viewModel.fetchResources()
    }
    
    func setDesc() {
        guard let viewModel else { return }
        guard let descText = viewModel.getDesc() else {
            return
        }
        
        if descText.isEmpty {
            desc.isHidden = true
        } else {
            desc.isHidden = false
            desc.text = descText
        }
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
                        self.selectedKey = key
                        self.selectSegmentfor(key: key)
                    }
                }
            }
        }
    }
}
