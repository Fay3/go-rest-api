package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"regexp"
	"strconv"
	"time"
	"unicode"

	"github.com/gorilla/mux"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type User struct {
	Username string `json:"username,omitempty" bson:"username,omitempty"`
	Name     string `json:"name,omitempty" bson:"name,omitempty"`
	DOB      string `json:"dob,omitempty" bson:"dob,omitempty"`
}

var client *mongo.Client

func IsLetter(s string) bool {
	for _, r := range s {
		if !unicode.IsLetter(r) {
			return false
		}
	}
	return true
}

func CreateUserEndpoint(response http.ResponseWriter, request *http.Request) {
	response.Header().Add("content-type", "application/json")
	var user User
	json.NewDecoder(request.Body).Decode(&user)
	collection := client.Database("birthdayDB").Collection("users")
	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
	result, _ := collection.InsertOne(ctx, user)
	json.NewEncoder(response).Encode(result)
}

func UpdateUserEndpoint(response http.ResponseWriter, request *http.Request) {
	response.Header().Add("content-type", "application/json")
	params := mux.Vars(request)
	username, _ := (params["username"])
	var user User
	collection := client.Database("birthdayDB").Collection("users")
	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
	filter := bson.M{"username": username}
	json.NewDecoder(request.Body).Decode(&user)

	usercheck := (IsLetter(username))

	if usercheck == false {
		response.WriteHeader(http.StatusUnprocessableEntity)
		response.Write([]byte(`{ "message": " ` + username + ` must contains only letters"}`))
		return
	}

	re := regexp.MustCompile("((19|20)\\d\\d)-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])")
	dobcheck := re.MatchString(user.DOB)

	if dobcheck == false {
		response.WriteHeader(http.StatusUnprocessableEntity)
		response.Write([]byte(`{ "message": " ` + user.DOB + ` YYYY-MM-DD must be the date format"}`))
		return
	}

	date := time.Now()
	format := "2006-01-02"
	then, _ := time.Parse(format, user.DOB)
	diff := date.Sub(then)
	daysInt := int(diff.Hours() / 24)

	// date := time.Now()
	// format := "2006-01-02"
	// then, _ := time.Parse(format, user.DOB)
	// diff := then.Sub(date)
	// daysInt := int(diff.Hours() / 24)

	if daysInt <= 0 {
		response.WriteHeader(http.StatusUnprocessableEntity)
		response.Write([]byte(`{ "message": " ` + user.DOB + ` must be a date before todays date"}`))
		return
	}

	update := bson.D{
		{"$set", bson.D{
			{"name", user.Name},
			{"dob", user.DOB},
		}},
	}

	err := collection.FindOneAndUpdate(ctx, filter, update).Decode(&user)

	if err != nil {
		user.Username = username
		result, _ := collection.InsertOne(ctx, user)
		json.NewEncoder(response).Encode(result)
		return
	}

	user.Username = username
	response.WriteHeader(http.StatusNoContent)
	json.NewEncoder(response).Encode(user)
}

func GetUserEndpoint(response http.ResponseWriter, request *http.Request) {
	response.Header().Add("content-type", "application/json")
	params := mux.Vars(request)
	username, _ := (params["username"])
	var user User
	collection := client.Database("birthdayDB").Collection("users")
	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
	err := collection.FindOne(ctx, User{Username: username}).Decode(&user)
	if err != nil {
		response.WriteHeader(http.StatusInternalServerError)
		response.Write([]byte(`{ "message": "` + err.Error() + `"}`))
		return
	}

	// date := time.Now()
	// format := "2006-01-02"
	// then, _ := time.Parse(format, user.DOB)
	// diff := date.Sub(then)
	// daysInt := int(diff.Hours() / 24)
	// daysStr := strconv.Itoa(int(diff.Hours() / 24))

	date := time.Now()
	format := "2006-01-02"
	curYear := date.Year()
	strEx, _ := time.Parse(format, user.DOB)
	strExfmt := strEx.Format(format)
	dobYear := strEx.Year()
	sdobYear := strconv.Itoa(dobYear)
	reStr := regexp.MustCompile("^(.*?)" + sdobYear + "(.*)$")
	repStr := fmt.Sprintf("${1}%d$2", curYear)
	output := reStr.ReplaceAllString(strExfmt, repStr)
	then, _ := time.Parse(format, output)
	diff := then.Sub(date)
	daysInt := int(diff.Hours() / 24)
	daysStr := strconv.Itoa(int(diff.Hours() / 24))

	if daysInt == 0 {
		response.Write([]byte(`{ "message": "Hello, ` + username + `! Happy Birthday"}`))
		return
	}

	if daysInt < 0 {
		pastDate := then.AddDate(1, 0, 0)
		diff := pastDate.Sub(date)
		daysStr := strconv.Itoa(int(diff.Hours() / 24))

		response.Write([]byte(`{ "message": "Hello, ` + username + ` your birthday is in ` + daysStr + ` day(s)"}`))
		return
	}

	response.Write([]byte(`{ "message": "Hello, ` + username + ` your birthday is in ` + daysStr + ` day(s)"}`))
	return
}

func main() {
	fmt.Println("starting the application...")
	dbhost := os.Getenv("DB_URI")
	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)
	client, _ = mongo.Connect(ctx, options.Client().ApplyURI(dbhost))
	router := mux.NewRouter()
	router.HandleFunc("/hello", CreateUserEndpoint).Methods("POST")
	router.HandleFunc("/hello/{username}", GetUserEndpoint).Methods("GET")
	router.HandleFunc("/hello/{username}", UpdateUserEndpoint).Methods("PUT")
	log.Fatal(http.ListenAndServe(":3000", router))
}
