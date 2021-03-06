
import Foundation
import UIKit

//class for the property.
class House {
    
    var price : Int
    var streetDetail : String
    var suburb : String
    var postCode : Int
    var roomNo : Int
    var bathNo : Int
    var carSpaceNo: Int
    var petsAllowed: Bool
    var phoneNo : Int
    var description : String
    var favourite : Bool
    var xlocation : Double
    var ylocation : Double
    
    init() {
        price = 0
        streetDetail = ""
        suburb = ""
        postCode = 0
        roomNo = 0
        bathNo = 0
        carSpaceNo = 0
        petsAllowed = false
        phoneNo = 0
        description = ""
        favourite = false
        xlocation = 0.000000000
        ylocation = 0.000000000
        
    }
    
}

//main operation class, have the functions about the property operations
class Model {
    
    static let model = Model()
    
    var result = [House]()
    var favourite = [House]()
    var own = [House]()
    var current = [House]()
    var selected = 0
    var landlordMode = false
    
    var delegate : DatabaseOperations?
    
    
    private init(){}
    
    
    //load from database to house arrays
    func loadData(){
        
        result.removeAll()
        favourite.removeAll()
        own.removeAll()
        
        
        var query : String = "select * from house"
        query = "select * from (" + query + ") where price <= \(DataModel.dataModel.currentMaxPrice)"
        query = "select * from (" + query + ") where price >= \(DataModel.dataModel.currentMinPrice)"
        
        //any situation
        if (DataModel.dataModel.currentRoomNo == 0){
            //do nothing
        }
            
        else if(DataModel.dataModel.currentRoomNo == 6){
            
            query = "select * from (" + query + ") where roomno >= 5"
            
        }
            
        else{
            
            query = "select * from (" + query + ") where roomno = \(DataModel.dataModel.currentRoomNo)"
        }
        
        
        
        if (DataModel.dataModel.currentBathNo == 0){
            //do nothing
        }
            
        else if(DataModel.dataModel.currentBathNo == 6){
            
            query = "select * from (" + query + ") where bathno >= 5"
            
        }
            
        else{
            
            query = "select * from (" + query + ") where bathno = \(DataModel.dataModel.currentBathNo)"
        }
        
        
        if (DataModel.dataModel.currentCarSpaceNo == 0){
            //do nothing
        }
            
        else if(DataModel.dataModel.currentCarSpaceNo == 6){
            
            query = "select * from (" + query + ") where carspace >= 5"
            
        }
            
        else{
            
            query = "select * from (" + query + ") where carspace = \(DataModel.dataModel.currentCarSpaceNo)"
        }
        
        if(DataModel.dataModel.suburb == "Melbourne Region"){
            
            //do nothing
        }
        else{
            
            query = "select * from (" + query + ") where suburb = '\(DataModel.dataModel.suburb)'"
        }
        if (DataModel.dataModel.petsAllowed == true){
            
            query = "select * from (" + query + ") where pets = 1"
        }
        
        
        query = query + " ORDER BY price"
        let rs = delegate?.queryDatabase(operation: query)
        
        while(rs?.next() == true){
            
            let house = House()
            
            house.bathNo = (rs?.long(forColumn: "bathno"))!
            house.carSpaceNo = (rs?.long(forColumn: "carspace"))!
            house.description = (rs?.string(forColumn: "description"))!
            
            if(rs?.long(forColumn: "pets") == 1){
                
                house.petsAllowed = true
            }
            else {
                
                house.petsAllowed = false
            }
            
            if(rs?.long(forColumn: "favourite") == 1) {
                
                house.favourite = true
                
            }
            
            house.phoneNo = (rs?.long(forColumn: "phone"))!
            house.postCode = (rs?.long(forColumn: "postcode"))!
            house.price = (rs?.long(forColumn: "price"))!
            house.roomNo = (rs?.long(forColumn: "roomno"))!
            house.streetDetail = (rs?.string(forColumn: "address"))!
            house.suburb = (rs?.string(forColumn: "suburb"))!
            house.xlocation = (rs?.double(forColumn: "xlocation"))!
            house.ylocation = (rs?.double(forColumn: "ylocation"))!
            result.append(house)
            
        }
        
        let favouriteRs = delegate?.queryDatabase(operation: "Select * from house where favourite = 1")
        query = query + " ORDER BY price"
        while(favouriteRs?.next() == true){
            
            let house = House()
            
            house.bathNo = (favouriteRs?.long(forColumn: "bathno"))!
            house.carSpaceNo = (favouriteRs?.long(forColumn: "carspace"))!
            house.description = (favouriteRs?.string(forColumn: "description"))!
            
            if(favouriteRs?.long(forColumn: "pets") == 1){
                
                house.petsAllowed = true
            }
            else {
                
                house.petsAllowed = false
            }
            
            
            
            house.favourite = true
            
            house.phoneNo = (favouriteRs?.long(forColumn: "phone"))!
            house.postCode = (favouriteRs?.long(forColumn: "postcode"))!
            house.price = (favouriteRs?.long(forColumn: "price"))!
            house.roomNo = (favouriteRs?.long(forColumn: "roomno"))!
            house.streetDetail = (favouriteRs?.string(forColumn: "address"))!
            house.suburb = (favouriteRs?.string(forColumn: "suburb"))!
            house.xlocation = (favouriteRs?.double(forColumn: "xlocation"))!
            house.ylocation = (favouriteRs?.double(forColumn: "ylocation"))!
            
            favourite.append(house)
        }
        
        
        let resultRs = delegate?.queryDatabase(operation: "Select * from house where owning = 1 order by price")
        
        while(resultRs?.next() == true){
            
            let house = House()
            
            house.bathNo = (resultRs?.long(forColumn: "bathno"))!
            house.carSpaceNo = (resultRs?.long(forColumn: "carspace"))!
            house.description = (resultRs?.string(forColumn: "description"))!
            
            if(resultRs?.long(forColumn: "pets") == 1){
                
                house.petsAllowed = true
            }
            else {
                
                house.petsAllowed = false
            }
            
            
            house.phoneNo = (resultRs?.long(forColumn: "phone"))!
            house.postCode = (resultRs?.long(forColumn: "postcode"))!
            house.price = (resultRs?.long(forColumn: "price"))!
            house.roomNo = (resultRs?.long(forColumn: "roomno"))!
            house.streetDetail = (resultRs?.string(forColumn: "address"))!
            
            
            house.suburb = (resultRs?.string(forColumn: "suburb"))!
            
            house.xlocation = (resultRs?.double(forColumn: "xlocation"))!
            house.ylocation = (resultRs?.double(forColumn: "ylocation"))!
            
            own.append(house)
        }
        
        database.close()
        
        
        
        
    }
    
    
    func removeFavourite(detail : String){
        
        let query = "update house set favourite = 0 where address = " + "'" + detail + "'"
        if(delegate?.modifyDatabase(operation: query) == false){
            
            print("remove error!")
        }
        
        
        
    }
    
