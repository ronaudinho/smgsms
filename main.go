package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"github.com/faiface/beep"
	"github.com/faiface/beep/mp3"
	"github.com/faiface/beep/speaker"
	"github.com/gorilla/handlers"
	"github.com/julienschmidt/httprouter"
)

func main() {
	router := httprouter.New()
	router.GET("/", func(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
		f, err := os.Open("smgsms.mp3")
		if err != nil {
			log.Println(err)

			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		streamer, format, err := mp3.Decode(f)
		if err != nil {
			log.Println(err)

			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		defer streamer.Close()
		speaker.Init(format.SampleRate, format.SampleRate.N(time.Second/10))
		done := make(chan bool)
		speaker.Play(beep.Seq(streamer, beep.Callback(func() {
			done <- true
		})))
		<-done

		return
	})

	handler := handlers.CombinedLoggingHandler(os.Stdout, router)
	handler = handlers.RecoveryHandler()(router)

	log.Println("Serving :3195")
	log.Fatal(http.ListenAndServe(":3195", handler))
}
