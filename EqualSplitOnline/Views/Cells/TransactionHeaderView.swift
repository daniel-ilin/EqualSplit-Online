//
//  TransactionHeaderView.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 08.01.2022.
//

import Foundation
import UIKit

class TransactionHeaderView: UIView {
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        headerLabel.textColor = .systemGray
        headerLabel.sizeToFit()
        return headerLabel
    }()
    
    func getSectionHeaderTitle(atSection section: Int, forPerson person: Person) -> String {
            var tableSectionsNames = [String]()
            if person.owes.count > 0 && person.needs.count == 0 {
                tableSectionsNames = ["Spent", "Owes"]
                
                if person.spent.count == 0 && person.owes.count > 0 {
                    return tableSectionsNames[1]
                } else {
                    return tableSectionsNames[section]
                }
                
            } else if person.needs.count > 0 && person.owes.count == 0 {
                tableSectionsNames = ["Spent", "Owed"]
                
                if person.spent.count == 0 && person.needs.count > 0 {
                    return tableSectionsNames[1]
                } else {
                    return tableSectionsNames[section]
                }
            } else if person.spent.count > 0 && person.owes.count == 0 && person.needs.count == 0 {
                return "Spent"
            }
        return ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(headerLabel)
        headerLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 0, paddingLeft: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
