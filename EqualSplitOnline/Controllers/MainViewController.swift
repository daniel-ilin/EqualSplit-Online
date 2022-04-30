//
//  MainViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 03.01.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    
    // MARK: - Properties
            
    private var startingConstant: CGFloat! //Start position for the gesture transition
    private var topConstraint: NSLayoutConstraint?
    
    private lazy var addUsersMode: Bool = false {
        didSet {
            if addUsersMode == true {
                let image = UIImage(named: "confirm.selection")
                addPersonButton.setImage(image, for: .normal)
                topConstraint?.constant = -(perPersonSpentLabel.center.y - sessionNameLabel.center.y - 5)
                UIView.animate(withDuration: 0.3) {
                    self.tableView.view.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
                    self.tableLine.opacity = 0
                    self.searchTableView.view.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.view.layoutIfNeeded()
                }
//                searchTableView.searchBar?.becomeFirstResponder()
                
            } else {
                let image = UIImage(named: "person.add")
                addPersonButton.setImage(image, for: .normal)
                topConstraint?.constant = 20
                UIView.animate(withDuration: 0.3) {
                    self.searchTableView.view.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
                    self.tableLine.opacity = 0.6
                    self.tableView.view.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.view.layoutIfNeeded()
                }
                self.view.endEditing(true)
            }
        }
    }
    
    private let tableLine = TableLine()
    
    private var backgroundGradient = CAGradientLayer()
    
    private lazy var tableView: UsersTableViewController = {
        let tableView = UsersTableViewController(session: self.activeSession, viewModel: self.viewModel)
        tableView.viewmodelDelegate = self
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        tableView.view.clipsToBounds = true
        tableView.tableView.backgroundColor = .systemBackground
        tableView.view.backgroundColor = .systemBackground
        return tableView
    }()
    
    private lazy var searchTableView: AddUserTableViewController = {
        let tableView = AddUserTableViewController(sessionCode: activeSession.sessioncode)
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        tableView.view.clipsToBounds = true
        tableView.tableView.backgroundColor = .systemBackground
        tableView.view.backgroundColor = .systemBackground
        return tableView
    }()
    
    private var tableViewContainer: UIView = {
        let tableViewContainer = UIView()
        tableViewContainer.backgroundColor = .systemBackground
        tableViewContainer.clipsToBounds = true
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.layer.cornerRadius = 20
        return tableViewContainer
    }()
    
    private lazy var sessionMenuButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "menu.bars")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(backToSessions), for: .touchUpInside)
        return button
    }()
    
    private lazy var addPersonButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "person.add")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(addPersonToSession), for: .touchUpInside)
        return button
    }()
    
    private lazy var sessionNameLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = self.activeSession.name
        titleLabel.font = UIFont(name: "Avenir Next Medium", size: 30)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    private var totalSpentLabel: UILabel = {
        let label = UILabel()
        label.text = "Total spent: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Medium", size: 22)
        label.textColor = .white
        label.alpha = 0.95
        label.textAlignment = .left
        return label
    }()
    
    private var perPersonSpentLabel: UILabel = {
        let label = UILabel()
        label.text = "Per person: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Medium", size: 22)
        label.textColor = .white
        label.alpha = 0.95
        label.textAlignment = .left
        return label
    }()
    
    private lazy var totalSpentAmountLabel: UILabel = {
        let label = UILabel()
        let value = self.activeSession.totalSpent()
        label.text = IntToCurrency.makeDollars(fromNumber: value)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Medium", size: 22)
        label.textColor = .white
        label.alpha = 0.95
        label.textAlignment = .right
        return label
    }()
    
    private lazy var perPersonSpentAmountLabel: UILabel = {
        let label = UILabel()
        let value = self.activeSession.totalSpent()/self.activeSession.users.count
        label.text = IntToCurrency.makeDollars(fromNumber: value)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next Medium", size: 22)
        label.textColor = .white
        label.alpha = 0.95
        label.textAlignment = .right
        return label
    }()
    
    private var activeSession: Session
    var viewModel: SessionViewModel {
        didSet {
            view.pushTransition(0.2)
            
            let value = self.activeSession.totalSpent()/self.activeSession.users.count
            perPersonSpentAmountLabel.text = IntToCurrency.makeDollars(fromNumber: value)
            
            let totalValue = self.activeSession.totalSpent()
            totalSpentAmountLabel.text = IntToCurrency.makeDollars(fromNumber: totalValue)
            
            tableView.viewModel = viewModel
        }
    }
    
    // MARK: - Lifecycle
    
    init(session: Session) {
        activeSession = session
        viewModel = Calculator.findOwersNeeders(inSession: activeSession)
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
        GradientMaker.setGradientBackground(in: self.view, withGradient: backgroundGradient)

        navigationController?.isNavigationBarHidden = true
    }
    
    func updateTableView() {
        tableView.tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
               
        viewModel = Calculator.findOwersNeeders(inSession: activeSession)
        
        view.addSubview(sessionMenuButton)
        sessionMenuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 14, paddingLeft: 20, width: 30, height: 30)
        
        view.addSubview(addPersonButton)
        addPersonButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 14, paddingRight: 20, width: 30, height: 30)
        
        view.addSubview(sessionNameLabel)
        sessionNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: sessionMenuButton.rightAnchor, right: addPersonButton.leftAnchor, paddingTop: 14, paddingLeft: 14, paddingRight: 14)
        
        view.addSubview(totalSpentLabel)
        totalSpentLabel.anchor(top: sessionMenuButton.bottomAnchor, left: view.leftAnchor, paddingTop: 28, paddingLeft: 14)
        
        view.addSubview(perPersonSpentLabel)
        perPersonSpentLabel.anchor(top: totalSpentLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 14)
        
        view.addSubview(totalSpentAmountLabel)
        totalSpentAmountLabel.anchor(top: sessionMenuButton.bottomAnchor, left: totalSpentLabel.rightAnchor, right: view.rightAnchor, paddingTop: 28, paddingLeft: 20, paddingRight: 14)
        
        view.addSubview(perPersonSpentAmountLabel)
        perPersonSpentAmountLabel.anchor(top: totalSpentAmountLabel.bottomAnchor, left: perPersonSpentLabel.rightAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 14)
        
        view.addSubview(tableViewContainer)
        tableViewContainer.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        topConstraint = tableViewContainer.topAnchor.constraint(equalTo: perPersonSpentLabel.bottomAnchor, constant: 20)
        
        NSLayoutConstraint.activate([
            topConstraint!
        ])
                
        let dragBarView = UIView()
        dragBarView.backgroundColor = .systemGray3
        tableViewContainer.addSubview(dragBarView)
        dragBarView.centerX(inView: tableViewContainer, topAnchor: tableViewContainer.topAnchor, paddingTop: 10)
        dragBarView.anchor(width: 40, height: 4)
        dragBarView.layer.cornerRadius = 2
        
        tableViewContainer.addSubview(tableView.view)
        tableView.didMove(toParent: self)
        tableView.delegate = self
        tableView.view.anchor(top: dragBarView.bottomAnchor, left: tableViewContainer.leftAnchor, bottom: tableViewContainer.bottomAnchor, right: tableViewContainer.rightAnchor, paddingTop: 5)
        
        tableViewContainer.addSubview(searchTableView.view)
        searchTableView.didMove(toParent: self)
        searchTableView.delegate = self
        searchTableView.view.anchor(top: dragBarView.bottomAnchor, left: tableViewContainer.leftAnchor, bottom: tableViewContainer.bottomAnchor, right: tableViewContainer.rightAnchor, paddingTop: 5)
        self.searchTableView.view.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        
        LineDrawer.drawLineFromPoint(start: CGPoint(x: self.view.frame.width-20, y: 0), toPoint: CGPoint(x: self.view.frame.width-20, y: self.view.frame.height), ofColor: UIColor(named: "LineRed")!, inView: tableViewContainer, view: tableLine)
    }
    
    // MARK: - Actions
    
    @objc func backToSessions() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addPersonToSession() {
        addUsersMode.toggle()
    }
    
    @objc func handleExpand(sender: UIPanGestureRecognizer) {
        let dragView = self.view
        let translation = sender.translation(in: dragView)
        if sender.state == .began {
        startingConstant = self.topConstraint?.constant
        } else if sender.state == .changed {
            if sender.location(in: self.view).y < perPersonSpentLabel.center.y + perPersonSpentLabel.frame.height/2 + 20 && sender.location(in: self.view).y > 10 {
                sender.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
                topConstraint?.constant = self.topConstraint!.constant + translation.y
            }
        } else if sender.state == .ended {
            if sender.location(in: self.view).y > totalSpentLabel.center.y+20 {
                topConstraint?.constant = 20
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self!.view.layoutIfNeeded()
                }
            } else {
                topConstraint?.constant = -(perPersonSpentLabel.center.y - sessionNameLabel.center.y - 5)
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self!.view.layoutIfNeeded()
                }
            }
        }
    }
    
