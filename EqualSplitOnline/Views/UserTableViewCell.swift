//
//  UserCell.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 03.01.2022.
//


import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    let personName: TableViewCellTextLabel = {
        let personName = TableViewCellTextLabel()
        personName.textAlignment = .left
        personName.font = UIFont(name: "Avenir Next", size: 22)
        personName.text = "User Name"
        return personName
    }()
    
    let contribution: TableViewCellTextLabel = {
        let contribution = TableViewCellTextLabel()
        contribution.textAlignment = .left
        contribution.font = UIFont(name: "Avenir Next", size: 16)
        contribution.textColor = .secondaryLabel
        contribution.text = "$0.00"
        return contribution
    }()
    
    let debt: TableViewCellTextLabel = {
        let debt = TableViewCellTextLabel()
        debt.textAlignment = .right
        debt.font = UIFont(name: "Avenir Next", size: 22)
        debt.text = "$0.00"
        return debt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .systemBackground
                
        contentView.addSubview(personName)
        contentView.addSubview(contribution)
        contentView.addSubview(debt)
        
        NSLayoutConstraint.activate([
            personName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            personName.bottomAnchor.constraint(equalTo: contribution.topAnchor, constant: 0),
            personName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            personName.trailingAnchor.constraint(lessThanOrEqualTo: self.centerXAnchor, constant: 0),
            
            contribution.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contribution.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            contribution.topAnchor.constraint(greaterThanOrEqualTo: personName.bottomAnchor, constant: 10),
            contribution.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            debt.bottomAnchor.constraint(equalTo: personName.bottomAnchor, constant: 0),
            debt.leadingAnchor.constraint(greaterThanOrEqualTo: centerXAnchor, constant: 0),
            debt.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            debt.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class TableViewCellTextLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name: "Avenir Next", size: 22)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 1/10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
