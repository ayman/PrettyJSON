//
//  SafariExtensionHandler.swift
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

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    var enabled = false
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("PrettyJson recieved (\(messageName)) from the script in (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
            if messageName == "jsonDisabled" {
                SFSafariApplication.getActiveWindow { (activeWindow) in
                    activeWindow?.getToolbarItem { (toolbarButton) in
                        self.enabled = false
                        toolbarButton?.setImage(NSImage(named: "js-dis.pdf"))
                        toolbarButton?.setEnabled(false)
                    }
                }
            } else if messageName == "jsonOn" || messageName == "jsonOff" {
                SFSafariApplication.getActiveWindow { (activeWindow) in
                    activeWindow?.getToolbarItem { (toolbarButton) in
                        self.enabled = true
                        var iconName = "js-on.pdf"
                        if messageName == "jsonOff" {
                            iconName = "js-off.pdf"
                        }
                        toolbarButton?.setImage(NSImage(named: iconName))
                        toolbarButton?.setEnabled(true)
                    }
                }
            } else {
                // We just echo if we don't know what that was.
                page.dispatchMessageToScript(withName: messageName, userInfo: nil)
            }
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        NSLog("The extension's toolbar item was clicked")
        window.getActiveTab { (activeTab) in
            activeTab?.getActivePage { (activePage) in
                activePage?.dispatchMessageToScript(withName: "toggleJSON", userInfo: nil)
            }
        }
    }

//    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
//        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
//        validationHandler(true, "")
//    }
//
//    override func popoverViewController() -> SFSafariExtensionViewController {
//        return SafariExtensionViewController.shared
//    }
}
