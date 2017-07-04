** START PAGE 141 **

# Netty #

* Channels are thread safe. Methods can be called from outside the channel's EventLoop.

* Channel / Pipeline / ChannelHandler (Intercepting Filter pattern).

* The "HEAD" of the Netty pipeline is toward the socket. The "tail" is toward the application.


<pre>
              <- Outbound handler <-                <- Outbound handler
        /                                                                           \
socket - HEAD                                                                         TAIL - Application
        \                                                                           /
                                 Inbound handler ->                 Inbound handler
</pre>


* SimpleChannelInboundHandler can help - it will automatically release
  messages. Make sure there is nothing further down the pipeline that is
  depending on these messages!

* ByteBuf


* Are channels thread safe?
	* Yes. All operations invoked on a channel will be processed on that channel's EventLoop.
* What are user events?
	* A user can manually pass a POJO through the ChannelPipeline.

## Resource Management ##

* RULE : If you consume a message on read (not pass down the pipeline), you are responsible
  for releasing it.

* RULE : If you discard a message on write (not pass down the pipeline), you are responsible
	for releasing it.

* Important : any ChannelInboundHandler that overrides channelRead() to process
  incoming messages is responsible for releasing resources.

	* Netty will WARN log unreleased resources, which is nice.
	  * set -Dio.netty.leakDetectionLevel=advanced (or paranoid) to determine where the leaked resource was last accessed.

	```

	public class DiscardHandler extends ChannelInboundHandlerAdapter {
		@Override
		public void channelRead(ChannelHandlerContext ctx, Object msg) {
			ReferenceCountUtil.release(msg);
		}
	}

	```
