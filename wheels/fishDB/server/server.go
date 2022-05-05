package server

import (
	"fmt"
	"net/http"

	uuid "github.com/satori/go.uuid"

	db "github.com/guchengxi1994/fishDB/db"
)

func GetValue(w http.ResponseWriter, r *http.Request) {
	param := r.URL.Query().Get("name")
	res, err := db.Database.Get([]byte(param))
	if err != nil {
		fmt.Printf("get err: %v\n", err)
		w.Write([]byte(""))
		return
	}

	w.Write([]byte(res))
}

func Register(w http.ResponseWriter, r *http.Request) {
	param := r.URL.Query().Get("username")

	w.Write([]byte(param))
}

func NewQr(w http.ResponseWriter, r *http.Request) {
	u := uuid.NewV4()
	w.Write([]byte(u.String()))
}
