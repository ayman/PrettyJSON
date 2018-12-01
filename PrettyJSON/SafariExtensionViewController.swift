//
//  SafariExtensionViewController.swift
//  PrettyJSON
//
//  Created by David A Shamma on 11/30/18.
//  Copyright © 2018 shaumur.ai. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
