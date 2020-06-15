/* 
  hdjssdk.js
  HDMasterProject

  Created by 邓立兵 on 2020/6/15.
  Copyright © 2020 HarryDeng. All rights reserved.
*/

hdjsobj = {
     postMessageToNative: function(message) {
         console.log(message);
        if (!message) {
            console.log("message is nil");
            return;
        }
        
        const jsonString = JSON.stringify(message);
        if (!jsonString) {
            console.log("message to json error");
            return;
        }
    
        window.webkit.messageHandlers.hdjsobj.postMessage(jsonString);
    },
    
    hdWantSleep: function(params) {
        var message = {
            method: "hdWantSleep",
            params: params,
        }
        hdjsobj.postMessageToNative(message)
    }

};

