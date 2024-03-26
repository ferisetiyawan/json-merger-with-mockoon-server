# How to Build and Run
JSON Merger with Mockoon Server running in Container

Build the docker image:
```
docker build -t mockoon-server .
```

Run Image

Merge the JSON Collection and run the Mockoon Server. Make sure your JSON Files (generated using Mockoon UI is inside the folder `json_collection`)
```
docker run --rm -v $(pwd)/json_collection:/json-merger/json_collection -p 3000:3000 mockoon-server
```


Run the Mockoon Server with specific JSON or OPEN API Collection
```
docker run --rm -p 3000:3000 mockoon-server -d <File or URL of the API Collection>
```
