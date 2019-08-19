library(rjson)
library(rjson)
library(igraph)

x <- rjson::fromJSON(file = "net.json")




#x = '{ "id": "8", "offsetX": 0, "offsetY": 0, "zoom": 100, "gridSize": 0, "links": [ { "id": "13", "type": "default", "source": "9", "sourcePort": "10", "target": "11", "targetPort": "12", "points": [ { "id": "14", "type": "point", "x": 147.234375, "y": 133.5 }, { "id": "15", "type": "point", "x": 409.5, "y": 133.5 } ], "labels": [], "width": 3, "color": "gray", "curvyness": 50, "selectedColor": "rgb(0,192,255)" } ], "nodes": [ { "id": "9", "type": "default", "x": 100, "y": 100, "ports": [ { "id": "10", "type": "default", "x": 139.734375, "y": 126, "name": "Out", "alignment": "right", "parentNode": "9", "links": [ "13" ], "in": false, "label": "Out" } ], "name": "Node 1", "color": "rgb(0,192,255)", "portsInOrder": [], "portsOutOrder": [ "10" ] }, { "id": "11", "type": "default", "x": 400, "y": 100, "ports": [ { "id": "12", "type": "default", "x": 402, "y": 126, "name": "In", "alignment": "left", "parentNode": "11", "links": [ "13" ], "in": true, "label": "In" } ], "name": "Node 2", "color": "rgb(192,255,0)", "portsInOrder": [ "12" ], "portsOutOrder": [] } ] }'
#x2 = '{ "id": "8", "offsetX": 0, "offsetY": 0, "zoom": 100, "gridSize": 0, "links": [ { "id": "17", "type": "default", "source": "9", "sourcePort": "10", "target": "11", "targetPort": "12", "points": [ { "id": "18", "type": "point", "x": 147.234375, "y": 133.5 }, { "id": "19", "type": "point", "x": 409.5, "y": 83.5 } ], "labels": [ { "id": "20", "type": "default", "offsetX": 0, "offsetY": -23, "label": "0.05" }, { "id": "21", "type": "default", "offsetX": 0, "offsetY": -23, "label": "0.5" } ], "width": 3, "color": "gray", "curvyness": 50, "selectedColor": "rgb(0,192,255)" }, { "id": "22", "type": "default", "source": "9", "sourcePort": "10", "target": "13", "targetPort": "14", "points": [ { "id": "23", "type": "point", "x": 147.234375, "y": 133.5 }, { "id": "24", "type": "point", "x": 459.5, "y": 213.5 } ], "labels": [], "width": 3, "color": "gray", "curvyness": 50, "selectedColor": "rgb(0,192,255)" }, { "id": "25", "type": "default", "source": "9", "sourcePort": "10", "target": "15", "targetPort": "16", "points": [ { "id": "26", "type": "point", "x": 147.234375, "y": 133.5 }, { "id": "27", "type": "point", "x": 309.5, "y": 283.5 } ], "labels": [ { "id": "28", "type": "default", "offsetX": 0, "offsetY": -23, "label": "0.03" } ], "width": 3, "color": "gray", "curvyness": 50, "selectedColor": "rgb(0,192,255)" } ], "nodes": [ { "id": "9", "type": "default", "x": 100, "y": 100, "ports": [ { "id": "10", "type": "default", "x": 139.734375, "y": 126, "name": "Out", "alignment": "right", "parentNode": "9", "links": [ "17", "22", "25" ], "in": false, "label": "Out" } ], "name": "Node A", "color": "rgb(0,192,255)", "portsInOrder": [], "portsOutOrder": [ "10" ] }, { "id": "11", "type": "default", "x": 400, "y": 50, "ports": [ { "id": "12", "type": "default", "x": 402, "y": 76, "name": "In", "alignment": "left", "parentNode": "11", "links": [ "17" ], "in": true, "label": "In" } ], "name": "Node B", "color": "rgb(255,255,0)", "portsInOrder": [ "12" ], "portsOutOrder": [] }, { "id": "13", "type": "default", "x": 450, "y": 180, "ports": [ { "id": "14", "type": "default", "x": 452, "y": 206, "name": "In", "alignment": "left", "parentNode": "13", "links": [ "22" ], "in": true, "label": "In" } ], "name": "Node C (no label)", "color": "rgb(192,255,255)", "portsInOrder": [ "14" ], "portsOutOrder": [] }, { "id": "15", "type": "default", "x": 300, "y": 250, "ports": [ { "id": "16", "type": "default", "x": 302, "y": 276, "name": "In", "alignment": "left", "parentNode": "15", "links": [ "25" ], "in": true, "label": "In" } ], "name": "Node D", "color": "rgb(192,0,255)", "portsInOrder": [ "16" ], "portsOutOrder": [] } ] }'


y = rjson::fromJSON(x)
#y2 = rjson::fromJSON(x2)

model2matrix <- function(jsonmodel){
  linklist <- weightlist <- indexlist <- c()
  for(link in jsonmodel$links) {
    linklist <- c(linklist , link$source, link$target)
    for(linklabel in link$labels){
      weightlist <- c(weightlist, as.numeric(linklabel$label))
    }
  }
  g <- igraph::graph(linklist)
  E(g)$weight <- weightlist
  g
}


# For each node create a state
node2state <- function(nodes){
  # define state for each node
  for(node in nodes){
    thisstate <- heemod::define_state(
      cost = node$cost,
      utility = node$utility
    )
  }
}