//    MARK: - Add Observers
    
    private func addObservers() {
        let tap: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleExpand))
        tap.delegate = self
        tableViewContainer.addGestureRecognizer(tap)
    }    
}

// MARK: - PushTransition Animation

extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.subtype = CATransitionSubtype.fromTop
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}


// MARK: - Dark Mode UI Setup

extension MainViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        backgroundGradient.removeFromSuperlayer()
        GradientMaker.setGradientBackground(in: self.view, withGradient: backgroundGradient)
        tableLine.changeColor(to: "LineRed")
    }
}

// MARK: - UsersTableViewControllerDelegate

extension MainViewController: UsersTableViewControllerDelegate {
    func delegateAction() {
        
    }
}

// MARK: - AddUserTableViewControllerDelegate

extension MainViewController: AddUserTableViewControllerDelegate {
    func delegateAddUserAction() {
        
    }
}

// MARK: - TransactionTableViewViewModelDelegate

extension MainViewController: TransactionTableViewViewModelDelegate {
    func configureViewmodel() {
        let sessions = SessionViewController.sessions
        var matchFound = false
        for session in sessions {
            if session.id == activeSession.id {
                activeSession = session
                matchFound = true
            }
        }
        if matchFound == false {
            navigationController?.popViewController(animated: true)
            return
        }
        viewModel = Calculator.findOwersNeeders(inSession: activeSession)
    }
}

//  MARK: - UIGestureRecognizerDelegate

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        let velocity = panRecognizer.velocity(in: panRecognizer.view)
        if (abs(velocity.x) > abs(velocity.y)) {
            return true
        }
        return false
    }
}
