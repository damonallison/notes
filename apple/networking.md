## Networking Concepts ##

[Networking Concepts][networking-concepts] explains at a *very* high level what TCP/IP, the layers of networking addressing / dns, and routing. It is intended to give you an overview of networking, a prerequisite for writing solid networking code.

### Network Terminology ###

Host : a connected device offering and endpoint (port) for some functionality. It's a host because it's *hosting* a service.

Infrastructure Device : Hub / switch through which data routes. 

Packet : Header / payload / trailer (checksum). Payload is 45-1500 bytes. The payload is MTU controlled. 


### Networking Layers ###

Application Layer
Transport Layer (TCP / UDP)
IP Layer
Link Layer (ethernet / bluetooth / cellular / firewire)

#### Link Layer ####

From an application point of view, you don't typically touch the link layer. The OS will encapsulate the physical network layer from you.

Each link layer device (ethernet card, bluetooth card) has a unique HW address.

Switched Network : packets are only transmitted down a particular wire if a HW device has been seen previouly on that wire. 

Shared Network : Every host sees every packet on the network (hub).


#### IP Layer ####

The IP layer provides packet transport across routers / hops.
The IP layer splits packets to accommodate for differing MTU (Maximum Transmission Unit).

*Note* : Most modern OS's use MTU discovery to pre-calculate the maximum MTU from source -> destination to avoid fragmentation.

IPv4 : 32 bit address in 255.255.255.255 format
IPv6 : 128 bit addresses in 0000:0000:0000:0000:0000:0000:0000:0000 format.

There are a few optimizations to IPv6 address formatting:

* Leading 0's can be omitted, as long as there is one number remaining in the group:

0:0:0:0:0:0:0:1

* If an IPv6 address contains multiple octets of 0's in a row, you can omit all these groups and replace them with an `::`. This can only be done once per address.

::1

#### Transport Layer ####

TCP / UDP add *port numbers* to IP. Port numbers allow a single host to provide multiple services.

##### UDP #####

No retransmission : destination must handle retransmission. Useful for low-latency (real time gaming).

No confirmation / flow control. You can clog the network if using UDP inappropriately.

No MTU discovery. You should determine the maximum MTU for a path prior to sending massive amounts of UDP data to avoid fragmentation.

**General rule** : Use TCP unless you know you absolutely need UDP.

###### Features that UDP supports / TCP does not #######

* Broadcasting : packets sent to a broadcast address reach all on it's broadcast domain.

* Multicast : UDP packets sent to a multicast address are sent to all hosts that subscribes to them.

* Message (record) boundaries : clients see UDP "messages", not a byte stream as in TCP.

##### TCP #####

Features:

Guaranteed, ordered packet delivery with automatic retransmission of failed packets.
Congestion control : will "back off" if data is getting dropped due to over-utilization.

Stream based : the receiving end deals with a stream, not a set of messages as in UDP. If you want to use UDP for message delivery, you need some form of protocol.

Path MTU discovery (reduces / eliminates fragmentation).

### Packet Routing and Delivery ###

Before sending packets, the sender needs to know the link layer address (MAC) of the destination. ARP (Address Resolution Protocol) is used to obtain the link layer address. ARP broadcasts a request for the link layer address for a particular IP. The owner of the IP responds with their link layer address.

IPv6 uses NDP (Neighbor Discovery Protocol) - based on ICMP.

#### IPv4 Routing #####

32 bit address divided into a network and host portion by a subnet mask. 

The host uses it's local network to determine whether to send packets directly to a destionation host or through it's default gateway.

Subnets can range from 8 to 24 bits.

subnet : 255.0.0.0 == /8 subnet
         255.255.255.0 == /24 subnet

Within a particular subnet, there are 3 special addresses reserved:

1. Broadcast Address : where all host bits are 1. Sending packets to this host will broadcast it to all hosts on the subnet. Packets to this host will never leave the subnet.

2. Network Address : where all host bits are 0. Not used - kept for historical reasons.

3. Router Address : The address for your router - must be local to the subnet. Usually the router address is 1 bit higher than the network address, but that's not a hard rule.

