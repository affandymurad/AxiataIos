//
//  BaseViewController.swift
//  axiata
//
//  Created by docotel on 15/10/20.
//  Copyright © 2020 Affandy Murad. All rights reserved.
//

import UIKit

protocol ApplicationStateDelegate{
    func appWillForeground()
    func appWillBackground()
}

class BaseViewController<T: PresenterCommonDelegate>: UIViewController{
    var presenter: T!
    var stateDelegate: ApplicationStateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
