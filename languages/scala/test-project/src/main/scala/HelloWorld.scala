import java.util.{Date, Locale}

//
// import everything from DateFormat
//
import java.text.DateFormat._

object HelloWorld {
  def main(args: Array[String]): Unit = {
    val now = new Date
    val df = getDateInstance(LONG, Locale.FRANCE)
    println(df format now)
  }
}
