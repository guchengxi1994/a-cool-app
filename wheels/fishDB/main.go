package main

import (
	"net/http"

	constant "github.com/guchengxi1994/fishDB/constant"
	_ "github.com/guchengxi1994/fishDB/db"
	server "github.com/guchengxi1994/fishDB/server"
)

// start a tiny server
func main() {

	print(constant.FishDbBanner)

	http.HandleFunc("/get", server.GetValue)
	http.HandleFunc("/qr", server.NewQr)

	http.ListenAndServe(":15234", nil)
}
