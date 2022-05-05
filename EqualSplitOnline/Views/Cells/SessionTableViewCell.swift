//
//  SessionTableViewCell.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 02.01.2022.
//

import UIKit

class SessionTableViewCell: UITableViewCell {
    
    //    MARK: - Properties
    
    var sessionName: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Session", attributes: [.font: UIFont.boldSystemFont(ofSize: 20)])
        label.attributedText = attributedString
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var peopleIcon: UIImageView = {
        let iv = UIImageView()
        let color = UIImage.SymbolConfiguration(hierarchicalColor: .black)
        iv.image = UIImage(systemName: "person.2", withConfiguration: color)
        return iv
    }()
    
    var numberOfUsers: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "0", attributes: [.font: UIFont.systemFont(ofSize: 20)])
        label.attributedText = attributedString
        return label
    }()
    
    var totalMoneyAmount: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "$100", attributes: [.font: UIFont.systemFont(ofSize: 20)])
        label.attributedText = attributedString
        return label
    }()
    
    var ownerLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Owner: ", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.secondaryLabel])
        label.attributedText = attributedString
        label.textAlignment = .right
        return label
    }()
    
//    lazy var renameButton: UIButton = {
//        let button = UIButton()
//        let attributedTitle = NSMutableAttributedString(string: "Change Name ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.systemBlue])
//        button.setAttributedTitle(attributedTitle, for: .normal)
//        button.titleLabel?.textAlignment = .left
//        button.isHidden = true
//        button.isEnabled = false
//        button.addTarget(self, action: #selector(renameHandler), for: .touchUpInside)
//        button.isUserInteractionEnabled = true
//        return button
//    }()
//
//    lazy var deleteButton: UIButton = {
//        let button = UIButton()
//        let attributedTitle = NSMutableAttributedString(string: "Delete ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.systemRed])
//        button.setAttributedTitle(attributedTitle, for: .normal)
//        button.titleLabel?.textAlignment = .right
//        button.isHidden = true
//        button.isEnabled = false
//        button.addTarget(self, action: #selector(deleteHandler), for: .touchUpInside)
//        button.isUserInteractionEnabled = true
//        return button
//    }()
    
    var session: Session?
    
    weak var delegate: SessionCellDelegate?
    
    //    MARK: - Actions
//
//    @objc func renameHandler() {
//        delegate?.renameActionHandler(forCell: self)
//    }
//
//    @objc func deleteHandler() {
//        delegate?.deleteActionHandler(forCell: self)
//    }
    
    //    MARK: - Helpers
    
    func configureUI(forSession session: Session) {
        self.session = session
        sessionName.text = session.name
        numberOfUsers.text = "\(session.users.count)"
        totalMoneyAmount.text = IntToCurrency.makeDollars(fromNumber: session.totalSpent())
        let ownerName = findOwnerName(ofSession: session)
        ownerLabel.text?.append(ownerName)                
        
        numberOfUsers.isHidden = false
        totalMoneyAmount.isHidden = false
        peopleIcon.isHidden = false
//        renameButton.isHidden = true
//        deleteButton.isHidden = true
//
//        renameButton.isEnabled = false
//        deleteButton.isEnabled = false
        
        self.contentView.isUserInteractionEnabled = true
        
    }
    
    
    private func findOwnerName(ofSession session: Session) -> String {
        for user in session.users {
            if user.userid == session.ownerid {
                if user.userid == AuthService.activeUser?.id {
                    return "You"
                } else {
                    return user.username
                }
            }
        }
        return ""
    }
    
    //    MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(sessionName)
        sessionName.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 20)
        
        addSubview(peopleIcon)
        peopleIcon.anchor(top: sessionName.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        addSubview(numberOfUsers)
        numberOfUsers.anchor(top: sessionName.bottomAnchor, left: peopleIcon.rightAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 12)
        
        addSubview(totalMoneyAmount)
        totalMoneyAmount.anchor(top: sessionName.bottomAnchor, left: numberOfUsers.rightAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 12)
        
        addSubview(ownerLabel)
        ownerLabel.anchor(top: sessionName.bottomAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 12, paddingRight: 20)
        
//        addSubview(renameButton)
//        renameButton.anchor(left: leftAnchor, bottom: numberOfUsers.bottomAnchor, paddingLeft: 20, paddingBottom: -4)
//        
//        addSubview(deleteButton)
//        deleteButton.anchor(bottom: sessionName.bottomAnchor, right: rightAnchor, paddingBottom: -6, paddingRight: 20)
//
//        NSLayoutConstraint.activate([
//            deleteButton.leadingAnchor.constraint(greaterThanOrEqualTo: sessionName.trailingAnchor, constant: 8)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - SessionCellDelegate

protocol SessionCellDelegate: AnyObject {
    func renameActionHandler(forSession session: Session)
    func deleteActionHandler(forSession session: Session)
    func leaveActionHandler(forSession session: Session)
}
