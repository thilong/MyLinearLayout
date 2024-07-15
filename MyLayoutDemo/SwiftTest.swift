//
//  SwiftTest.swift
//  MyLayoutDemo
//
//  Created by Aidoo on 2024/7/16.
//  Copyright © 2024 YoungSoft. All rights reserved.
//

import Foundation
import MyLayout

func test1(){
    let ll = MyLinearLayout()
    ll.myWidth = 12
    ll.leadingPos.myEqual(to: 12).myOffset(12)
}
