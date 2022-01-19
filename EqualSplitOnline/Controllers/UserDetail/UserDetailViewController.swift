//
//  UserDetailViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 06.01.2022.
//

import Foundation
import UIKit

class UserDetailViewController: UIViewController {
    
    
    // MARK: - Properties
    
    private lazy var darkView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = .black
        view.alpha = 0
        view.layer.zPosition = 120        
        return view
    }()
    
    
    private lazy var addTransactionMode: Bool = false {
        didSet {
            if addTransactionMode == true {
//                expandTableView()
                self.addTransactionView.isHidden = false
                self.addNewPaymentButton.isEnabled = false
                self.heightConstraint?.constant = 160
                self.tableView.view.addSubview(self.darkView)
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                    self.darkView.alpha = 0.3
                }
                addTransactionView.moneyField.becomeFirstResponder()
            } else {
//                contractTableView()
                self.heightConstraint?.constant = 0
                self.addTransactionView.isHidden = true
                self.addNewPaymentButton.isEnabled = true
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                    self.darkView.alpha = 0
                } completion: { _ in
                    self.darkView.removeFromSuperview()
                }

                addTransactionView.moneyField.resignFirstResponder()
            }
        }
    }
    
    
    private var heightConstraint: NSLayoutConstraint?
    
    private var backButton: UIButton = {
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(closeController), for: .touchUpInside)
        let btnImage = UIImage(named: "xButton")
        backButton.setImage(btnImage , for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.contentMode = .scaleAspectFit
        return backButton
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Medium", size: 28)
        label.font = label.font.withSize(28)
        label.textColor = UIColor.white
        label.text = "Name"
        label.minimumScaleFactor = 6/UIFont.labelFontSize
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.font = UIFont(name: "Avenir Next Medium", size: 45)
        progressLabel.font = progressLabel.font.withSize(45)
        progressLabel.textColor = UIColor.white
        progressLabel.text = "$0.00"
        progressLabel.minimumScaleFactor = 6/UIFont.labelFontSize
        progressLabel.adjustsFontSizeToFitWidth = true
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        return progressLabel
    }()
    
    private var personOwesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next Medium", size: 24)
        label.font = label.font.withSize(24)
        label.textColor = UIColor.white
        label.text = "Owes"
        label.minimumScaleFactor = 1/2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var progressRing: RingProgressBar = {
        let progressBar = RingProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.layer.zPosition = 20
        return progressBar
    }()
    
    private var startingConstant: CGFloat! //Start position for the gesture transition
    private var topConstraint: NSLayoutConstraint?
    
    private let tableLine = TableLine()
    
    weak var viewmodelDelegate: TransactionTableViewViewModelDelegate?
    
    private lazy var tableView: TransactionsTableViewController = {
        let tableView = TransactionsTableViewController(user: activeUser, viewModel: viewModel)
        tableView.viewmodelDelegate = self.viewmodelDelegate
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        tableView.view.clipsToBounds = true
        tableView.tableView.backgroundColor = .systemBackground
        tableView.view.backgroundColor = .systemBackground
        return tableView
    }()
    
    private var tableViewContainer: UIView = {
        let tableViewContainer = UIView()
        tableViewContainer.layer.zPosition = 100
        tableViewContainer.backgroundColor = .systemBackground
        tableViewContainer.clipsToBounds = true
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.layer.cornerRadius = 20
        return tableViewContainer
    }()
    
    private lazy var addNewPaymentButton: AddNewPaymentButton = {
        let button = AddNewPaymentButton()
        button.addTarget(self, action: #selector(addNewPaymentHandler), for: .touchUpInside)
        if AuthService.activeUser?.id == viewModel.id {
            button.isEnabled = true
            button.alpha = 1
        } else {
            button.isEnabled = false
            button.alpha = 0.5            
        }
        return button
    }()
    
    private lazy var addTransactionView: TransactionExpandedCellView = {
        let cv = TransactionExpandedCellView(frame: CGRect.zero, newTransaction: true)        
        cv.headerDelegate = self
        cv.isHidden = false
        return cv
    }()
    
    private var personIcon = RingPersonIcon()
    
    private var activeUser: User
    var viewModel: Person {
        didSet {
            view.pushTransition(0.2)
            personIcon.adjustColor(forPerson: viewModel)
            personOwesLabel.text = viewModel.owesOrOwed
            nameLabel.text = viewModel.name
            progressRing.progress = viewModel.progress
            progressLabel.text = IntToCurrency.makeDollars(fromNumber: viewModel.totalDebtFieldText ?? 0)
            tableView.viewModel = viewModel
            tableView.tableView.reloadData()
        }
    }
    
    private var currentSessionId: String
    
    // MARK: - Lifecycle
    
    init(user: User, viewModel: Person, inSessionWithId sessionid: String) {
        activeUser = user
        self.viewModel = viewModel
        self.currentSessionId = sessionid
        personIcon.adjustColor(forPerson: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addObservers()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        let background = CAGradientLayer()
        GradientMaker.setGradientBackground(in: self.view, withGradient: background)

        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Helpers
    
    func updateTableView() {
        tableView.tableView.reloadData()
    }
    
    func expandTableView() {
        topConstraint?.constant = -progressRing.frame.height-8
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        self.view.endEditing(true)
    }
    
    func contractTableView() {
        topConstraint?.constant = 30
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(backButton)
        view.addSubview(progressRing)
        view.addSubview(progressLabel)
        view.addSubview(personOwesLabel)
        view.addSubview(tableViewContainer)
        view.addSubview(personIcon)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 14, paddingRight: 10, width: 26, height: 26)
        
        nameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        NSLayoutConstraint.activate([
            progressLabel.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            progressLabel.bottomAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 2),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
        
        progressRing.anchor(top: nameLabel.bottomAnchor, right: progressLabel.leftAnchor, paddingTop: 20, paddingRight: 10, width: 100, height: 100)
        
        personIcon.anchor(top: progressRing.topAnchor, left: progressRing.leftAnchor, bottom: progressRing.bottomAnchor, right: progressRing.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 26, paddingRight: 24)
        
        personOwesLabel.anchor(left: progressLabel.leftAnchor, bottom: progressLabel.topAnchor, paddingBottom: -4)
        
        tableViewContainer.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        topConstraint = tableViewContainer.topAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 30)
        
        NSLayoutConstraint.activate([
            topConstraint!
        ])
        
        let dragBarView = UIView()
        dragBarView.backgroundColor = .systemGray3
        tableViewContainer.addSubview(dragBarView)
        dragBarView.centerX(inView: tableViewContainer, topAnchor: tableViewContainer.topAnchor, paddingTop: 10)
        dragBarView.anchor(width: 40, height: 4)
        dragBarView.layer.cornerRadius = 2                
        
        tableViewContainer.addSubview(addNewPaymentButton)
        addNewPaymentButton.centerX(inView: tableViewContainer, topAnchor: dragBarView.bottomAnchor, paddingTop: 4)
        
        tableViewContainer.addSubview(addTransactionView)
        
        addTransactionView.anchor(top: addNewPaymentButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingRight: 0)
        
        heightConstraint = addTransactionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            heightConstraint!
        ])
        
        tableViewContainer.addSubview(tableView.view)
        tableView.didMove(toParent: self)
        tableView.delegate = self
        tableView.view.anchor(top: addTransactionView.bottomAnchor, left: tableViewContainer.leftAnchor, bottom: tableViewContainer.bottomAnchor, right: tableViewContainer.rightAnchor, paddingTop: 5)
        
        LineDrawer.drawLineFromPoint(start: CGPoint(x: self.view.frame.width-20, y: 0), toPoint: CGPoint(x: self.view.frame.width-20, y: self.view.frame.height), ofColor: UIColor(named: "LineRed")!, inView: tableViewContainer, view: tableLine)
        
        personOwesLabel.text = viewModel.owesOrOwed
        nameLabel.text = viewModel.name
        progressRing.progress = viewModel.progress
        progressLabel.text = IntToCurrency.makeDollars(fromNumber: viewModel.totalDebtFieldText ?? 0)
    }
    
    // MARK: - Actions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        tableView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height-100, right: 0)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func addNewPaymentHandler() {
        addTransactionMode = true
    }
    
    @objc func closeController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleExpand(sender: UIPanGestureRecognizer) {
        let dragView = tableViewContainer
        let translation = sender.translation(in: dragView)
        if sender.state == .began {
        startingConstant = self.topConstraint?.constant
        } else if sender.state == .changed {
            if sender.location(in: self.view).y < progressLabel.center.y + progressLabel.frame.height/2 + 20 && sender.location(in: self.view).y > 10 {
                sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
                topConstraint?.constant = self.topConstraint!.constant + translation.y
            }
        } else if sender.state == .ended {
            if sender.location(in: self.view).y > personOwesLabel.center.y+20 {
                topConstraint?.constant = 30
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self!.view.layoutIfNeeded()
                }
            } else {
                topConstraint?.constant = -progressRing.frame.height-8
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self!.view.layoutIfNeeded()
                }
            }
        }
    }
    
//    MARK: - Add Observers
    
    private func addObservers() {
        tableViewContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleExpand)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}


// MARK: TransactionsTableViewControllerDelegate

extension UserDetailViewController: TransactionsTableViewControllerDelegate {
    func selectedRow() {
        expandTableView()
    }
    
    func deselectedRow() {
        contractTableView()        
    }
    
}

extension UserDetailViewController: HeaderNewTransactionViewDelegate {
    func confirmHandler(amount: Int, description: String, completion: @escaping () -> Void) {
        self.showLoader(true)
        TransactionService.addTransaction(intoSessionId: currentSessionId, withAmount: amount, description: description) { response in
            guard response.error == nil else { return }
            UserService.fetchUserData { response in
                guard response.error == nil else { return }
                SessionViewController.sessions = response.value!
                self.canceledHandler()
                self.viewmodelDelegate?.configureViewmodel()
                completion()
                self.showLoader(false)
            }
        }
    }
    
    func canceledHandler() {
        addTransactionMode = false
    }
    
    func textfieldNumberTooLarge() {
        let ac = UIAlertController(title: "Error", message: "Please enter amount less than 1 billion", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        //self.contributionTextField.text = ""
        present(ac, animated: true)        
    }
    
    
}
