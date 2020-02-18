//
//  ContactCell.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//
import UIKit

final class ContactCell: UITableViewCell {
    
    struct ViewModel: ListCellViewModel {
        let name: String
        let profilePicturePath: String?
        let favourite: Bool
    }
    
    @IBOutlet weak var contactPhotoView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactFavouriteImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contactPhotoView.layer.cornerRadius = contactPhotoView.frame.size.height/2
        contactPhotoView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contactPhotoView.image = nil
        contactNameLabel.text = ""
    }
    
    func configureCell(withViewModel viewModel: ListCellViewModel) {
        
        contactNameLabel.text = viewModel.name
        contactFavouriteImageView.isHidden = !(viewModel.favourite )
        contactPhotoView.image = UIImage.init(named: Image.profilePicturePlaceHolder)
        
        if let path = viewModel.profilePicturePath {
            ImageDownloader.sharedImageDownloader.download(path: path, placeHolderImage: UIImage(named: Image.profilePicturePlaceHolder)) { [weak self] (image) in
                guard let self = self else {
                    return
                }
                self.contactPhotoView.image = image
            }
        }
    }
}
extension ContactCell.ViewModel {
    
    init(contact: Contact) {
        self.name = contact.displayName
        self.favourite = contact.favourite
        self.profilePicturePath = contact.profilePicture
    }
    
}
