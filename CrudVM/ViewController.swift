//
//  ViewController.swift
//  CrudVM
//
//  Created by Jeff Ligon on 11/24/20.
//

import Cocoa
import CoreData

//MARK: Config
struct config:Codable {
    var name:String?
    var kernelURL:URL?
    var initRDURL:URL?
    var bootImageURL:URL?
    var commandLine:String?
    var memorySize:Int?
    var cpuCount:Int?
}

//MARK: Keys
let nameKey = "Name"
let bootKey = "bootLoader"
let kernelKey = "kernel"
let initRDKey = "initRD"
let statusKey = "Status"
let descKey = "Description"
let machineKey = "Machine"

class ViewController: NSViewController{
    let server:[String:Any] = [nameKey:"server",
                               bootKey:"file:///Users/jtligon/Documents/fedvm/Fedora-Server-33-1.3.aarch64.raw",
                               descKey:"Fedora Server 33"]
    let iot:[String:Any] = [nameKey:"iot",
                            bootKey:"file://location",
                            descKey:"Fedora IoT 33"]
    let rhcos = [nameKey:"RHCOS",
                 bootKey:"file://location",
                 descKey:"RHCOS 4.6"]
    
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addItem: NSToolbarItem!
    
    var systems:[[String:Any]] = [ ]
    var configs:[config] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //todo: mocking the data here, need to pull it from CoreData
        systems = [server, iot, rhcos]
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

// MARK: DataSource methods
extension ViewController:NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return systems.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return systems[row]
    }
    
    
}

// MARK: Delegate methods
extension ViewController:NSTableViewDelegate{
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier:NSUserInterfaceItemIdentifier(rawValue: "configs"), owner: self) as? NSTableCellView
        
        //customize per column
        switch tableColumn?.headerCell.stringValue {
        case nameKey:
            view?.textField?.stringValue = systems[row][nameKey] as? String ?? "noName"
        case statusKey:
            view?.textField?.stringValue = ""
            //TODO:I'd like to drop in a imageview to represent status here, but i need to dive deeper into creating a custom NSTableCell or NSTableView
            addImageToCell(systemSymbolName: "NSImageNameAddTemplate", cell: view!)
        case descKey:
            view?.textField?.stringValue = systems[row][descKey] as? String ?? "noDesc"
        default:
            view?.textField?.stringValue = ""
        }
        return view
    }
    
    func addImageToCell(systemSymbolName:String, cell:NSTableCellView){
        //not doing what i want, yet
        cell.addSubview(NSImageView(image: NSImage(systemSymbolName: systemSymbolName, accessibilityDescription: systemSymbolName) ?? NSImage() ))
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        //catches clicks in the header view
        print(tableColumn)
    }
    
    
    
}

/*
let kernelURL = kernelURL,
let initialRamdiskURL = initialRamdiskURL,
let bootableImageURL = bootableImageURL,
let commandLine = commandLine
 
 let config = VZVirtualMachineConfiguration()
 config.bootLoader = bootloader
 config.cpuCount = 4
 config.memorySize = 2 * 1024 * 1024 * 1024
 config.entropyDevices = [entropy]
 config.memoryBalloonDevices = [memoryBalloon]
 config.serialPorts = [serial]
 config.storageDevices = [blockDevice]
 config.networkDevices = [networkDevice]
 **/
