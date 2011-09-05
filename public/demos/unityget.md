Here's a demo of how location querying should work. This is just a prototype and can be changed if you want. This isn't working yet, but I'll let you know when I write the items#nearby action so you can try it out.

This assumes that either Unity already has a JSON parser (I looked through the docs and didn't find one), or you have Douglas Crockford's json2 library loaded.

Here's a minified version of [json2.js](http://localcrud.herokuapp.com/demos/json2.js).

It should go in its own file and be loaded at the beginning of your script.

JSON is a much better transfer format than XML. It's smaller and just all around easier to work with, especially since you're already using javascript.

Ok, given all that, here's how you query a location:

```javascript
// declare variables
var baseURL, distance, httpRequest, location, response;

// the location part of the query should be formatted like this string
location  = "35.2821,-120.659";
distance  = 3; // in miles
baseURL   = "http://localcrud.herokuapp.com/items";

// make request
httpRequest = new WWW(baseURL+"/nearby/"+encodeURIComponent(location)+"/"+encodeURIComponent(distance)+"/miles.json");

// your url should look something like http://localcrud.herokuapp.com/items/nearby/35.2821%2C-120.659/3/miles.json
// you can try this in a browser to see what you'll get.

// wait for request to complete
yield httpRequest;

// check for errors
if (httpRequest.error === null) {
  // all good parse response
  response = JSON.parse(httpRequest.text);
  // DO STUFF HERE
} else {
  // not all good, log error
  Debug.Log("HTTP Request Error: " + httpRequest.error);
}
```

`response` will contain a javascript object with some metadata and an array of all the nearby items

```javascript
{
  params: { // these are the parameters from your query 
    location: "35.2821,-120.659",
    distance: 3,
    unit:     "miles"
  },
  items: [ // this is an array of items that were found nearby in order of distance
    { // item 0
      name: "first item",
      latlng: [35.2821,-120.659]
      distance: 0.0
    },
    { // item 1
      name: "second item"
      // ...
    }
  ]
}
```

You can access these as you normally would with an object:

```javascript
response.items[0].latlng[1]
=> -120.659
response.params.unit
=> "miles"
```
Hope this helps!