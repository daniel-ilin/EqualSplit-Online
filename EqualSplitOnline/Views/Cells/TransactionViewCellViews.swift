//
//  TransactionViewCellViews.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 15.01.2022.
//

import Foundation
import UIKit

// MARK: - TransactionCollapsedCellView

final class TransactionCollapsedCellView: UIView {
    
    // MARK: - Properties
    
    var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "Avenir Next", size: 20)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.textAlignment = .left
        descriptionLabel.minimumScaleFactor = 1/10
        return descriptionLabel
    }()
    
    var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "Avenir Next", size: 16)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textAlignment = .left
        dateLabel.textColor = .secondaryLabel
        dateLabel.minimumScaleFactor = 1/10
        return dateLabel
    }()
    
    var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        moneyLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
        moneyLabel.adjustsFontSizeToFitWidth = true
        moneyLabel.textAlignment = .right
        moneyLabel.minimumScaleFactor = 1/10
        return moneyLabel
    }()
    
    private let containerView = UIStackView()
    private let cellView = UIView()
    private let detailView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let contentView = self
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(moneyLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: dateLabel.topAnchor, constant: 0),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: centerXAnchor, constant: 0),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
//            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            moneyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: centerXAnchor, constant: 0),
            moneyLabel.bottomAnchor.constraint(greaterThanOrEqualTo: dateLabel.topAnchor, constant: 0),
            moneyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            moneyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //    MARK: - CellSetup
    
    func uiSetup(at indexPath: IndexPath, withViewModel viewModel: Person) {
        let person = viewModel
        let cell = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let moneyFonts = [UIFont(name: "Avenir Next", size: 20), UIFont(name: "Avenir Next Medium", size: 20)]
        var tableSectionsData = [[CalculatorTransaction]]()
        var textColor: UIColor!
        var plusOrMinus: String!
        var toOrFrom: String!
        var endPerson: String!
        if person.owes.count > 0 {
            tableSectionsData = [person.spent, person.owes]
            textColor = UIColor(named: "Red")
            plusOrMinus = "-"
            toOrFrom = "to"
            if tableSectionsData[indexPath.section].count < indexPath.row+1 {
                endPerson = ""
            } else {
                endPerson = tableSectionsData[indexPath.section][indexPath.row].receiver
            }
        } else if person.needs.count > 0 {
            tableSectionsData = [person.spent, person.needs]
            textColor = UIColor(named: "Green")
            plusOrMinus = "+"
            toOrFrom = "from"
            if tableSectionsData[indexPath.section].count < indexPath.row+1 {
                endPerson = ""
            } else {
                endPerson = tableSectionsData[indexPath.section][indexPath.row].sender
            }
        } else {
            tableSectionsData = [person.spent, person.needs]
            textColor = UIColor(named: "Green")
            plusOrMinus = "+"
            toOrFrom = "from"
            endPerson = ""
        }
        
        let spentCount = tableSectionsData[0].count
        let owesOrNeedsCount = tableSectionsData[1].count
        
        if spentCount > 0 && owesOrNeedsCount == 0 {
            
            cell.moneyLabel.font = moneyFonts[0]
            cell.moneyLabel.textColor = UIColor.label
            cell.moneyLabel.text = "\(IntToCurrency.makeDollars(fromNumber: tableSectionsData[0][indexPath.row].amount) ?? "Error")"
            cell.descriptionLabel.text = "\(tableSectionsData[0][indexPath.row].transacDescription ?? "")"
            
            cell.dateLabel.text = dateFormatter.string(from: tableSectionsData[0][indexPath.row].date)
            
        } else if spentCount == 0 && owesOrNeedsCount > 0 {
            cell.moneyLabel.font = moneyFonts[1]
            cell.moneyLabel.textColor = textColor
            cell.moneyLabel.text = plusOrMinus + "\(IntToCurrency.makeDollars(fromNumber: tableSectionsData[1][indexPath.row].amount) ?? "Error")"
            cell.descriptionLabel.text = "\(tableSectionsData[1][indexPath.row].transacDescription ?? "to \(tableSectionsData[1][indexPath.row].receiver)")"
            cell.dateLabel.text = ""
        } else if spentCount > 0 && owesOrNeedsCount > 0 {
            cell.moneyLabel.font = moneyFonts[indexPath.section]
            if indexPath.section == 0 {
                cell.moneyLabel.textColor = UIColor.label
                cell.moneyLabel.text = "\(IntToCurrency.makeDollars(fromNumber: tableSectionsData[indexPath.section][indexPath.row].amount) ?? "Error")"
                
                
                cell.descriptionLabel.text = tableSectionsData[indexPath.section][indexPath.row].transacDescription ?? toOrFrom + " \(endPerson!)"
                                                                
                cell.dateLabel.text = dateFormatter.string(from: tableSectionsData[0][indexPath.row].date)
            } else {
                cell.moneyLabel.textColor = textColor
                cell.moneyLabel.text = plusOrMinus + "\(IntToCurrency.makeDollars(fromNumber: tableSectionsData[indexPath.section][indexPath.row].amount) ?? "Error")"
                
                
                cell.descriptionLabel.text = tableSectionsData[indexPath.section][indexPath.row].transacDescription ?? toOrFrom + " \(endPerson!)"
                
                
                cell.dateLabel.text = ""
            }
        } else {
            cell.moneyLabel.text = "\(IntToCurrency.makeDollars(fromNumber: tableSectionsData[indexPath.section][indexPath.row].amount) ?? "Error") to \(tableSectionsData[indexPath.section][indexPath.row].receiver)"
            cell.descriptionLabel.text = "\(tableSectionsData[indexPath.section][indexPath.row].transacDescription ?? "to \(tableSectionsData[1][indexPath.row].receiver)")"
        }
    }
}