    func addFavourite(detail : String){
        
        let query = "update house set favourite = 1 where address = " + "'" + detail + "'"
        if(delegate?.modifyDatabase(operation: query) == false){
            
            print("mark error!")
        }
        
    }
    
    func readSuburb(){
        
        DataModel.dataModel.suburbOptions.removeAll()
        DataModel.dataModel.suburbOptions.append("Melbourne Region")
        let query = "select distinct suburb from house"
        
        let rs = delegate?.queryDatabase(operation: query)
        
        while (rs?.next() == true){
            
            DataModel.dataModel.suburbOptions.append((rs?.string(forColumn: "suburb"))!)
            
        }
        
        database.close()
    }
    
    
    func removeHouse(detail: String){
        
        let query = "delete from house where address = " + "'" + detail + "'"
        
        if(delegate?.modifyDatabase(operation: query) == false){
            
            print("Delete failed!")
        }
        
        let fileManager = FileManager.default
        let homeDirectory = NSHomeDirectory()
        let srcUrl = homeDirectory + "/Documents/" + detail + ".jpg"
        
        try! fileManager.removeItem(atPath: srcUrl)
        
        
        
    }
    
    
    //when the application first run on the device, we need to provide the database to documents folder and some init images.
    func firstRun(){
        
        let isFileManager = FileManager.default
        
        let srcUrl = NSHomeDirectory() + "/Documents/" + "houser.db"
        let exist = isFileManager.fileExists(atPath: srcUrl)
        
        if(exist == false){
            
            let fromUrl = Bundle.main.path(forResource: "houser.db", ofType: nil)
            
            try! isFileManager.copyItem(atPath: fromUrl!, toPath: srcUrl)
            
            
            database = FMDatabase(path : srcUrl)
            
            databasePro = DatabaseOperation()
            
            loadData()
            
            for index in 0...8 {
                
                let toUrl = NSHomeDirectory() + "/Documents/" + result[index].streetDetail + ".jpg"
                let image = UIImage(named:"\(result[index].streetDetail).jpg")
                let data:Data = UIImageJPEGRepresentation(image!, 1.0)!
                try? data.write(to: URL(fileURLWithPath: toUrl))
            }
            
            
        }
        else{
            
            
            database = FMDatabase(path : srcUrl)
            
            databasePro = DatabaseOperation()
            
            loadData()
            
        }
        
        
        
        
    }
    
    
    
    
    
    func addProperty(address : String, description : String, suburb : String, phone :String, image : UIImage){
        
        var pets : Int
        if(addDataModel.adddataModel.petsAllowed == true){
            
            pets = 1
            
        }
        else
        {
            
            pets = 0
            
        }
        let query : String = "insert into house (address,suburb,postcode,price,bathno,roomno,carspace,phone,pets,description,favourite,owning,xlocation,ylocation) values ("
            + "'\(address)',"
            + "'\(suburb)',"
            + "'\(addDataModel.adddataModel.postCode)',"
            + "'\(addDataModel.adddataModel.currentPrice)',"
            + "'\(addDataModel.adddataModel.currentBathNo)',"
            + "'\(addDataModel.adddataModel.currentRoomNo)',"
            + "'\(addDataModel.adddataModel.currentCarSpaceNo)',"
            + "'\(phone)',"
            + "'\(pets)',"
            + "'\(description)',"
            + "'0',"
            + "'1',"
            + "'\(addDataModel.adddataModel.xlocation)',"
            + "'\(addDataModel.adddataModel.ylocation)')"
        
        if(delegate?.modifyDatabase(operation: query) == false){
            
            
            print("add failed!")
            
        }
        let toUrl = imagePath + address + ".jpg"
        let data:Data = UIImageJPEGRepresentation(image, 1.0)!
        try? data.write(to: URL(fileURLWithPath: toUrl))
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
}
