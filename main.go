package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/handlers"
	"github.com/julienschmidt/httprouter"
)

func main() {
	router := httprouter.New()
	router.GET("/", func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		b, err := ioutil.ReadFile("smgsms.mp3")
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte(err.Error()))
		}

		w.Header().Set("Content-Type", "audio/mpeg")
		w.Write(b)

		return
	})
	router.GET("/good", func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		w.Write([]byte("GOOD"))
	})

	handler := handlers.CombinedLoggingHandler(os.Stdout, router)
	handler = handlers.RecoveryHandler()(router)

	log.Println("Serving :49389")
	log.Fatal(http.ListenAndServe(":49389", handler))
}
