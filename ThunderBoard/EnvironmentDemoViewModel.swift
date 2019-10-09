//
//  EnvironmentDemoViewModel.swift
//  Thunderboard
//
//  Created by Jamal Sedayao on 9/26/17.
//  Copyright © 2017 Silicon Labs. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class EnvironmentDemoViewModel {
    let capability: DeviceCapability
    let name = BehaviorRelay<String>(value: "")
    let value: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let imageName: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let imageBackgroundColor: BehaviorRelay<UIColor?> = BehaviorRelay<UIColor?>(value: nil)
    
    init(capability: DeviceCapability) {
        self.capability = capability
    }
    
    func updateData(cellData: EnvironmentCellData) {
        self.name.accept(cellData.name)
        self.value.accept(cellData.value)
        self.imageName.accept(cellData.imageName)
        self.imageBackgroundColor.accept(cellData.imageBackgroundColor)
    }
}
