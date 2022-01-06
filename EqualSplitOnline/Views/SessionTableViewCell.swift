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
    
//    MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(sessionName)
        sessionName.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 8)
        
        addSubview(peopleIcon)
        peopleIcon.anchor(top: sessionName.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        addSubview(numberOfUsers)
        numberOfUsers.anchor(top: sessionName.bottomAnchor, left: peopleIcon.rightAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 12)
        
        addSubview(totalMoneyAmount)
        totalMoneyAmount.anchor(top: sessionName.bottomAnchor, left: numberOfUsers.rightAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
