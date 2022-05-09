package server

import (
	"encoding/json"
	"io"
	"net/http"

	uuid "github.com/satori/go.uuid"

	"github.com/guchengxi1994/fishDB/db"
)

func GetValue(w http.ResponseWriter, r *http.Request) {
	Database, _ := db.Open(db.DatabasePath)

	param := r.URL.Query().Get("name")
	res, err := Database.Get([]byte(param))

	var result Result

	if err != nil {
		result = Result{Code: 500, Msg: "get val error", Data: ""}
	} else {
		result = Result{Code: 200, Msg: "", Data: string(res)}
	}

	resp, _ := json.Marshal(result)

	io.WriteString(w, string(resp))
}

func Register(w http.ResponseWriter, r *http.Request) {
	val := r.URL.Query().Get("v")
	key := r.URL.Query().Get("k")
	Database, _ := db.Open(db.DatabasePath)
	err := Database.Put([]byte(key), []byte(val))

	var result Result

	if err != nil {
		result = Result{Code: 500, Msg: "insert error", Data: ""}
	} else {
		result = Result{Code: 200, Msg: "", Data: ""}
	}
	res, _ := json.Marshal(result)

	io.WriteString(w, string(res))
}

func NewQr(w http.ResponseWriter, r *http.Request) {
	u := uuid.NewV4()
	Database, _ := db.Open(db.DatabasePath)
	// w.Write([]byte(u.String()))
	err := Database.Put([]byte(u.String()), []byte("undefined"))

	var result Result

	if err != nil {
		result = Result{Code: 500, Msg: "insert db error", Data: u.String()}
	} else {
		result = Result{Code: 200, Msg: "", Data: u.String()}
	}

	res, _ := json.Marshal(result)

	io.WriteString(w, string(res))
}

func CORS(f http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		w.Header().Set("Access-Control-Allow-Origin", "*")                                                     // 可将将 * 替换为指定的域名
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type,AccessToken,X-CSRF-Token, Authorization") //你想放行的header也可以在后面自行添加
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")                                   //我自己只使用 get post 所以只放行它
		//w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE, UPDATE")
		w.Header().Set("Access-Control-Expose-Headers", "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Content-Type")
		w.Header().Set("Access-Control-Allow-Credentials", "true")
		// 放行所有OPTIONS方法
		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		// 处理请求
		f(w, r)
	}
}
