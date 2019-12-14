//
//  Utils.swift
//  SecretVault
//
//  Created by MAC_OS on 9/6/19.
//  Copyright © 2019 com.arrtgame.demo. All rights reserved.
//

import Foundation

class Utils: NSObject {
    
    static func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    static func initHTMLTemplate(fileNames: [String]) -> String {
        let stringHTML = """
        <html>
        <head>
        <style>
        * {padding:0;margin:0;}
        body {margin:0;font: normal 12px Arial, Verdana, Tahoma; color:#333;background: #F0F0F0 url("bg.png") 50% 0 fixed repeat;}
        #main {width:800px;margin:0 auto;}
        #header {background: transparent url(titlebg.png) repeat-x;border-top: 1px solid #dcdcdc;border-bottom: 1px solid #404040;height:50px;}
        form.upload {margin-left:12px;padding-left:48px;padding-top:8px;margin-top:10px;height:32px;}
        table {width:100%;padding:0;border-bottom: 1px solid #fff;}
        thead {margin:0;padding:0;}
        th {height:30px;text-align: left;padding-left:20px;border-left:1px solid #999;border-bottom:1px solid #999;color:#303;font-size:.9em;font-weight: normal;background: transparent url(theadbg.png) repeat-x;}
        td.del, th.del {width:8em;}
        tbody td {padding-left:20px;background-color:#fff;height:20px;border-bottom: 1px solid #ccc;}
        tr.shadow td{background-color:#ecf3fe;}
        a.file {text-decoration:none;color:#333;}
        #footer {height:50px;border-top:1px solid #ccc;margin:0 auto;position:absolute;bottom:0px;width:800px;text-align: center;}
        #footer .content {border-top: 1px solid #fff;}
        </style>
        </head>
        <body>
        <div id="main">
        <div id="header">
        <form action="/" enctype="multipart/form-data" method="post" class="upload">
        <label>Select file:</label>
        <input id="fileToUpload" name="fileToUpload" size="40" type="file">
        <input name="commit" type="submit" value="Upload" class='button'>
        </form>
        </div>
        <script language="javascript" type="text/javascript">
        var myArray    = \(fileNames);
        var myTable="<table><tr><th>Name</th><th class='del'>Detele</th></tr>";
        for (var i=0; i<myArray.length; i++) {
        var fileName = myArray[i];
        myTable+="<tr><td style='width: 100%;'>" + fileName + "</td>";
        myTable+="<td class='del'><form action='/deleted' method='get'><input name='file' value='"+ fileName + "' type='hidden'><input name='commit' type='submit' value='Delete' class='button'></form></td>";
        }
        myTable+="</table>";
        document.write( myTable);
        </script>
        <div id="footer">
        <div class="content">
        </div>
        </div>
        </div>
        </body>
        </html>
        """
        return stringHTML
    }
}
