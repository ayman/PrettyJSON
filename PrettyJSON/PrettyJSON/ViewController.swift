//
//  ViewController.swift
//  PrettyJSON for Safari
//  
//  Created by David A Shamma on 12/10/18.
//  
//  This file is part of the PrettyJSON for Safari distribution.
//  Copyright (c) 2020 David A. Shamma
//  https://github.com/ayman/PrettyJSON/
//  https://shamur.ai/bin/PrettyJSON/
//  
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//  
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import Cocoa
import SafariServices.SFSafariApplication

class ViewController: NSViewController {

    @IBOutlet var appNameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appNameLabel.stringValue = "PrettyJSON for Safari";
    }
    
    @IBAction func openAboutURL(_ sender: Any) {
        let url = URL(string: "https://shamur.ai/bin/prettyJSON/")!
        if NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    
    @IBAction func openSafariExtensionPreferences(_ sender: AnyObject?) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "ai.shamur.bin.PrettyJSON.SafariExtension") { error in
            if let _ = error {
                print("couldnt open safari extensions")
            }
        }
    }

}
