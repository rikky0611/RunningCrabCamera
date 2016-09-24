//
//  Health.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/17.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import Foundation
import HealthKit

struct Health {
    
    static func readHealthData(completion: Void -> Void) {
        let type = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
        let healthStore = HKHealthStore()
        var distance: Double?
        
        // データ抽出クエリ
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 0, sortDescriptors: nil) { (query, results, error) in
            if let error = error {
                print(error)
            }
            
            if let results = results as? [HKQuantitySample] {
                dispatch_async(dispatch_get_main_queue()) {
                    print("データ読み出し")
                    if let result = results.last {
                        let mUnit = HKUnit(fromString: "m")
                        distance = result.quantity.doubleValueForUnit(mUnit)
                        Run.currentRun.soFarDistance = distance! / 1000
                        completion()
                    }
                }
            }
        }
        
        //権限確認
        let authorizedStatus = healthStore.authorizationStatusForType(type)
        if authorizedStatus == .SharingAuthorized {
            healthStore.executeQuery(query)
        } else {
            healthStore.requestAuthorizationToShareTypes([type], readTypes: [type]) {
                success, error in
                guard error == nil else { return }
                
                if success {
                    healthStore.executeQuery(query)
                }
            }
        }
    }
}
