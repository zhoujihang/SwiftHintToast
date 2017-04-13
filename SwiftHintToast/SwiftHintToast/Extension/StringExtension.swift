//
//  StringExtension.swift
//  Mara
//
//  Created by 周际航 on 2016/11/28.
//  Copyright © 2016年 com.maramara. All rights reserved.
//

import UIKit

// MARK: - 扩展 DEBUG 打印
extension String {
    @discardableResult
    func ext_debugPrint(file: String = #file, function: String = #function, line: Int = #line) -> String{
    #if DEBUG
        let fileName = file.ext_fileNameWithoutDirectory()
        debugPrint("***\(fileName)*** \(function) [line:\(line)] - \(self)")
    #endif
        return self
    }
    
    func ext_fileNameWithoutDirectory() -> String {
        let pathArray: [String] = self.components(separatedBy: "/")
        let fileName = pathArray.last ?? self
        return fileName
    }
}

