## MPyC Web

This chapter presents the design of MPyC Web - an MPC connectivity solution based on web technologies (L7) that can run in web browsers.

Design goals:

- Uses the MPyC Python framework
- Runs in browsers (client-side) on both PCs and smartphones
- Peer-to-peer with a fallback to relaying
- Secure
- Simple to use

### Runtime

<!-- While Python is not natively supported in browsers that traditionally allow only -->

<!-- , including Python, with different tradeoffs -->

While web browsers natively support only JavaScript, there are approaches for enabling other languages as well. In the case of Python, the main options are[@pyodideIntroMozilla] [@anvilPythonBrowser]:

1. Transpilation - Python code is transpiled to JavaScript: Transcrypt[@transcryptRepo]
2. Python interpreter implementation in JavaScript: Skulpt[@skulptDocs], Brython[@brythonDocs]
3. Python interpreter compiled to WebAssembly[@wasmDocs]: Pyodide[@pyodideDocs], MicroPython[@microPythonDocs], RustPython[@rustPythonDocs]

The main differences between those approaches are in terms of:

- moment of compilation
- runtime load time
- performance
- Python ecosystem support

|             | approach         | compilation | load | performance | ecosystem                                                                                                                 |
| ----------- | ---------------- | ----------- | ---- | ----------- | ------------------------------------------------------------------------------------------------------------------------- |
| Transcrypt  | transpiler       | ahead       | 0 s  | slow        | (-)                                                                                                                       |
| Skulpt      | JS interpreter   | JIT         | ~0 s | slow        | (-)                                                                                                                       |
| Brython     | JS interpreter   | JIT         | ~0 s | slow        | (-)                                                                                                                       |
| Pyodide     | WASM interpreter | JIT         | ~5 s | fast        | (+) asyncio <br><br>(+) numpy  <br><br>(+) gmpy2 <br><br>(+) scipy  <br><br>(+) python wheels  <br><br>(-) sockets |
| MicroPython | WASM interpreter | JIT         | ~1 s | fast        | (-)                                                                                                                       |
| RustPython  | WASM interpreter | JIT         | ~5 s | fast        | (-)                                                                                                                       |

MPyC depends on several Python packages that are implemented in C, such as numpy, gmpy2, scipy and relies heavily on asyncio and sockets from the standard library. Out of the discussed runtime options, Pyodide offers the widest support for packages from the standard library and third-party packages. None of the options support the sockets package due to browser limitations, but an alternative implementation can be built on top of the WebRTC API.

<!--

The load time for the runtime of the python interpreter compiled to WebAssembly is around 5-10 seconds depending on the specific project.

The moment of compilation is not as important in our case but for context transpiling Python to JavaScript has to happen in a separate step ahead of time, while with the other approaches there is a Python interpreter in the browser, which allows it to execute the Python code and to modify it at runtime for demonstration purposes.

-->

<!--
Traditionally, web browsers support JavaScript, but the introduction of WebAssembly in 2017 made it possible to use other languages as well. Python
-->

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
