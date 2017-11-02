//
// Hands on setup
//

import org.apache.log4j.Logger
import org.apache.log4j.Level

Logger.getLogger("org").setLevel(Level.ERROR)
Logger.getLogger("akka").setLevel(Level.ERROR)

import org.apache.spark.graphx._
import org.apache.spark.rdd._

import scala.io.Source

// Examine data
Source.fromFile("./EOADATA/metro.csv").getLines().take(5).foreach(println)
Source.fromFile("./EOADATA/country.csv").getLines().take(5).foreach(println)
Source.fromFile("./EOADATA/metro_country.csv").getLines().take(5).foreach(println)

//
// Create vertex classes
//
class PlaceNode(val name: String) extends Serializable
case class Metro(override val name: String, population: Int) extends PlaceNode(name)
case class Country(override val name: String) extends PlaceNode(name)

//
// Read metros into vertices
//
val metros: RDD[(VertexId, PlaceNode)] =
  sc.textFile("./EOADATA/metro.csv").
     filter(! _.startsWith("#")).
     map { line =>  val row = line split ','
       (0L + row(0).toInt, Metro(row(1), row(2).toInt)) }

//
// Read countries into vertices
//
val countries: RDD[(VertexId, PlaceNode)] =
  sc.textFile("./EOADATA/country.csv").
     filter(! _.startsWith("#")).
     map { line => val row = line split ','
       (100L + row(0).toInt, Country(row(1))) }

//
// Import the metro -> country edges
//
val mclinks: RDD[Edge[Int]] =
  sc.textFile("./EOADATA/metro_country.csv").
    filter(! _.startsWith("#")).
    map { line => val row = line split ','
      (Edge(0L + row(0).toInt, 100L + row(1).toInt, 1)) }

//
// Concatentate vertices into a single RDD
//
val nodes = metros ++ countries

//
// Not sure what this does - the Coursera documentation doesn't say.
//
val metrosGraph = Graph(nodes, mclinks)

println("Viewing the first few vertices of the graph...")
metrosGraph.vertices.take(5)

println("....................")
println("....................")

println("Filter all edges that have a source vertexId of 1 (the first \"metro\" - Tokyo)")
println("and create a map of the destination vertices (the associated country - 101 == Japan)")

metrosGraph.edges.filter(_.srcId == 1).map(_.dstId).collect()

println("....................")
println("....................")

println("Filter all edges that have a destination vertexId of 103 (Country == China)")
metrosGraph.edges.filter(_.dstId == 103).map(_.srcId).collect()

println("....................")
println("....................")

println("Examining the graph")
println("Number of vertices : " + metrosGraph.numVertices)
println("Number of edges : " + metrosGraph.numEdges)


// Define min / max for reducing

def max(a: (VertexId, Int), b: (VertexId, Int)): (VertexId, Int) = {
  if (a._2 > b._2) a else b
}

def min(a: (VertexId, Int), b: (VertexId, Int)): (VertexId, Int) = {
  if (a._2 <= b._2) a else b
}

// Compute min / max degrees

// Which vertex contains the most "out" edges?
// Note that in this data set, each node (city) contains one out edge (country).

metrosGraph.outDegrees.reduce(max)

// Which vertex cotnains the most incoming edges edges?
// This will be the country with the most cities associated with it.

// Find the vertex with highest inDegree.
// Returns a tuple of (vertexId, inDegree)

println("....................")
println("....................")
val countryMax = metrosGraph.inDegrees.reduce(max)

// Find the vertex (country) matching the edge.
println("Find the node with the highest number of inDegrees:")
metrosGraph.vertices.filter(_._1 == countryMax._1).collect()

println("....................")
println("....................")
println("Find the number of vertices that have only one out edge: " + metrosGraph.outDegrees.filter(_._2 <= 1).count)




//
// Degree Histogram
//
println("....................")
println("....................")
println("Plot the degree histogram")

import breeze.linalg._
import breeze.plot._

//
// Define a function to create a histogram of degrees.
// Remember to include only country (with vertexId >= 100)
// This returns a list of tuples of (NumDegrees: Int, NumVerticesWithOutEdges: Int)
//
def degreeHistogram(net: Graph[PlaceNode, Int]): Array[(Int, Int)] =
  net.degrees.
    filter { case (vertexId, count) => vertexId >= 100 }.
    map(t => (t._2, t._1)).
    groupByKey.map(t => (t._1, t._2.size)).
    sortBy(_._1).
    collect()

//
// Get the probability distribution (degree distribution) from the
// degree histogram by normalizing the node degrees by the total
// number of nodes, so that the degree probabilities add up to one
//

val numberOfCountries = metrosGraph.vertices.filter { case (vertexId, count) => vertexId >= 100 }.count()
val metroDegreeDistribution = degreeHistogram(metrosGraph).map( {case (d, n) => (d, n.toDouble/numberOfCountries) })

//
// Graph the results
//
val f = Figure()


//
//
//
val p1 = f.subplot(2,1,0)
val x = new DenseVector(metroDegreeDistribution map (_._1.toDouble))
val y = new DenseVector(metroDegreeDistribution map (_._2))
p1.xlabel = "Degrees"
p1.ylabel = "Distribution"
p1 += plot(x, y)
p1.title = "Degree distribution"

//
// Histogram
//
val p2 = f.subplot(2,1,1)
val metrosDegrees = metrosGraph.degrees.filter { case (vid, count) => vid >= 100 }.map(_._2).collect()
p2.xlabel = "Degrees"
p2.ylabel = "Histogram of node degrees"
p2 += hist(metrosDegrees, 20)


//
// Network Connectedness and Clustering Components
//

//
// Add the contenients to the graph
//
// Continent <- Country <- Metro
//

case class Continent(override val name: String) extends PlaceNode(name)

val continents: RDD[(VertexId, PlaceNode)] = sc.
  textFile("./EOADATA/continent.csv").
  filter(! _.startsWith("#")).
  map { line =>
    val row = line split ','
    (200L + row(0).toInt, Continent(row(1))) // Add 200 to the VertexId to keep the indexes unique
  }

val cclinks: RDD[Edge[Int]] = sc.textFile("./EOADATA/country_continent.csv").
  filter(! _.startsWith("#")).
  map {line =>
    val row = line split ','
    Edge(100L + row(0).toInt, 200L + row(1).toInt, 1)
  }

// Concatentate all vertices / edges

val cnodes = metros ++ countries ++ continents
val clinks = mclinks ++ cclinks

val countriesGraph = Graph(cnodes, clinks)

// Import the GraphStream library

import org.graphstream.graph.implementations._

val graph: SingleGraph = new SingleGraph("countriesGraph")
graph.addAttribute("ui.stylesheet","url(file:.//style/stylesheet)")
graph.addAttribute("ui.quality")
graph.addAttribute("ui.antialias")

// Load vertices into GraphStream nodes
for ((id:VertexId, place:PlaceNode) <- countriesGraph.vertices.collect()) {
  val node = graph.addNode(id.toString).asInstanceOf[SingleNode]
  node.addAttribute("name", place.name)
  node.addAttribute("ui.label", place.name)
  if (place.isInstanceOf[Metro])
    node.addAttribute("ui.class", "metro")
  else if(place.isInstanceOf[Country])
    node.addAttribute("ui.class", "country")
  else if(place.isInstanceOf[Continent])
    node.addAttribute("ui.class", "continent")
}

// Load edges into GraphStream edges
for (Edge(x,y,_) <- countriesGraph.edges.collect()) {
  graph.addEdge(x.toString ++ y.toString, x.toString, y.toString,true).asInstanceOf[AbstractEdge]
}

graph.display()