//
//  AllListadoViewController.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 08/05/2024.
//

import UIKit
import Combine

class MAllListadoViewModel {
    
    var moreResults = false
    var resource = PassthroughSubject<[Any], Never>()
    
    var mockCounter = 0;
    var mockarray : [Any] = []
    func getMoreResults() -> Bool {
        return moreResults
    }
    
    func requestMoreResults() {
        if mockCounter == 0 {
            print(4)
            mockarray = [Character(id: 1, name: "Test1", description: "Test1", thumbnail: nil),
                         Character(id: 2, name: "test0", description: "Test1", thumbnail: nil),
                         Character(id: 3, name: "test2", description: "Test1", thumbnail: nil),
                         Character(id: 4, name: "test3", description: "Test1", thumbnail: nil),
                         Character(id: 5, name: "test4", description: "Test1", thumbnail: nil)]
            
            resource.send(mockarray)
            mockCounter = mockCounter + 1
            moreResults = true
        } else if mockCounter == 1 {
            mockarray.append(Character(id: 6, name: "Test6", description: "Test6", thumbnail: nil))
            mockarray.append(Character(id: 7, name: "test7", description: "Test7", thumbnail: nil))
            mockarray.append(Character(id: 8, name: "test8", description: "Test8", thumbnail: nil))
            mockarray.append(Character(id: 9, name: "test9", description: "Test9", thumbnail: nil))
            mockarray.append(Character(id: 10, name: "test10", description: "Test10", thumbnail: nil))
            resource.send(mockarray)
            mockCounter = mockCounter + 1
            moreResults = true
        } else if mockCounter == 2 {
            mockarray.append(Character(id: 11, name: "Tes11", description: "Test11", thumbnail: nil))
            mockarray.append(Character(id: 12, name: "test12", description: "Test12", thumbnail: nil))
            mockarray.append(Character(id: 13, name: "test13", description: "Test13", thumbnail: nil))
            mockarray.append(Character(id: 14, name: "test14", description: "Test14", thumbnail: nil))
            mockarray.append(Character(id: 15, name: "test15", description: "Test15", thumbnail: nil))
            resource.send(mockarray)
            mockCounter = mockCounter + 1
            moreResults = false
        }
    }
}

class AllListadoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moreResultsButton: UIButton!
    var cancelebles: Set<AnyCancellable> = []
    
    var viewModel : MAllListadoViewModel? = MAllListadoViewModel()
    var resource : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        bind()
        viewModel?.requestMoreResults()
    }
    
    func setTableView(){
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ResourcesViewCell", bundle: nil), forCellReuseIdentifier: "ResourcesViewCell")
    }
    
    func bind() {
        viewModel?.resource.sink(receiveValue: { resource in
            print(2)
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
