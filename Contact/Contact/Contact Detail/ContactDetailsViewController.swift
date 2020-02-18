//
//  ContactDetailsViewController.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
 
//

import UIKit

protocol ContactDetailsDelegate : class {
    func didUpdateContactInfo()
}

final class ContactDetailsViewController: UIViewController,CentralSpinnerProtocol {
    
    var centralSpinner: UIActivityIndicatorView?
    var viewModel : ContactDetailViewModel!
    let rowHeight : CGFloat = 56.0
    weak var delegate : ContactDetailsDelegate?
    var hasContactInfoUpdated : Bool = false

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactPhotoView: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var favouriteButtonImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        contactPhotoView.layer.cornerRadius =  contactPhotoView.frame.width / 2
        setupNavigationBar()
        initCenterSpinner()
        setupTableView()
        fetchContactDetails()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)        
        tableView.register(UINib(nibName: String(describing: InformationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: InformationTableViewCell.self))
    }
    
    private func setupNavigationBar() {
         self.navigationItem.leftBarButtonItem =  UIBarButtonItem.init(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ContactDetailsViewController.backButtonTapped))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem .init(barButtonSystemItem: .edit, target: self, action: #selector(ContactDetailsViewController.editButtonTapped))
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        let isContactFavourted: Bool = self.viewModel.getEditContact().favourite
        let isContactFavouretdInvert = !isContactFavourted
        if isContactFavouretdInvert {
            favouriteButtonImageView.image = UIImage.init(named: "favourite_button_selected")
        } else {
            favouriteButtonImageView.image = UIImage.init(named: "favourite_button")
        }
        animateCentralSpinner()
        self.viewModel.favorite(withSuccess: {
            var contact = self.viewModel.getEditContact()
            contact.favourite = isContactFavouretdInvert
            self.hasContactInfoUpdated = true
            self.stopAnimatingCentralSpinner()
            self.reloadHeaderViews()
        }) { (error) in
            self.stopAnimatingCentralSpinner()
            self.showAlert(error?.localizedDescription ?? "Unknown error")
        }
    }
    @objc func backButtonTapped() {
        if hasContactInfoUpdated {
            self.delegate?.didUpdateContactInfo()
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func editButtonTapped() {
        let editViewModel = EditContactViewModel .init(contact: self.viewModel.getEditContact())
        let editVC = EditContactViewController .init(withViewModel: editViewModel)
        editVC.delegate = self
        let nav = UINavigationController .init(rootViewController: editVC)
        self.present(nav, animated: true, completion: nil)
    }
   private func fetchContactDetails() {
        animateCentralSpinner()
        self.viewModel.fetchContactDetails(withSuccess: {
              self.stopAnimatingCentralSpinner()
            DispatchQueue.main.async {
                self.reloadHeaderViews()
                self.tableView.reloadData()
            }
        }) { (error) in
              self.stopAnimatingCentralSpinner()
             self.showAlert(error?.localizedDescription ?? "Unknown error")
        }
    }
    @IBAction func messageActionTapped(_ sender: Any) {
        guard let number = self.viewModel.editContact.phoneNumber else {
                   showAlert("Mobile number not configured for this contact")
                   return
               }
               Util.openMessages(withNumber: number) { (result) in
                   if !result {
                       self.showAlert("Messages application not available")
                   }
               }
    }
    @IBAction func callActionTapped(_ sender: Any) {
       guard let number = self.viewModel.editContact.phoneNumber else {
           showAlert("Mobile number not configured for this contact")
           return
       }
       Util.openDialler(withNumber: number) {  (result) in
           if !result {
               self.showAlert("Dialler application not available")
           }
       }
    }
    
    @IBAction func emailActionTapped(_ sender: Any) {
        guard let email = self.viewModel.editContact.email else {
            showAlert("Email not configured for this contact")
            return
        }
        Util.openEmail(withTo: email) { (result) in
            if !result {
                self.showAlert("Mail application not available")
            }
        }
    }
    private func reloadHeaderViews() {
        stopAnimatingCentralSpinner()

        let fullName = self.viewModel.getEditContact().displayName
        contactName.text = fullName

    let isContactFavourted: Bool = self.viewModel.getEditContact().favourite

        if isContactFavourted {
            favouriteButtonImageView.image = UIImage.init(named: "favourite_button_selected")
        } else {
            favouriteButtonImageView.image = UIImage.init(named: "favourite_button")
        }
      contactPhotoView.image = UIImage.init(named: Image.profilePicturePlaceHolder)
       updateProfilePicture(withURLPath: self.viewModel.editContact.profilePicture)
    }
    
    private func updateProfilePicture(withURLPath path: String?) {
        guard let path = path else {
            return
        }
        ImageDownloader.sharedImageDownloader.download(path: path, placeHolderImage: UIImage(named:Image.profilePicturePlaceHolder)) { [weak self] (image) in
            self?.contactPhotoView?.image = image
        }
    }
}

extension ContactDetailsViewController : BaseFormViewDelegate {
    func didUpdateProfileImage(image: UIImage) {
        contactPhotoView.image = image
    }
    
    func didFormUpdateSuccessfully() {
        self.hasContactInfoUpdated = true
        fetchContactDetails()
    }
}

extension ContactDetailsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InformationTableViewCell.self), for: indexPath)
        if let uneditableCell = cell as? InformationTableViewCell, let cellViewModel = viewModel.cellViewModel(atIndex: indexPath.row) {
            uneditableCell.configureCell(viewModel: cellViewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}
