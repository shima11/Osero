var app = require('http').createServer(handler),
    io = require('socket.io').listen(app),
    fs = require('fs');

app.listen(1337);

// //サーバーを起動した時のハンドラー
// function handler(req, res){
//     fs.readFile(__dirname + '/index.html', function(err, data){
//         if (err) {
//             res.writeHead(500);
//             return res.end('Error');
//         }
//         res.writeHead(200);
//         res.write(data);
//         res.end();
//     })
// }

//ソケット通信で接続した時
io.sockets.on("connection",function(socket){
    //接続しているソケットのみ
    socket.on("",function (data) {
        socket.emit("", { value : data.value });
    });
    
    //自分以外に送信
    socket.on("",function (data) {
        socket.broadcast.emit("", { value : data.value });
    });
    
    //自分も含めて全員に送信
    socket.on("",function (data) {
        io.sockets.emit("", { value : data.value });//配列で渡す（swiftで扱うため）
        io.sockets.emit("message_from_server",data + '[' + socket.id + ']');

    });

    //切断した時
    socket.on("connect",function (data) {
        socket.emit("message_from_server",data + '[' + socket.id + ']');
        
    }
    //切断した時
    socket.on("disconnect",function (data) {
        
    });
});