package main

import (
	constant "github.com/guchengxi1994/fishDB/constant"
	server "github.com/guchengxi1994/fishDB/server"
)

func main() {
	print(constant.FishDbBanner)
	server.ListenAndServe(":15234")
}