// MARK: - TransactionExpandedCellView

final class TransactionExpandedCellView: UIView {
    
    init(frame: CGRect, newTransaction: Bool) {
        self.isNewTransaction = newTransaction
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Properties
    
    private var isNewTransaction = false
    
    weak var delegate: ExpandedCellViewDelegate?
    weak var headerDelegate: HeaderNewTransactionViewDelegate?
    
    private let title = UILabel()
    
    lazy var moneyField: UITextField = {
        let tf = CustomTextField(placeholder: "$0.00")
        tf.outline.isHidden = true
        tf.setHeight(40)
        tf.delegate = self
        tf.layer.borderColor = UIColor.clear.cgColor
        tf.layer.borderWidth = 0
        tf.backgroundColor = .secondarySystemBackground
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 8
        tf.layer.masksToBounds = true
        tf.clearButtonMode = .whileEditing
        tf.font = UIFont(name: "Avenir Next", size: 20)
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    private let descriptionField: UITextField = {
        let tf = CustomTextField(placeholder: "Description")
        tf.outline.isHidden = true
        tf.setHeight(40)
        tf.layer.borderColor = UIColor.clear.cgColor
        tf.layer.borderWidth = 0
        tf.backgroundColor = .secondarySystemBackground
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 8
        tf.layer.masksToBounds = true
        tf.clearButtonMode = .whileEditing
        tf.font = UIFont(name: "Avenir Next", size: 20)
        tf.keyboardType = .default
        return tf
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = AnimatedButton()
        button.backgroundColor = .systemGray4
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.tintColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancelChangesHandler), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = AnimatedButton()
        button.backgroundColor = UIColor(named: "ButtonBlue")
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.tintColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(confirmChangesHandler), for: .touchUpInside)
        return button
    }()
    
    private var moneyAmount: Int = 0
    private var baseAmount: Int = 0
    
    private var tableSectionsData = [[CalculatorTransaction]]()
    private var currentIndexPath: IndexPath?
    
    //    MARK: - Actions
    
