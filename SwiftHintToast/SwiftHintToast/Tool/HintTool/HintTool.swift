//
//  HintTool.swift
//  Mara
//
//  Created by 周际航 on 2016/11/28.
//  Copyright © 2016年 com.maramara. All rights reserved.
//
/**
 使用方法，以下两种方式等价：
 1. HintToo.hint("提示")
 2. "提示".ext_hint()
 建议采用第二种方式，可以采用链式方法
 */

import UIKit

// MARK: - 扩展 吐司便利使用方法
extension String {
    @discardableResult
    func ext_hint() -> String {
        HintTool.hint(self)
        return self
    }
}

// MARK: - 扩展 吐司展示任务类
fileprivate class HintTask {
    let id = UUID().uuidString
    var isDismissed = false
    let message: String
    init(_ message: String) {
        self.message = message
    }
}

class HintTool {
    static let shared = HintTool()
    
    fileprivate var hintView: UIView?
    fileprivate var hintTaskArray: [HintTask] = []
    fileprivate var isHinting = false
    
    static func hint(_ message: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            let shared = self.shared
            let task = HintTask(message)
            shared.hintTaskArray.append(task)
            shared.activeHint(task)
        }
    }
}

// MARK: - 扩展 UI展示逻辑控制
private extension HintTool {
    func activeHint(_ newTask: HintTask?) {
        // 0 不再有下一个需要显示的信息时，退出队列
        guard let firstTask = self.hintTaskArray.first else {return}
        
        if let _newTask = newTask {
            // 1 插入新的任务
            if self.hintTaskArray.count == 1 {
                // 1.1 直接开始新任务
                self.showHint(_newTask)
            } else {
                // 1.2 先结束现在的任务，再开始新任务
                if !firstTask.isDismissed {
                    self.dismissHint(interrupted: true, firstTask)
                    return
                }
            }
        } else {
            // 2 处理之前就在队列中的人物
            self.showHint(firstTask)
            if self.hintTaskArray.count > 1 {
                if !firstTask.isDismissed {
                    self.dismissHint(interrupted: true,firstTask)
                }
            }
        }
    }
    
    func showHint(_ hintTask: HintTask) {
        guard let window = UIApplication.shared.delegate?.window else {return}
        self.isHinting = true
        
        let hintView = HintTool.hintView(with: hintTask.message)
        window!.addSubview(hintView)
        window!.bringSubview(toFront: hintView)
        self.hintView = hintView
        
        // 消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            [weak self] in
            if !hintTask.isDismissed {
                self?.dismissHint(interrupted: false ,hintTask)
            }
        }
    }
    
    func dismissHint(interrupted: Bool, _ hintTask: HintTask) {
        hintTask.isDismissed = true
        let alpha: CGFloat = interrupted ? 0.99 : 0.5
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.hintView?.alpha = alpha
            }, completion: { [weak self] (finished) in
                self?.hintView?.removeFromSuperview()
                self?.hintView = nil
                self?.isHinting = false
                self?.hintTaskArray.removeFirst()
                self?.activeHint(nil)
        })
    }
}

// MARK: - 扩展 UI视图相关
private extension HintTool {
    static func hintView(with message: String) -> UIView {
        let minWidth = 180.0
        let maxWidth = 260.0
        let padding = 10.0
        let font = UIFont.systemFont(ofSize: 14)
        
        let messageSize = message.ext_size(withBoundingSize: CGSize(width: maxWidth-2*padding, height: 0) , font: font)
        
        let labelFrame = CGRect(x: 0, y: 0, width: CGFloat(ceilf(Float(messageSize.width))), height: CGFloat(ceilf(Float(messageSize.height))))
        let viewFrame = CGRect(x: 0, y: 0, width: max(minWidth, Double(messageSize.width) + padding*2), height: Double(messageSize.height) + padding*2)
        
        let hintView = UIView()
        hintView.isUserInteractionEnabled = false
        hintView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        hintView.layer.cornerRadius = 8
        hintView.layer.masksToBounds = true
        hintView.frame = viewFrame
        // 控制吐司的位置 正中间偏下
        hintView.center = CGPoint(x: CGFloat(ceilf(Float(UIScreen.main.bounds.size.width*0.5))), y: CGFloat(ceilf(Float(UIScreen.main.bounds.size.height-100.0))))
        
        let hintLabel = UILabel()
        hintView.addSubview(hintLabel)
        hintView.isUserInteractionEnabled = false
        hintLabel.text = message
        hintLabel.textColor = UIColor.white
        hintLabel.textAlignment = .center
        hintLabel.font = font
        hintLabel.preferredMaxLayoutWidth = messageSize.width
        hintLabel.numberOfLines = 0
        hintLabel.frame = labelFrame
        hintLabel.center = CGPoint(x: CGFloat(ceilf(Float(hintView.bounds.size.width*0.5))), y: CGFloat(ceilf(Float(hintView.bounds.size.height*0.5))))
        
        return hintView
    }
}


// MARK: - 扩展 计算文字内容size
private extension String {
    func ext_size(withBoundingSize boundingSize: CGSize, font: UIFont) -> CGSize {
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = [NSFontAttributeName : font]
        let contentSize = self.boundingRect(with: boundingSize, options: option, attributes: attributes, context: nil).size
        return contentSize
    }
}
