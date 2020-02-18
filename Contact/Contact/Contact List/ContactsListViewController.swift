//
//  ViewController.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
 
//
import UIKit

final class ContactsListViewController: UIViewController,CentralSpinnerProtocol {
    
    @IBOutlet weak var contactsListTableView: UITableView!
    
    private(set) var viewModel : ContactsListViewModel!
    var centralSpinner: UIActivityIndicatorView?
    var selectedIndexPath: IndexPath?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         viewModel = ContactsListViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        initCenterSpinner()
        fetchContacts()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupTableView() {
        contactsListTableView.delegate = self
        contactsListTableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem .init(barButtonSystemItem: .add, target: self, action: #selector(ContactsListViewController.addButtonTapped))
        navigationItem.title = "Contacts"
    }
    
     @objc func addButtonTapped() {
//        let addViewModel = AddContactViewModel .init(contact: Contact .init())
//        let addVC = AddContactViewController .init(withViewModel: addViewModel)
//        let nav = UINavigationController .init(rootViewController: addVC)
//        self.present(nav, animated: true, completion: nil)
    }
    
    private func fetchContacts() {
        self.animateCentralSpinner()
        self.viewModel .fetchContacts(withSuccess: {
            self.stopAnimatingCentralSpinner()
                self.contactsListTableView.reloadData()
        }) { (error) in
            self.stopAnimatingCentralSpinner()
            self.showAlert(error?.localizedDescription ?? "Unknown error")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "viewContact", let destination = segue.destination as? ContactDetailsViewController {
//            if let indexPath = selectedIndexPath {
//                var data = self.viewModel.getContactListSection()[indexPath.section].contacts[indexPath.row]
//                destination.viewModel = ContactDetailViewModel .init(contact: &data)
//                destination.delegate = self
//            }
//        }
    }
}


extension ContactsListViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getContactListSection().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getContactListSection()[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.viewModel.getContactListSection()[section].contacts.count == 0 {
            return nil
        }
        return self.viewModel.getContactListSection()[section].sectionTitle
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.viewModel.getContactListSection().compactMap({ $0.sectionTitle })
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactCell
        if let cellViewModel =  self.viewModel.getCellViewModel(atIndex: indexPath.row, inSection: indexPath.section) {
            cell.configureCell(withViewModel: cellViewModel)
        }
        return cell
    }
}

extension ContactsListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: false)
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: "viewContact", sender: nil)
    }
}

//extension ContactsListViewController : ContactDetailsDelegate {
//    func didUpdateContactInfo() {
//        self.contactsListTableView.reloadData()
//    }
//
//
//}
