//
//  JoinViewController.swift
//  FlockApp
//
//  Created by Biron Su on 4/12/19.
//

import UIKit

class JoinViewController: UIViewController {
    
    let joinView = JoinView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(joinView)
        joinView.dismissButton.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)
        joinView.sendButton.addTarget(self, action: #selector(dismissPressed), for: .touchUpInside)
    }
    @objc func dismissPressed() {
        dismiss(animated: true)
    }
}
