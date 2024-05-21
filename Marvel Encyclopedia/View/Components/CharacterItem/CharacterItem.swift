
import UIKit
import Combine

class CharacterItem: UITableViewCell {
 
    private var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = UIFont(name: "Marvel-Bold", size: 30)
        descLabel.font = UIFont(name: "Marvel-Regular", size: 15)
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
        // Configure the view for the selected state
    }
    
    func configure(charater: Character) {
        nameLabel.text = charater.name
        if let desc = charater.description  {
            descLabel.isHidden = false
            descLabel.text = desc
        }  else {
            descLabel.isHidden = true
        }
        thumbnail.isHidden = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        getImageView(path: charater.thumbnail!.path, exten: charater.thumbnail!.extension)
    }
    
    func getImageView( path: String, exten: String) {
        DownloadThumbnail().execute(path: path, exten: exten)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("--> \(error.localizedDescription)")
                }
            } receiveValue: { image in
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.thumbnail.isHidden = false
                    self.thumbnail.image = image
                }
            }.store(in: &cancellables)
    }
}
