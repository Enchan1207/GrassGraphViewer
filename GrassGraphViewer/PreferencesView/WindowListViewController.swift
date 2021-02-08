//
//  WindowListViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/03.
//

import Cocoa

class WindowListViewController: NSViewController {

    // UI部品
    @IBOutlet weak var windowListView: NSTableView!
    
    // properties
    private let userdefaults = UserDefaults.standard
    private let application = NSApplication.shared
    private let notificationCenter = NotificationCenter.default
    private let windowManager = WindowManager()
    
    private var currentVisibility: Bool = true
    private var currentContributionWindows: [ContributionWindow] = []
    
    var isVisible: Bool = false
    
    //* VC lifecycle *//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // windowListView初期化
        self.windowListView.dataSource = self
        
    }
    
    override func viewWillAppear() {
        self.view.window?.delegate = self
        
        // 現在アクティブなウィンドウのリストを表示
        updateWindowListView()
    }
    
    override func viewDidAppear() {
        // 全ウィンドウに表示要求
        notificationCenter.post(name: .kWindowVisibilityModifiedNotification, object: true)
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
extension WindowListViewController {
    
    // ウィンドウリストの項目が選択されたとき
    @IBAction func didSelectRowAt(_ sender: NSTableView){
        let selectedRowIndex = sender.selectedRow
        guard selectedRowIndex != -1 else {return}
        
        
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
extension WindowListViewController: NSTableViewDataSource {
    
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
extension WindowListViewController: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        // ウィンドウを戻し、configを保存
        notificationCenter.post(name: .kWindowVisibilityModifiedNotification, object: false)
        updateConfigurations()
    }
}
