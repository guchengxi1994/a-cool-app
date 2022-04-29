package server

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"net"
)

func ListenAndServe(addr string) {
	listener, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatal(fmt.Sprintf("listen err: %v\n", err))
		return
	}
	defer listener.Close()
	log.Println(fmt.Sprintf("start listening on %s", addr))

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Fatal(fmt.Sprintf("accept err: %v\n", err))
			break
		}

		go Handle(conn)
	}
}

func Handle(conn net.Conn) {
	reader := bufio.NewReader(conn)
	for {
		msg, err := reader.ReadString('\n')

		if err != nil {
			if err == io.EOF {
				log.Println("connection close")
				continue
			} else {
				log.Println(err.Error())
				continue
			}
		}

		b := []byte(msg)

		conn.Write(b)
	}
}
