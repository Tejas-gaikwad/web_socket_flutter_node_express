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

var webSockets : WebSockets = {
    user2 : ['222'] 
};

app.get('/', (req, res) => {
    res.send("hello world !");
});

const wsServer = new WebSocket.Server({ port: 6060});

wsServer.on('connection', function(wes : WebSocket, req : Request, res : Response) {

    console.log('User Connected: ');

    wes.on('message', function (message) {

        console.log("message   =>>>>    "+message);
        var dataString = message.toString();
        console.log("dataString   =>>>>    "+dataString);
        if(dataString.charAt(0) == "{"){
            dataString = dataString.replace(/\'/g, '"');
            var data = JSON.parse(dataString);
            if(data.auth == "chatapphdfgjd34534hjdfk"){

                if(data.cmd == 'send'){ 
                    var boardws = webSockets[data.userid] //check if there is reciever connection
                    if (boardws){
                        var cdata = "{'cmd':'" + data.cmd + "','userid':'"+data.userid+"', 'msgtext':'"+data.msgtext+"'}";
                        boardws.send(cdata); //send message to reciever
                        console.log("message   sent =>>>>    ");
                        wes.send(data.cmd + ":success");
                        console.log("message success   =>>>>    ");
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

// wss.on('connection', (ws: WebSocket) => {
//   console.log('Client connected');
//   clients.add(ws);

//   ws.on('message', (message: string) => {
//     const data = JSON.parse(message);
//     console.log('targetUSer   ->>>>>>>>    '+ data.targetUser);
//     const targetSocket = Array.from(clients).find(client => {
//         return client !== ws && client.readyState ===  WebSocket.OPEN;
//     })
//     console.log('targetSocket   ->>>>>>>>    '+ targetSocket);
//     if (targetSocket) {
//         targetSocket.send(JSON.stringify({ message: data.message }));
//     }
//     console.log('targetSocket   msg sent->>>>>>>>    ');
//   });

//   ws.on('close', () => {
//     console.log('Client disconnected');
//   });

//   ws.on('typing', () => {
//     console.log("Typing...");
//   });

// });

app.listen(3000, () => {
  console.log('WebSocket server is running on port 3000');
});