#### IPv6 Routing ####

An IPv6 address is divided into two parts :

1. 64 bit network identifier. The network identifier is divided into 2 parts:

	Global routing prefix: tells which service provider owns the number. 
	Subnet ID: Identifies the network within the customer site. Arbitrarily organized by the customer.

	An ISP assigning a network to a big company may give them a /48 bit global routing prefix, allowing them to build 2^16 networks. An ISP assigning to a single home may be given a /64 prefix, so they can only have a single network. 

2. 64 bit interface identifier. Each address is typically generated from the link's MAC address.

Differences between IPv4 and IPv6 : 

	* No reserved broadcast or network address. A special "link local all-nodes" multicast group (ff02::1) provides broadcast functionality. 

	* No variable sized subnets. The interface identifier is always 64 bits.


#### Firewalls and NAT ####



## Links ##

[networking-concepts](https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Conceptual/NetworkingConcepts/Introduction/Introduction.html#//apple_ref/doc/uid/TP40012487)





# WWDC 2012 (Session 706) Networking Best Practices #
## TCP ##

Reuse connections where possible. TCP needs to warm up a connection (slow start). New connections
cost time. Handshake, slow start, reconnect timers, packet loss sensitivity.

Flood the send buffer when possible.

When receiving reachability changes (wifi comes on), attempt a second connection and if successful,
close the first.

Fetch data in bursts (cellular in particular). When cellular radio is on, antenna in "high power
mode".

## HTTP ##

HTTP Proxy : pulls response from cache (if available on proxy) - otherwise the request is forwarded
to the server.

Persistent Connections (HTTP 1.1) : single connection, multiple requests.
Pipelined requests : send all requests at once, retrieve all responses in order.

  1. Get root document
  2. Get all subsequent resources in one request.

## APIs ##

* CFSocketStream : 
	run loop / CF type integration.
	triggers cellular / vpn on demand.
	tls / ssl server|client auth.
	socks proxy support

* Cocoa (NS):

	* CFStreamCreatePairWIthSocketToHost : convert CF to NS (CFInputStream -> NSInputStream, CFOutputStream -> NSOutputStream)
	

iOS6 Cellular Fallback:

	* If socket connect fails, it tries over WWAN (if connection fails on WIFI).
	* You can prevent cellular fallback (kCFStreamPropertyNoCellular).
	* kCFStreamPropertyConnectionIsCellular.


TCP : CFSocketStream : connect by hostname API - API will determine the best address to use, will
try all addresses. Built in support for TLS / SSL / SOCKS proxies (not enabled by default).

iOS6 : cellular fallback - tries to connect over wifi. If fails, tries over cellular (people
blocking facebook?) - can be disabled.

NSSocketStream : create in CF.

CFStreamCreatePairWithSocketToHost

Don't use CFHTTPStream. Use NSURLConnection (best API for HTTP / HTTPS). Handles TLS / cookies /
proxies automatically).


## Debugging ##

* tcptrace
* Network Link Conditioner

* CFNetwork
* CFSocketStream

CFNETWORK_DIAGNOSTICS : environment variable (useful for debugging).
CFNETWORK_IO_LOG_FILE : environment variable for logging to file.

Debugging connection problems (CFSocketStream and above) : 

Turn on logging:

	sudo defaults write /Library/Preferences/com.apple.networkd libnetcore_log_level -int 7

Turn off logging:

	sudo defaults delete /Library/Preferences/com.apple.networkd libnetcore_log_level

Viewing Log:

	syslog -w

tcpdump -k (show pid) :: new libpcap format

Remote packet capture (for debugging on iOS):
	
	rvictl -s <UDID>  :: creates virtual network interface (rvi0) you can use w/ tcpdump)

tcptrace : traces through TCP / HTTP connections and helps you diagnose problems.

View tcptrace output in jplot / xplot (for viewing tcptrace output).

Turn on network link conditioner to simulate a slow network on iOS :

	Settings->Developer->Network Link Conditioner


Quinn : Networking Apps for iPhone OS, Part 1 and 2 (WWDC 2010)

