package main

import (
	"net/http"

	constant "github.com/guchengxi1994/fishDB/constant"
	server "github.com/guchengxi1994/fishDB/server"
)

// start a tiny server
func main() {

	print(constant.FishDbBanner)

	http.HandleFunc("/get", server.CORS(server.GetValue))
	http.HandleFunc("/qr", server.CORS(server.NewQr))
	http.HandleFunc("/login", server.CORS(server.Register))

	http.ListenAndServe("0.0.0.0:15234", nil)
}
