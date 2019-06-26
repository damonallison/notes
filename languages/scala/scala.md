# Scala

```scala
//
// Imports multiple classes from the same package.
//
import java.util.{Date, Locale}
//
// Imports *all* classes. Same as .* in java.
//
import java.text.DateFormat._

//
// HelloWorld is a singleton.
//
// Scala does not have `static` methods or fields - scala uses
// singletons.
//
object HelloWorld {
    //
    // main() does not return a value.
    //
    // It is a procedure method. Therefore, it is not
    // necessary to declare a return type.
    //
    def main(args: Array[String]): Unit {
        val now = new Date
        val df = getDateInstance(LONG, Locale.FRANCE)
        //
        // Same as:
        // println(df.format(now))
        println(df format now)
    }
}
```

* Seamless integration w/ Java.
  * `java.lang` imported by default.
  * Just import other java classes.

