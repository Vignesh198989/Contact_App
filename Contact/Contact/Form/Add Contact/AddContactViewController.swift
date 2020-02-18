//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//


import UIKit

final class AddContactViewController: BaseFormViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageContainerView: UIView!
    private(set) var viewModel : AddContactViewModel!
    
    convenience init(withViewModel viewModel: AddContactViewModel) {
        self.init(nibName: "AddContactViewController", bundle: nil)
        self.viewModel = viewModel
        self.baseFormViewModel = self.viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddContactViewController.handleTap))
        profileImageContainerView.addGestureRecognizer(tap)
    }
    @objc func handleTap(){
        self.showOptions()
    }
    
    @objc override func doneButtonTapped() {
         animateCentralSpinner()
        self.viewModel.createContact(withSuccess: {
            self.stopAnimatingCentralSpinner()
            self.showAlert("Contact created successfully") { [weak self] in
                guard let self = self else {
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
        }) { (error) in
            self.stopAnimatingCentralSpinner()
             self.showAlert(error?.localizedDescription ?? "Unknown error")
        }
    }
}



//MARK: - UIImagePickerControllerDelegate

extension AddContactViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
