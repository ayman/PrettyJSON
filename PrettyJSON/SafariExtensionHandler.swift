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
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
            if messageName == "jsonDisabled" {
                SFSafariApplication.getActiveWindow { (activeWindow) in
                    activeWindow?.getToolbarItem { (toolbarButton) in
                        toolbarButton?.setImage(NSImage(named: "js-dis.pdf"))
                        toolbarButton?.setEnabled(false)
                        SFSafariApplication.setToolbarItemsNeedUpdate()
                    }
                }
                // page.dispatchMessageToScript(withName: "toolbarDisabled", userInfo: nil)
            } else if messageName == "jsonOn" {
                SFSafariApplication.getActiveWindow { (activeWindow) in
                    activeWindow?.getToolbarItem { (toolbarButton) in
                        toolbarButton?.setImage(NSImage(named: "js-on.pdf"))
                        toolbarButton?.setEnabled(true)
                        SFSafariApplication.setToolbarItemsNeedUpdate()
                    }
                }
            } else if messageName == "jsonOff" {
                SFSafariApplication.getActiveWindow { (activeWindow) in
                    activeWindow?.getToolbarItem { (toolbarButton) in
                        toolbarButton?.setImage(nil)
                        toolbarButton?.setEnabled(true)
                        SFSafariApplication.setToolbarItemsNeedUpdate()
                    }
                }
            } else {
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

    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
