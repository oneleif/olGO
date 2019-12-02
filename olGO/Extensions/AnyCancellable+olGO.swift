//
//  AnyCancellable+olGO.swift
//  olGO
//
//  Created by Zach Eriksen on 12/2/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import Combine

typealias CancelBag = [AnyCancellable]

extension AnyCancellable {
    func canceled(by: inout CancelBag) {
        by.append(self)
    }
}
