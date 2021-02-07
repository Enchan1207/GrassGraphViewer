//
//  PreferencesViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/03.
//

import Cocoa

class PreferencesViewController: NSViewController {

    // UI部品
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var fetchStatLabel: NSTextField!
    @IBOutlet weak var loadCircle: NSProgressIndicator!
    @IBOutlet weak var windowListView: NSTableView!
    
    // properties
    private let userdefaults = UserDefaults.standard
    private let application = NSApplication.shared
    private let notificationCenter = NotificationCenter.default
    private let windowManager = WindowManager()
    
    private var currentVisibility: Bool = true
    private var currentContributionWindows: [ContributionWindow] = []
    private var currentSelectedWindow: ContributionWindow?
    
    var isVisible: Bool = false
    
    //* VC lifecycle *//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // windowListView初期化
        self.windowListView.dataSource = self
    }
    
    override func viewWillAppear() {
        self.view.window?.delegate = self
        loadCircle.isHidden = true
        
        // 現在アクティブなウィンドウのリストを表示
        updateWindowListView()
    }
    
    override func viewDidAppear() {
        // 全ウィンドウに表示要求
        notificationCenter.post(name: .kWindowVisibilityModifiedNotification, object: true)
        
        // 表示フラグが立っていなければ表示しない
        // (Rootviewcontrollerとして起動したときに隠すため)
        // TODO: isVisibleをPreferencesで変えられるように
        if(!isVisible){
            self.view.window?.animationBehavior = .none
            self.view.window?.orderOut(self)
            return
        }
        
    }
    
    override func viewWillDisappear() {
        if(isVisible){
            updateConfigurations()
        }
    }
    
    // ウィンドウリストビューを更新
    func updateWindowListView(){
        currentContributionWindows = windowManager.getActiveContributionWindows()
        windowListView.reloadData()
    }
    
    // 変更をUDに反映
    func updateConfigurations(){
        windowManager.updateStoredConfiguration()
    }
}

// UIアクション
extension PreferencesViewController {
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
                        self.updateWindowListView()
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
    
    // ウィンドウリストの項目が選択されたとき
    @IBAction func didSelectRowAt(_ sender: NSTableView){
        let selectedRowIndex = sender.selectedRow
        guard selectedRowIndex != -1 else {return}
        
        // 編集対象を選択した項目のconfigに変更
        self.currentSelectedWindow = self.currentContributionWindows[selectedRowIndex]

        // 右ペインの内容を更新
        guard let selectedConfig = currentSelectedWindow?.getContributionConfig() else {return}
        self.usernameField.stringValue = selectedConfig.userName
        self.fetchStatLabel.stringValue = DateFormatter.localizedString(from: selectedConfig.lastFetchDate, dateStyle: .short, timeStyle: .medium)
    }
    
    // ウィンドウ追加・削除ボタン
    @IBAction func onClickWindowsOperate(_ sender: NSSegmentedControl) {
        let selectedSegment = sender.selectedSegment
        
        switch selectedSegment {
        
        // ウィンドウ追加
        case 0:
            let newConfig = ContributionConfig(userName: "User", lastFetchDate: Date(), contributions: [])
            let newWindow = windowManager.generateContributionWindow(config: newConfig, displayMode: .Foreground)
            let windowController = NSWindowController(window: newWindow)
            windowController.showWindow(self)

        // ウィンドウ削除
        case 1:
            let selectedRow = windowListView.selectedRow
            if selectedRow >= 0{
                self.currentContributionWindows[selectedRow].close()
            }
            
        default:
            fatalError("Invalid segment selected!")
        }
        
        updateWindowListView()
    }
}

// TableViewDataSource
extension PreferencesViewController: NSTableViewDataSource {
    
    // セル数
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.currentContributionWindows.count
    }
    
    // 各項目に表示する内容 ここではconfigからユーザ名を取得して表示
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let config = (self.currentContributionWindows[row].contentViewController as? ContributionViewController)?.config, config.userName != "" else {return "Untitled"}
        return config.userName
    }
}

// NSWindowDelegate
extension PreferencesViewController: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        // ウィンドウを戻し、configを保存
        notificationCenter.post(name: .kWindowVisibilityModifiedNotification, object: false)
        updateConfigurations()
    }
}
