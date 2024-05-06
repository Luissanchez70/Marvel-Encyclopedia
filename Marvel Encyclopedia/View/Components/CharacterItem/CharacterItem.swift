//
//  CharacterItem.swift
//  Marvel Encyclopedia
//
//  Created by Diogo Filipe Abreu Rodrigues on 02/05/2024.
//

import UIKit
import Combine

class CharacterItem: UITableViewCell {

    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(charater: Character) {
        nameLabel.text = charater.name
        if charater.description.isEmpty {
            descLabel.text = "Without description"
        } else {
            descLabel.text = charater.description
        }
        let base = charater.thumbnail!.path.replacingOccurrences(of: "http:", with: "https:")
        getImageView("\(base).\(charater.thumbnail!.extension)")
    }
    
    func getImageView(_ urlBase: String) {
        DownloadImageFromAPI().execute(urlBase: urlBase)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("--> \(error.localizedDescription)")
                }
            } receiveValue: { image in
                DispatchQueue.main.async {
                    self.thumbnail.image = image
                }
            }.store(in: &cancellables)
    }
    
}
