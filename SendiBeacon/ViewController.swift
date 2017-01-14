//
//  ViewController.swift
//  SendiBeacon
//
//  Created by 松本泰佳 on 2017/01/14.
//  Copyright © 2017年 M_HIRO. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var majorTF: UITextField!
    @IBOutlet weak var minorTF: UITextField!
    
    
    var myPeripheralManager: CBPeripheralManager!
    
    
    // UUID
    let myProximityUUID = NSUUID.init(uuidString: "E86367B8-D8A8-4BE0-82DE-4653A7333113")
    // major
    var major: Int = 0
    // minor
    var minor: Int = 0
    
    
    var beaconRegion: CLBeaconRegion!
    var beaconPeripheralData = NSDictionary()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iBeacon発信
        myPeripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        beaconRegion = CLBeaconRegion.init(proximityUUID: myProximityUUID! as UUID, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: "hiroyoshi.matsumoto")
        
        beaconPeripheralData = NSDictionary(dictionary: beaconRegion.peripheralData(withMeasuredPower: nil))
    }
    
    
    
    

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if peripheral.state == CBManagerState.poweredOn {
            myPeripheralManager.startAdvertising(beaconPeripheralData as? [String : AnyObject])
        }
        
    }
    
    
    
    // iBeaconの設定を変更する
    @IBAction func tapSetting(_ sender: Any) {
        beaconRegion = CLBeaconRegion.init(proximityUUID: myProximityUUID! as UUID, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: "hiroyoshi.matsumoto")
        
        beaconPeripheralData = NSDictionary(dictionary: beaconRegion.peripheralData(withMeasuredPower: nil))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

