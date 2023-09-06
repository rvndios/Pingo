//
//  ViewController.swift
//  DemoAPP
//
//  Created by Aravind on 06/09/23.
//

import UIKit
import pingo

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        start()
    }


}
extension ViewController {
    func start() {
        Pingo.ping(hosts: ["google.com", "cnn.com"]) { results in
            print(results)
        }
    }
}

