//
//  ViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parser = ContributionXMLParser(userName: "Enchan1207")
        do {
            try parser?.fetchContributions(completion: { (contributions) in
                for contribution in contributions{
                    print(contribution.contributionCount)
                }
            })
        } catch {
            print(error)
        }
            }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
