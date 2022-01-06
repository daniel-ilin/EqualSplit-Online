//
//  AddOfflineUserCell.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 05.01.2022.
//

import Foundation
import UIKit

class AddOfflineUserCell: UITableViewCell {
    
    //    MARK: - Properties
    
    var addUserButtonAction : (() -> ())?
    
    private var cellTitle: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Add an offline user", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.label])
        
        let backgroundAtts: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.secondaryLabel]
        attributedString.append(NSAttributedString(string: "\n (can be edited by anyone)", attributes: backgroundAtts))
        
        
        label.attributedText = attributedString
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var sessionNumber: UIButton = {
        let label = HighlightButton()
        let attributedString = NSMutableAttributedString(string: "Add Offline User", attributes: [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.systemBlue])
        label.setAttributedTitle(attributedString, for: .normal)
        label.titleLabel?.adjustsFontSizeToFitWidth = true
        label.addTarget(self, action: #selector(AddButtonTapped), for: .touchUpInside)
        label.isUserInteractionEnabled = true
        return label
    }()
    
//    MARK: - Actions
    
    @objc func AddButtonTapped() {
        addUserButtonAction?()
    }
    
    //    MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.isUserInteractionEnabled = false
        
        addSubview(cellTitle)
        cellTitle.centerX(inView: self, topAnchor: topAnchor, paddingTop: 40)
        cellTitle.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 40, paddingRight: 40)
        
        addSubview(sessionNumber)
        sessionNumber.centerX(inView: self, topAnchor: cellTitle.bottomAnchor, paddingTop: 8)
        sessionNumber.anchor(bottom: self.bottomAnchor, paddingBottom: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
