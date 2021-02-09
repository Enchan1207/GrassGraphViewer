//
//  PreferenceSplitViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/08.
//

import Cocoa

class PreferenceSplitViewController: NSSplitViewController, Subject {
    private let windowManager = WindowManager()
    private var contributionWindows: [ContributionWindow] = []
    private var currentContributionWindow: ContributionWindow? = nil
    var observers: [Observer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear() {
        self.contributionWindows = windowManager.getActiveContributionWindows()
        notify(self.contributionWindows)
    }
    
    // WindowListViewControllerにより呼ばれる
    func windowDidSelect(_ at: Int){
        guard (0..<self.contributionWindows.count).contains(at) else {return}
        self.currentContributionWindow = self.contributionWindows[at]
        notify(self.currentContributionWindow!)
    }
    
    func windowAddRequired(){
        let newConfig = ContributionConfig(userName: "User", lastFetchDate: Date(), contributions: [])
        let newWindow = windowManager.generateContributionWindow(config: newConfig, displayMode: .Foreground)
        let windowController = NSWindowController(window: newWindow)
        windowController.showWindow(self)
        self.contributionWindows = windowManager.getActiveContributionWindows()
        notify(self.contributionWindows)
    }
    
    func windowRemoveRequired(_ at: Int){
        guard (0..<self.contributionWindows.count).contains(at) else {return}
        self.contributionWindows[at].close()
        notify(self.contributionWindows)
    }

}