    @objc func confirmChangesHandler() {
        
        
        if isNewTransaction {
            
            guard moneyField.text != "" else { return }
//            if descriptionField.text == "" { descriptionField.text = " " }
            let amount = moneyAmount
            let description = descriptionField.text
            headerDelegate?.confirmHandler(amount: amount, description: description ?? "") { [weak self] in
                self?.descriptionField.text = ""
                self?.moneyAmount = 0
                self?.moneyField.text = ""
            }
        } else {
            guard currentIndexPath != nil else { return }
            guard moneyField.text != "" else { return }
//            if descriptionField.text == "" { descriptionField.text = " " }
            guard let id = tableSectionsData[currentIndexPath!.section][currentIndexPath!.row].id else { return }            
            let amount = moneyAmount
            let description = descriptionField.text
            delegate?.confirmHandler(id: id, amount: amount, description: description ?? "")
        }
    }
    
    @objc func cancelChangesHandler() {
        if isNewTransaction {
            self.descriptionField.text = ""
            self.moneyAmount = 0
            self.moneyField.text = ""
            headerDelegate?.canceledHandler()
        } else {
            delegate?.canceledHandler()
        }
    }
    
    //    MARK: - Helpers
    
    func uiSetup(at indexPath: IndexPath, withViewModel viewModel: Person) {
        currentIndexPath = indexPath        
        let person = viewModel
        
        if person.owes.count > 0 {
            tableSectionsData = [person.spent, person.owes]
        } else if person.needs.count > 0 {
            tableSectionsData = [person.spent, person.needs]
        } else {
            tableSectionsData = [person.spent, person.needs]
        }
        
        let spentCount = tableSectionsData[0].count
        let owesOrNeedsCount = tableSectionsData[1].count
        var description = ""
        
        if spentCount > 0 && owesOrNeedsCount == 0 {
            moneyAmount = tableSectionsData[0][indexPath.row].amount
            description = tableSectionsData[0][indexPath.row].transacDescription
                        
        } else if spentCount == 0 && owesOrNeedsCount > 0 {
            moneyAmount = tableSectionsData[1][indexPath.row].amount
        } else if spentCount > 0 && owesOrNeedsCount > 0 {
            if indexPath.section == 0 {
                moneyAmount = tableSectionsData[indexPath.section][indexPath.row].amount
                description = tableSectionsData[indexPath.section][indexPath.row].transacDescription
            } else {
                moneyAmount = tableSectionsData[indexPath.section][indexPath.row].amount
            }
        } else {
            moneyAmount = tableSectionsData[indexPath.section][indexPath.row].amount
            description = tableSectionsData[indexPath.section][indexPath.row].transacDescription
        }
        
        baseAmount = moneyAmount
        moneyField.text = IntToCurrency.makeDollars(fromNumber: moneyAmount)
        descriptionField.text = description
    }
    
    func commonInit() {
        let stack = UIStackView(arrangedSubviews: [moneyField, descriptionField])
        stack.axis = .vertical
        stack.spacing = 10
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 20, paddingRight: 32)
        
        addSubview(cancelButton)
        addSubview(confirmButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.5),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: 0),
            confirmButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 10),
            confirmButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor)
        ])
    }
}


protocol ExpandedCellViewDelegate: AnyObject {
    func canceledHandler()
    func confirmHandler(id: String, amount: Int, description: String)
    func textfieldNumberTooLarge()
}

protocol HeaderNewTransactionViewDelegate: AnyObject {
    func canceledHandler()
    func confirmHandler(amount: Int, description: String, completion: @escaping ()->Void)
    func textfieldNumberTooLarge()
}

extension TransactionExpandedCellView: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        moneyAmount = 0
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {        
        if let digit = Int(string) {
            moneyAmount = moneyAmount * 10 + digit
            if moneyAmount > 1_000_000_000_00 {
                delegate?.textfieldNumberTooLarge()
                headerDelegate?.textfieldNumberTooLarge()
                moneyAmount = baseAmount
            }
            moneyField.text = IntToCurrency.makeDollars(fromNumber: moneyAmount)
        }
        if string == "" {
            moneyAmount = moneyAmount / 10
            moneyField.text = moneyAmount == 0 ? "" : IntToCurrency.makeDollars(fromNumber: moneyAmount)
        }
        return false
    }
}
