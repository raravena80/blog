---
title: "Parsing Deeply Nested JSON in Go"
date: 2017-04-28T16:28:29Z
lastmod: 2017-04-28T16:28:29Z
comments: true
categories:
 - go
 - json
 - gjson
tags: [ "json", "gjson", "go" ]
keywords: json gjson Ricardo Aravena
description: Challenges parsing nested json in Go
slug: parsing-nested-json-in-go

---

Parsing deeply nested json in Go is a bit challenging due to the fact that the language doesn't provide many helpers to do so. If you do that in Ruby or Python it's pretty straight forward running some like this in Python `j = json.load(jsonstring)` or in Ruby `j = JSON.load(jsonstring)`.

In go generally you have to prefine your structs and run through an `Unmarshal` function which means that most of the times you need to know ahead of time what the nest level and structure of your target json is to parse it. For example:

https://play.golang.org/p/Q4IHjBVSfY

```go
package main

import (
	"encoding/json"
	"fmt"
	"log"
)

var data = []byte(`
    {
        "client": {
                "id": "2212fw",
                "name": "Papupapa Hernandez",
                "email": "papupapa@gmail.com",
                "phones": ["554-223-2311", "332-232-2123"]
        }
    }
`)

type Client struct {
	Id     string   `json:"id"`
	Name   string   `json:"name"`
	Email  string   `json:"email"`
	Phones []string `json:"phones"`
}

type Info struct {
	Key Client `json:"client"`
}

func main() {

	var info Info
	if err := json.Unmarshal(data, &info); err != nil {
		log.Fatal(err)
	}
	fmt.Printf("%+v\n", info)

}
```

