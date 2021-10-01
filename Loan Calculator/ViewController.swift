//
//  ViewController.swift
//  Loan Calculator
//
//  Created by Noah Glaser on 9/29/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var monthYearSegmentControl: UISegmentedControl!
    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var monthlyPaymentLabel: UILabel!
    @IBOutlet weak var totalPaidLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var interestPaidLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPaidLabel.isHidden = true
        interestPaidLabel.isHidden = true
        monthlyPaymentLabel.isHidden = true
    }


    @IBAction func onCalc(_ sender: Any) {
        let amountText = amountTextField.text
        let interestText = interestTextField.text
        let termText = termTextField.text
        
        if termText == nil || amountText == nil || interestText == nil {
            return
        }
        
        if let term = Double(termText!) {
            if let interest = Double(interestText!) {
                if let amount = Double(amountText!) {
                    if let selectedIndex = monthYearSegmentControl?.selectedSegmentIndex {
                        // have to turn interest into a decimal
                        let interestRate = interest / 100
                        // if years are selected change it to months
                        let months = selectedIndex == 0 ? term : term * 12
                        
                        // Calculated values
                        let monthlyPayment = monthlyPayment(loan: amount, interest: interestRate, term: months)
                        let interestedPaid = interestPaid(loan: amount, interest: interestRate, term: months)
                        let totalPaid = totalPaid(loan: amount, interest: interestRate, term: months)
                        
                        // Formatted Values
                        let formattedMonthlyPayments = NumberFormatter.localizedString(from: NSNumber(value: monthlyPayment), number: .currency)
                        let formattedInterestPayment = NumberFormatter.localizedString(from: NSNumber(value: interestedPaid), number: .currency)
                        let formattedTotalPaid = NumberFormatter.localizedString(from: NSNumber(value: totalPaid), number: .currency)
                        
                        monthlyPaymentLabel.text = "Monthly: \(formattedMonthlyPayments)"
                        interestPaidLabel.text = "Interest: \(formattedInterestPayment)"
                        totalPaidLabel.text = "Total: \(formattedTotalPaid)"

                        totalPaidLabel.isHidden = false
                        interestPaidLabel.isHidden = false
                        monthlyPaymentLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    // https://www.calculatorsoup.com/calculators/financial/loan-calculator.php

    func monthlyPayment(loan: Double, interest: Double, term: Double) -> Double {
        
        let i = interest / 12
        let PV = loan
        let n = term
        
        return (PV * i * pow((1 + i), n)) / (pow((1 + i), n) - 1)
    }

    func interestPaid(loan: Double, interest: Double, term: Double) -> Double {
        
        return monthlyPayment(loan: loan, interest: interest, term: term) * term - loan
    }

    func totalPaid(loan: Double, interest: Double, term: Double) -> Double {
        return monthlyPayment(loan: loan, interest: interest, term: term) * term
    }
}

