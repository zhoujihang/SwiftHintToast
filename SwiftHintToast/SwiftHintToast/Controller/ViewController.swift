//
//  ViewController.swift
//  SwiftHintToast
//
//  Created by 周际航 on 2017/4/13.
//  Copyright © 2017年 com.maramara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

// MARK: - 扩展 UI
private extension ViewController {
    func setup() {
        self.setupView()
        self.setupConstraints()
    }
    
    func setupView() {
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = UIColor.clear
    }
    
    func setupConstraints() {
        self.tableView.frame = UIScreen.main.bounds
    }
}

// MARK: - 扩展 UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) ?? UITableViewCell(style: .default, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        
        var title = "\(indexPath.section) - \(indexPath.row)"
        
        if indexPath.row == 0 {
            title = "测试 - 短吐司弹窗一次"
        } else if indexPath.row == 1 {
            title = "测试 - 长吐司弹窗一次"
        } else if indexPath.row == 2 {
            title = "测试 - 吐司弹窗连续弹出5个信息"
        }
        
        cell.textLabel?.text = title
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.test0()
        } else if indexPath.row == 1 {
            self.test1()
        } else if indexPath.row == 2 {
            self.test2()
        }
    }
}

// MARK: - 扩展 点击事件
private extension ViewController {
    // 测试 - 短吐司弹窗一次，2s
    func test0() {
        HintTool.hint("这是🍞")
    }
    
    // 测试 - 长吐司弹窗一次，2s
    func test1() {
        "蒹葭苍苍，白露为霜。所谓伊人，在水一方。溯洄从之，道阻且长。溯游从之，宛在水中央。蒹葭萋萋，白露未晞。所谓伊人，在水之湄。溯洄从之，道阻且跻。溯游从之，宛在水中坻。蒹葭采采，白露未已。所谓伊人，在水之涘。溯洄从之，道阻且右。溯游从之，宛在水中沚。".ext_hint().ext_debugPrint()
    }
    
    // 测试 - 吐司弹窗连续弹出5个不同信息，除了最后一个信息显示2s外，中间被打断的信息只显示0.5s
    func test2() {
        "这是🍞".ext_hint()
        "这是🍎".ext_hint()
        "这是🍒".ext_hint()
        "这是🍉".ext_hint()
        "今日拼盘如上！".ext_hint()
    }
    
}

