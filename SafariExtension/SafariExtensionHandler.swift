//
//  SafariExtensionHandler.swift
//  PrettyJSON
//
//  Created by David A Shamma on 11/30/18.
//  Copyright © 2018 shaumur.ai. All rights reserved.
//
// https://developer.apple.com//safari/extensions/submission/

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    var enabled = false
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
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
                page.dispatchMessageToScript(withName: messageName, userInfo: nil)
            }
            // SFSafariApplication.setToolbarItemsNeedUpdate()
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
//        validationHandler(self.enabled, "")
//    }
    
//    override func popoverViewController() -> SFSafariExtensionViewController {
//        return SafariExtensionViewController.shared
//    }
}
