//
//  reserveTableViewController.swift
//  Table
//
//  Created by ADMIN on 06/01/2020.
//  Copyright © 2020 ADMIN. All rights reserved.
//

import UIKit

class reserveTableViewController: UITableViewController {
    
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var labeldate: UILabel!
    
    @IBAction func reserveAction(_ sender: Any) {

        if changeLabel.text == "" || labeldate.text == "" {
                let alertControllerr = UIAlertController(title: "Внимание", message: "Заполните все поля", preferredStyle: .alert)
                let actiont = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertControllerr.addAction(actiont)
                self.present(alertControllerr, animated: true, completion: nil)
            } else {
            let alertController = UIAlertController(title: "Заказ", message: "Ваш заказ оформлен на \(changeLabel.text ?? "нет заказа") человекa, \(labeldate.text ?? "no")", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.performSegue(withIdentifier: "mapCloseSegue", sender: sender)
                    }
            )
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            }
        }
    
    
    @IBAction func datec(_ sender: UIDatePicker) {
        
        let dateFOrmatter = DateFormatter()
        dateFOrmatter.dateStyle = .full
        dateFOrmatter.timeStyle = .short
        dateFOrmatter.locale = Locale.init(identifier: "RU")
        let dateValue = dateFOrmatter.string(from: sender.date)
        labeldate.text = dateValue
        
    }
    
    
    
    @IBAction func changed(_ sender: Any) {
        
        changeLabel.text = "\(Int(stepper.value))"
    }
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Внимание", message: "Вы хотите отменить и перейти на главную страницу?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Да", style: .default, handler: { (action) in
        self.performSegue(withIdentifier: "closeTheHome", sender: sender)
        })
        let actionNo = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        alertController.addAction(actionNo)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        labeldate.isHidden = true
    }
    
}


