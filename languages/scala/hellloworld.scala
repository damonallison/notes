//
// HelloWorld is a singleton.
//
// Scala does not have `static` methods or fields - scala uses
// singletons.
//
// All packages from java.lang are imported by default.


import java.util.{Date, Locale}
import java.text.DateFormat._

object HelloWorld {
    //
    // main() does not return a value.
    //
    // It is a procedure method. Therefore, it is not
    // necessary to declare a return type.
    //
    def main(args: Array[String]) {
        val now = new Date
        //
        // getDateInstance and LONG are imported from the `DateFormat` class.
        //
        val df = getDateInstance(LONG, Locale.FRANCE)
        println(df.format(now)
    }
}
