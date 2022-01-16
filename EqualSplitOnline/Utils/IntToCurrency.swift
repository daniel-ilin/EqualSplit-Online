//
//  IntToMoney.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 03.01.2022.
//

import Foundation

struct IntToCurrency {
    static func makeDollars(fromNumber amt: Int) -> String? {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.currencySymbol = "$"
        let amount = Double(amt/100) + Double(amt%100)/100
        return formatter.string(from: NSNumber(value: amount))
    }
}
