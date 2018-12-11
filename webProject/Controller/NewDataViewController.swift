//
//  NewDataViewController.swift
//  webProject
//
//  Created by Roberto Evangelista on 11/12/18.
//  Copyright © 2018 Roberto Evangelista da Silva Filho. All rights reserved.
//

import UIKit

class NewDataViewController: UIViewController {

    @IBAction func didTapCancelButon(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var dataTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
