import express from 'express';
import http from 'http';
import WebSocket from 'ws';

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });
const clients = new Set<WebSocket>();

interface WebSockets {
    [key: string]: any;
  }

var webSockets : WebSockets = {};

app.get('/', (req, res) => {
    res.send("hello world !");
});

const wsServer = new WebSocket.Server({ port: 6060});

wsServer.on('connection', function(wes : WebSocket, req : Request, res : Response) {

    var userID = req.url.substr(1) //  get userid from URL ip:6060/userid 

    webSockets[userID] = wes; //  add new user to the connection list

    wes.on('message', function (message) {


        var dataString = message.toString();
        
        if(dataString.charAt(0) == "{"){
            dataString = dataString.replace(/\'/g, '"');
            var data = JSON.parse(dataString);
            console.log("data   =====     "+ data);
            if(data.auth == "chatapphdfgjd34534hjdfk")  {

            
                if(data.cmd == 'send'){ 
                    var boardws = webSockets[data.userid] //check if there is reciever connection
                    
                    if (boardws){
                        var cdata = "{'cmd':'" + data.cmd + "','userid':'"+data.userid+"', 'msgtext':'"+data.msgtext+"'}";
                        
                        boardws.send(cdata); //send message to reciever
                        
                        wes.send(data.cmd + ":success");
                    
                    }else{
                        console.log("No reciever user found.");
                        wes.send(data.cmd + ":error");
                    }
                }else{
                    console.log("No send command");
                    wes.send(data.cmd + ":error");
                }



            } else{
                console.log("App Authincation error");
                wes.send(data.cmd + ":error");
            }

        }else {
            console.log("Non JSON type data");
            wes.send(data.cmd + ":error");
        }


    })


    wes.on('close', function () {
        var userID = req.url.substr(1);
        delete webSockets[userID]; 
        console.log('User Disconnected: ' + userID);
    })

    wes.send('connected'); //initial connection return message

})


app.listen(3000, () => {
  console.log('WebSocket server is running on port 3000');
});