When you have deeply nested JSON this becomes a pain in the butt. Enter [gjson](https://github.com/tidwall/gjson), with this library thanks to [@tidwall](https://github.com/tidwall) we can parse n-level nested JSON that has hashes and arrays. This came in handy when parsing for example the following JSON:

<a name="jsonparse"></a>
```json
{
    "i$tems": {
        "it$em": [
            {
                "batt$ers": {
                    "ba$tter": [
                        {
                            "i$d": "1001",
                            "t$ype": "Regular"
                        },
                        {
                            "i$d": "1002",
                            "type": "Chocolate"
                        },
                        {
                            "i$d": "1003",
                            "t$ype": "Blueberry"
                        },
                        {
                            "i$d": "1004",
                            "t$ype": "Devil's Food"
                        }
                    ]
                },
                "$id": "0001",
                "$name": "Cake",
                "$ppu": 0.55,
                "$topping": [
                    {
                        "i$d": "5001",
                        "t$ype": "None"
                    },
                    {
                        "i$d": "5002",
                        "t$ype": "Glazed"
                    },
                    {
                        "i$d": "5005",
                        "t$ype": "Sugar"
                    },
                    {
                        "i$d": "5007",
                        "t$ype": "Powdered Sugar"
                    },
                    {
                        "i$d": "5006",
                        "t$ype": "Chocolate with Sprinkles"
                    },
                    {
                        "i$d": "5003",
                        "t$ype": "Chocolate"
                    },
                    {
                        "i$d": "5004",
                        "t$ype": "Maple"
                    }
                ],
                "ty$pe": "donut"
            }
        ]
    }
}
```

You can have something like this:

```go
package main

import (
        "encoding/json"
        "fmt"
        "github.com/tidwall/gjson"
        "io/ioutil"
        "os"
)

func main() {

        file, e := ioutil.ReadFile("./nested.json")
        if e != nil {
                fmt.Printf("File error: %v\n", e)
                os.Exit(1)
        }
        myJson := string(file)
        m, ok := gjson.Parse(myJson).Value().(map[string]interface{})
        if !ok {
                fmt.Println("Error")
        }

        jsonBytes, err := json.Marshal(m)
        if err != nil {
                fmt.Println(err)
        }
        fmt.Println(string(jsonBytes))
}
```

So the [gjson](https://github.com/tidwall/gjson) library allows you to Marshall to a bunch of empty interface{} types (at compile type) that at run time the basically become the 'maps' and 'slices' in a JSON structure.

Running the above code outputs:

```json
{"i$tems":{"it$em":[{"$id":"0001","$name":"Cake","$ppu":0.55,"$topping":[{"i$d":"5001","t$ype":"None"},{"i$d":"5002","t$ype":"Glazed"},{"i$d":"5005","t$ype":"Sugar"},{"i$d":"5007","t$ype":"Powdered Sugar"},{"i$d":"5006","t$ype":"Chocolate with Sprinkles"},{"i$d":"5003","t$ype":"Chocolate"},{"i$d":"5004","t$ype":"Maple"}],"batt$ers":{"ba$tter":[{"i$d":"1001","t$ype":"Regular"},{"i$d":"1002","type":"Chocolate"},{"i$d":"1003","t$ype":"Blueberry"},{"i$d":"1004","t$ype":"Devil's Food"}]},"ty$pe":"donut"}]}}
```

The issue now is how to access all these structures recursively. Enter the [reflect](https://golang.org/pkg/reflect/) package in Go. This package allows you to do things similar to in Ruby like `variable.is_a?(Hash)` or `variable.is_a?(Array)`

To solve the original problem with the [JSON](#jsonparse) above I had to write a little bit of code. So the problem is remove the `$` character from all the keys in the nested JSON structure. So now I have:

```go
package main

import (
        "encoding/json"
        "fmt"
        "github.com/tidwall/gjson"
        "io/ioutil"
        "os"
        "reflect"
        "regexp"
        "strings"
)

func iterate(data interface{}) interface{} {

        if reflect.ValueOf(data).Kind() == reflect.Slice {
                d := reflect.ValueOf(data)
                tmpData := make([]interface{}, d.Len())
                returnSlice := make([]interface{}, d.Len())
                for i := 0; i < d.Len(); i++ {
                        tmpData[i] = d.Index(i).Interface()
                }
                for i, v := range tmpData {
                        returnSlice[i] = iterate(v)
                }
                return returnSlice
        } else if reflect.ValueOf(data).Kind() == reflect.Map {
                d := reflect.ValueOf(data)
                tmpData := make(map[string]interface{})
                for _, k := range d.MapKeys() {
                        match, _ := regexp.MatchString("$", k.String())
                        typeOfValue := reflect.TypeOf(d.MapIndex(k).Interface()).Kind()
                        if match {
                                new_key := strings.Replace(k.String(), "$", "", -1)
                                if typeOfValue == reflect.Map || typeOfValue == reflect.Slice {
                                        tmpData[new_key] = iterate(d.MapIndex(k).Interface())
                                } else {
                                        tmpData[new_key] = d.MapIndex(k).Interface()
                                }
                        } else {
                                fmt.Println("debug")
                                if typeOfValue == reflect.Map || typeOfValue == reflect.Slice {
                                        tmpData[k.String()] = iterate(d.MapIndex(k).Interface())
                                } else {
                                        tmpData[k.String()] = d.MapIndex(k).Interface()
                                }
                        }
                }
                return tmpData
        }
        return data
}

func main() {

        file, e := ioutil.ReadFile("./nested.json")
        if e != nil {
                fmt.Printf("File error: %v\n", e)
                os.Exit(1)
        }
        myJson := string(file)
        m, ok := gjson.Parse(myJson).Value().(map[string]interface{})
        if !ok {
                fmt.Println("Error")
        }

        newM := iterate(m)
        jsonBytes, err := json.Marshal(newM)
        if err != nil {
                fmt.Println(err)
        }
        fmt.Println(string(jsonBytes))
}
```

which outputs (in prettified json):

```
{
    "items": {
        "item": [
            {
                "batters": {
                    "batter": [
                        {
                            "id": "1001",
                            "type": "Regular"
                        },
                        {
                            "id": "1002",
                            "type": "Chocolate"
                        },
                        {
                            "id": "1003",
                            "type": "Blueberry"
                        },
                        {
                            "id": "1004",
                            "type": "Devil's Food"
                        }
                    ]
                },
                "id": "0001",
                "name": "Cake",
                "ppu": 0.55,
                "topping": [
                    {
                        "id": "5001",
                        "type": "None"
                    },
                    {
                        "id": "5002",
                        "type": "Glazed"
                    },
                    {
                        "id": "5005",
                        "type": "Sugar"
                    },
                    {
                        "id": "5007",
                        "type": "Powdered Sugar"
                    },
                    {
                        "id": "5006",
                        "type": "Chocolate with Sprinkles"
                    },
                    {
                        "id": "5003",
                        "type": "Chocolate"
                    },
                    {
                        "id": "5004",
                        "type": "Maple"
                    }
                ],
                "type": "donut"
            }
        ]
    }
}
```

So there we have it. We were able to parse nested JSON using [gjson](https://github.com/tidwall/gjson) and then modify the keys for the structure so that none of them have the `$` sign.

Full code is available here: https://github.com/raravena80/carabobo/blob/master/jsonkeys/jsonkeys.go
