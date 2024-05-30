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
    var resource: [Any] =  []
    var cancelebles: Set<AnyCancellable> = []
    var viewModel: AllListadoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List"
        customNavigationBar()
        setTableView()
        bind()
        guard let viewModel  else { return  }
        viewModel.requestMoreResults()
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ResourcesViewCell", bundle: nil), forCellReuseIdentifier: "ResourcesViewCell")
    }
    
    func customNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        moreResultsButton.titleLabel?.font = UIFont(name: "Acme-Regular", size: 20)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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

extension AllListadoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: "ResourcesViewCell", for: indexPath) as? ResourcesViewCell
        else {
            let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
            defaultCell.textLabel?.text = "error"
            return defaultCell
        }
        if index < resource.count {
            selectedObject(resource[index], cell)
        }
        return cell
    }
    
    private func selectedObject(_ resource: Any, _ cell: ResourcesViewCell) {
        var item: ResourcesItemViewModel?
        if let resourceItem  = resource as? ResourceItem {
            item = ResourcesItemViewModel(from: resourceItem)
        } else if let character = resource as? Character {
            item = ResourcesItemViewModel(from: character)
        } else if let creator = resource as? Creator {
            item = ResourcesItemViewModel(from: creator)
        }
        guard let item  else { return }
        cell.configure(resorceItem: item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resource.count
    }
}

extension AllListadoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nvc = DetailsViewController()
        if let comic = resource[indexPath.row] as? Comic {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: comic, resourceTye: .comic))
        } else if let series = resource[indexPath.row] as? Series {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: series, resourceTye: .serie))
        } else if let creator = resource[indexPath.row] as? Creator {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: creator, resourceTye: .creator))
        } else if let event = resource[indexPath.row] as? Event {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: event, resourceTye: .event))
        } else if let character = resource[indexPath.row] as? Character {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: character, resourceTye: .character))
        } else if let story = resource[indexPath.row] as? Storie {
            nvc.viewModel = DetailsViewModel(detailsModel: DetailsModel(from: story, resourceTye: .story))
        }
        
        self.navigationController?.pushViewController(nvc, animated: true)
    }
}
