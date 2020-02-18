//
//  BaseFormViewController.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import UIKit

protocol FormCellDataSource {
    func configureCell(datasource : ConfigureCellProtocol,delegate : FormTextFieldCellDelegate?,indexPath : IndexPath)
}

protocol BaseFormViewDelegate : class {
    func didFormUpdateSuccessfully()
    func didUpdateProfileImage(image : UIImage)
}

class BaseFormViewController: UIViewController,CentralSpinnerProtocol {
    
     var centralSpinner: UIActivityIndicatorView?
    var baseFormViewModel : BaseFormViewModel!
    let reuseIdentifier = "FormFieldCellIdentifier"
    var imagePicker = UIImagePickerController()
    
    weak var delegate : BaseFormViewDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initCenterSpinner()
    }
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.register(UINib .init(nibName: "FormTextFieldCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem .init(barButtonSystemItem: .cancel, target: self, action: #selector(BaseFormViewController.cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem .init(barButtonSystemItem: .done, target: self, action: #selector(BaseFormViewController.doneButtonTapped))
    }
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
    }
    
    func showOptions() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    private func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    private func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension BaseFormViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.baseFormViewModel.formFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? FormTextFieldCell {
            cell.configureCell(datasource:  self.baseFormViewModel.formFields[indexPath.row], delegate: self, indexPath: indexPath)
            return cell
        } else {
            let cell = FormTextFieldCell .init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
            cell.configureCell(datasource:  self.baseFormViewModel.formFields[indexPath.row], delegate: self, indexPath: indexPath)
            return cell
        }
    }
}
extension BaseFormViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
extension BaseFormViewController : FormTextFieldCellDelegate {
    func didUpdate(text: String, indexPath: IndexPath) {
        let formField = self.baseFormViewModel.formFields[indexPath.row]
        formField .setFieldValue(value: text)
    }
}


