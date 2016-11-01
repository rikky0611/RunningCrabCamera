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
    
    static func readHealthData(_ completion: @escaping (Void) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let healthStore = HKHealthStore()
        var distance: Double?

        // データ抽出クエリ
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 0, sortDescriptors: nil) { (query, results, error) in
            if let error = error {
                print(error)
            }
            
            if let results = results as? [HKQuantitySample] {
                DispatchQueue.main.async {
                    var totalDistanceSoFar = 0.0
                    for result in results where Run.currentRun.startDate?.compare(result.startDate)  == ComparisonResult.orderedAscending  {
                        print(result)
                        let mUnit = HKUnit(from: "m")
                        distance = result.quantity.doubleValue(for: mUnit)
                        totalDistanceSoFar += distance! / 1000
                    }
                    Run.currentRun.soFarDistance = totalDistanceSoFar
                    completion()
                }
            }
        }
        
        //権限確認
        let authorizedStatus = healthStore.authorizationStatus(for: type)
        if authorizedStatus == .sharingAuthorized {
            healthStore.execute(query)
        } else {
            healthStore.requestAuthorization(toShare: [type], read: [type]) {
                success, error in
                guard error == nil else { return }
                
                if success {
                    healthStore.execute(query)
                }
            }
        }
    }
}
