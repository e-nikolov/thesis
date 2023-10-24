## Web Based Solution

Web based solution for running MPC in browsers on the client side via WebAssembly and WebRTC for peer-to-peer connectivity.

The lifecycle of a message between the workers of 2 peers, "Peer A" and "Peer B" looks like this:

![MPyC Web \label{osi-map-overlays}](../figures/mpyc-web.png){ height=90% }

1. Python Worker on Peer A

   - creates a message that contains a secret share computed via the mpyc, which serializes it to binary via struct.pack(). The resulting message is non-ascii, but when escaped can look like this:

   ```python
   b'\x06\x00\x00\x00\xc9\x93\\\xc0\xff\xff\xff\xff\x04\x00\x80\x99\x1b\x01'
   ```

   - worker calls a main thread function (sendRuntimeMessage) via a coincident proxy and passes the serialized value, as well as the destination Peer's ID (Peer B). The worker does not need to await the result of this call, but it does because of xworker.sync.

2. Coincident handles the message by:

   - (Worker) JSON.stringify() -> Atomics.wait()
   - (Main) JSON.parse() -> Run the Main Thread function -> Atomics.notify()

3. Main thread on Peer A fires an event to notify PeerJS that it needs to transport the message and immediately returns in order to not block the Worker

4. PeerJS serializes the message with some added fields via MessagePack and transmits it to Peer B

5. Main thread on Peer B receives the message and forwards it to the appropriate worker callback via coincident

6. Coincident does the JSON.stringify() -> Atomics.wait() stuff (?) from main to worker on Peer B

7. Worker on Peer B handles the message by passing it to an asyncio coroutine that is waiting for it or stores it for later use

### Implementation details

### Performance analysis

### Security analysis

#### Trust model

There still is a centralized service like in the Tailscale solution, but here it is self-deployed.

#### Identity

### Usability analysis
