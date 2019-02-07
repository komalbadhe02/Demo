///**
/**
kjn589
Soap_client.swift
Created by: KOMAL BADHE on 30/01/19
Copyright (c) 2019 KOMAL BADHE
*/


import Foundation
class Soap_client:NSObject,XMLParserDelegate{
    @objc var methodName = String();
    @objc var dicProperties = NSMutableDictionary();
    @objc var completion : ((Any) -> Void)?
    @objc var response = String();
    @objc let hostName = "";

    //INITIALIZE SOAP CLIENT OBJECT
    @objc func initialize(method:String){
        methodName = method;
        dicProperties = NSMutableDictionary();
    }
    //ADD PROPERTIES TO THE REQUEST
    @objc func addProperty(value:Any,key:String){
        dicProperties.setValue(value, forKey: key)
    }
    //ADD INPUTS TO THE REQUEST
    @objc func addInputs(dict:[String:String],json:Bool){
        if(json){
            do {
                let jsonData = try JSONSerialization.data(withJSONObject:dict, options: .prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString as Any, key: "data")
            } catch{
            }
        }
    }
    @objc func addDictInputs(auth:[String:String],dict:[String:String],json:Bool){
        if(json){
            do {
                let jsonData = try JSONSerialization.data(withJSONObject:dict, options: .prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString as Any, key: "Data")
                let jsonData1 = try JSONSerialization.data(withJSONObject:auth, options: .prettyPrinted)
                let jsonString1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString1 as Any, key: "Auth")
            } catch{
            }
        }
    }
    @objc func addDictInputs1(auth:[String:String],dict:[String:Any],json:Bool){
        if(json){
            do {
                let jsonData = try JSONSerialization.data(withJSONObject:dict, options: .prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString as Any, key: "Data")
                let jsonData1 = try JSONSerialization.data(withJSONObject:auth, options: .prettyPrinted)
                let jsonString1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString1 as Any, key: "Auth")
            } catch{
            }
        }
    }
    @objc func addDictArrInputs(auth:[String:String],arr:NSArray,json:Bool){
        if(json){
            do {
                let jsonData = try JSONSerialization.data(withJSONObject:arr, options: .prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString as Any, key: "Data")
                let jsonData1 = try JSONSerialization.data(withJSONObject:auth, options: .prettyPrinted)
                let jsonString1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString1 as Any, key: "Auth")
            } catch{
            }
        }
    }
    @objc public func Add2Dict1Arr(auth:[String:String],arr:NSArray,data:[String:Any],json:Bool){
        if(json){
            do {
                let jsonData1 = try JSONSerialization.data(withJSONObject:auth, options: .prettyPrinted)
                let jsonString1 = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString1 as Any, key: "C")
                let jsonData = try JSONSerialization.data(withJSONObject:arr, options: .prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString as Any, key: "B")
                let jsonData2 = try JSONSerialization.data(withJSONObject:data, options: .prettyPrinted)
                let jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)
                self.addProperty(value:jsonString2 as Any, key: "A")
            } catch{
            }
        }
    }
    //MAKE REQUEST FOR THE SERVICE
    @objc public func makeRequest(serviceUrl :String ){
        var propertyString = "";
        for(key,value) in dicProperties{
            propertyString += "<" + (key as! String) + ">" + (value as! String) + "</" + (key as! String) + ">";
        }
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
            + "<soap:Body>\n"         + " <" + methodName + " xmlns=\"http://tempuri.org/\">\n"
            + propertyString
            + "</" + methodName + ">\n"
            + "</soap:Body>\n"
            + "</soap:Envelope>\n";
        let url = URL(string:serviceUrl);
        var request = URLRequest(url:url!);
        request.httpMethod = "POST";
        request.allHTTPHeaderFields = ["Host":hostName,"SOAPAction":serviceUrl,"Content-Type":"text/xml; charset=utf-8"];
        request.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false);
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    
                    return
                }
                guard let data = data else {
                    return
                }
                var parser = XMLParser();
                parser = XMLParser(data:data);
                parser.delegate = self
                parser.parse();
            }
        }
        task.resume();
    }
    //XML PARSING METHODS
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes dicAttibutes: [String:String])
    {
        if (elementName as NSString).isEqual(to: "return"){
            response = "";
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        response += string;
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "return"){
            if let data = response.data(using: .utf8) {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: [])
                    self.completion!(parsedData);
                } catch {
                    //print(error.localizedDescription)
                }
            }
        }
    }
}
