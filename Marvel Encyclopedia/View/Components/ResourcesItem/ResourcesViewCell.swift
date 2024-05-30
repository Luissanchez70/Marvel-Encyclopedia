//
//  ResourcesViewCell.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 24/04/2024.
//

import UIKit
import Combine
class ResourcesViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var resorceItem: ResourcesItemViewModel?
    var cancelables: Set<AnyCancellable> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tittleLabel.font = UIFont(name: "Marvel-Bold", size: 20)
        descriptionLabel.font = UIFont(name: "Marvel-Regular", size: 15)
    }
    
    func configure(resorceItem: ResourcesItemViewModel) {
        self.resorceItem = resorceItem
        bind()
        thumbnail.isHidden = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        tittleLabel.text = resorceItem.title
        if resorceItem.desc.isEmpty {
            descriptionLabel.text = "Without description"
        } else {
            descriptionLabel.text = resorceItem.desc
        }
        resorceItem.getThumbnail()
    }
    
    func bind() {
        guard let resorceItem else { return }
        resorceItem.thumbnail.sink { thumbnail in
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
                self?.thumbnail.isHidden = false
                self?.thumbnail.image = thumbnail
            }
        }.store(in: &cancelables)
    }
}
