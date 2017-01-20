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
    let myProximityUUID = NSUUID.init(uuidString: "00000000-7FA9-1001-B000-001C4DED901F")
    // major
    var major: Int = 0
    // minor
    var minor: Int = 0
    
    // ビーコン関連
    var beaconRegion: CLBeaconRegion!
    var beaconPeripheralData = NSDictionary()
    
    // UserDefault
    let ud = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iBeacon発信
        myPeripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        /* UserDefaultsから値を取得 */
        // major
        if let majorCode = ud.object(forKey: "major") {
            major = majorCode as! Int
        }
        
        // minor
        if let minorCode = ud.object(forKey: "minor") {
            minor = minorCode as! Int
        }
        
        
        updateLabelVal()
    }
    
    
    
    

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
//        if #available(iOS 10.0, *) {
//            if peripheral.state == CBManagerState.poweredOn {
//                updateSettings()
//            }
//        }
        
        updateSettings()
    }
    
    
    
    
    
    // 反映ボタン
    @IBAction func tapSetting(_ sender: Any) {
        updateSettings()
    }
    

    
    
    @IBAction func tapScreen(_ sender: Any) {
        majorTF.endEditing(true)
        minorTF.endEditing(true)
    }
    
    
    
    
    // iBeaconの設定を変更する
    func updateSettings() {
        
        if !majorTF.text!.isEmpty {
            major = Int(majorTF.text!)!
        } else {
            major = 0
            print("major -> 空")
        }
        
        
        if !minorTF.text!.isEmpty {
            minor = Int(minorTF.text!)!
        } else {
            minor = 0
            print("minor -> 空")
        }
        
        
        // Labelの更新
        updateLabelVal()

        
        beaconRegion = CLBeaconRegion.init(proximityUUID: myProximityUUID! as UUID, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: "hiroyoshi.matsumoto")
        
        beaconPeripheralData = NSDictionary(dictionary: beaconRegion.peripheralData(withMeasuredPower: nil))

        // Beaconを停止し新たな設定で再開始
        myPeripheralManager.stopAdvertising()
        myPeripheralManager.startAdvertising(beaconPeripheralData as? [String : AnyObject])
        
        
        // UserDefaultsに設定を保持
        ud.set(major, forKey: "major")
        ud.set(minor, forKey: "minor")
        ud.synchronize()
    }
    
    
    
    
    // Labelの値を更新
    func updateLabelVal() {
        majorLabel.text = String(major)
        minorLabel.text = String(minor)
        
        majorTF.text = String(major)
        minorTF.text = String(minor)
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

