//
//  WindowDetailsViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/07.
//

import Cocoa

class WindowDetailsViewController: NSViewController{
    // UI部品
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var fetchStatLabel: NSTextField!
    @IBOutlet weak var loadCircle: NSProgressIndicator!
    
    private var currentSelectedWindow: ContributionWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear() {
        loadCircle.isHidden = true
    }
    
    
    @objc func onUpdateRequired(){
        // 編集対象を選択した項目のconfigに変更
//        self.currentSelectedWindow = self.currentContributionWindows[selectedRowIndex]
//
//        // 右ペインの内容を更新
//        guard let selectedConfig = currentSelectedWindow?.getContributionConfig() else {return}
//        self.usernameField.stringValue = selectedConfig.userName
//        self.fetchStatLabel.stringValue = DateFormatter.localizedString(from: selectedConfig.lastFetchDate, dateStyle: .short, timeStyle: .medium)
    }
}

// UIアクション
extension WindowDetailsViewController {
    // ユーザ名フィールドに入力があったとき
    @IBAction func onChangeUsernameField(_ sender: NSTextField) {
        // 入力値を取得し、編集対象のconfigと違うならフェッチしてみる
        let newName = sender.stringValue
        
        if(newName != currentSelectedWindow?.getContributionConfig()?.userName){
            fetchStatLabel.stringValue = "Fetching..."
            loadCircle.startAnimation(nil)
            loadCircle.isHidden = false

            let parser = ContributionXMLParser(userName: newName)
            do {
                try parser?.fetchContributions(completion: { (contributions) in
                    // 成功したら新しいConfigを生成し
                    let newConfig = ContributionConfig(userName: newName, lastFetchDate: Date(), contributions: contributions)

                    // 対象のウィンドウにConfigに乗っけて通知
                    let postObject = (self.currentSelectedWindow?.windowIdentifier, newConfig)
                    NotificationCenter.default.post(name: .kConfigModifiedNotification, object: postObject)
                    
                    // んでUIを更新
                    DispatchQueue.main.async {
                        self.loadCircle.stopAnimation(nil)
                        self.loadCircle.isHidden = true
                        self.fetchStatLabel.stringValue = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    }
                })
            } catch {
                fetchStatLabel.stringValue = "Failed! Please check if you typed valid name."
                loadCircle.stopAnimation(nil)
                loadCircle.isHidden = true
                return
            }
        }
    }
}
