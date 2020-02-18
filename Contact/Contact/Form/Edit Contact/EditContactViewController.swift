//
//  EditContactViewController.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import UIKit

final class EditContactViewController: BaseFormViewController {
    
    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    private(set)  var viewModel : EditContactViewModel!
    
    convenience init(withViewModel viewModel: EditContactViewModel) {
        self.init(nibName: "EditContactViewController", bundle: nil)
        self.viewModel = viewModel
        self.baseFormViewModel = self.viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditContactViewController.handleTap))
        profileImageContainerView.addGestureRecognizer(tap)
    }
    @objc private func handleTap(){
        self.showOptions()
    }
    
    @objc override func doneButtonTapped() {
        animateCentralSpinner()
        self.viewModel.editContact(withSuccess: {
            self.stopAnimatingCentralSpinner()
            self.dismiss(animated: true, completion: {
                self.delegate?.didFormUpdateSuccessfully()
            })
        }) { (error) in
            self.stopAnimatingCentralSpinner()
            self.showAlert(error?.localizedDescription ?? "Unknown error")
        }
    }
    
}
//MARK: - UIImagePickerControllerDelegate

extension EditContactViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
