## MPyC Web

This chapter presents the design of MPyC Web - an MPC connectivity solution based on web technologies (L7) that can run in web browsers.

Design goals:

- Runs in browsers (client-side) on both PCs and smartphones
- Uses the MPyC Python framework with as few modifications as possible
- Peer-to-peer with a fallback to relaying
- Secure
- Simple to use

### Python Runtime Selection

<!-- While Python is not natively supported in browsers that traditionally allow only -->

<!-- , including Python, with different tradeoffs -->
#### Selection Criteria

While web browsers natively support only \gls{js}, there are approaches with different tradeoffs that can enable other languages, including Python. In this section we will investigate several web-based Python runtimes and choose the most appropriate one for MPyC Web.

MPyC depends on several Python packages that are implemented in C, such as numpy, gmpy2, scipy and relies heavily on asyncio and TCP sockets from Python's standard library. The runtime we choose should support as many of those dependencies as possible to avoid having to find alternatives or reimplement them.

Another important aspect is the runtime performance due to the heavy operations involved in \as{mpc}s. We will benchmark each runtime by measuring the time it takes to execute a simple Python script that adds numbers in a loop.

Fast startup time, low build and deployment complexity are less crucial but nice to have properties of the runtime, as they offer a better experience for both users and developers.

To summarize, our criteria for runtime selection are:

- Python ecosystem/package availability
- Runtime performance
- Startup, build and deployment time

#### Available Approaches

The approaches for using Python in web browsers can be split into three categories[@pyodideIntroMozilla] [@anvilPythonBrowser]:

1. Transpiler-based: the Python code is transpiled to JavaScript \gls{aot} and the resulting code is executed by the browser at runtime
2. JavaScript interpreter-based: the Python code is interpreted \gls{jit} in the browser by a software package implemented in JavaScript
3. \gls{wasm}[@wasmDocs] interpreter-based: similar to the previous category, but the interpreter can be implemented in any language that can be compiled to WASM - a secure and efficient binary instruction format for a virtual machine that can run in browsers. WASM can be targeted by compiled languages like C/C++/Rust/Go to create web applications with near-native performance.



WASM is 

#### Preliminary Benchmarks


#### 

- <!-- Transcrypt[@transcryptRepo -->]
- <!--  Skulpt[@skulptDocs], Brython[@brythonDocs]    --> 
- <!-- Pyodide[@pyodideDocs], MicroPython[@microPythonDocs], RustPython[@rustPythonDocs]   --> 
- 

|                 | **Benchmark** |              | **Results** |              | **(ops/sec)** |              |               |            |
| ------------------ | ---------- | ------------ | ----------- | ------------ | ------------- | ------------ | ------------- | ---------- |
| \MB Project     | **assign**    | **multiply** | **bigint**  | **randlist** | **cpylist**   | **sortlist** | **fibonacci** | **primes** |
| \HF Native      | 775           | 360          | 69          | 21           | 4,280         | 78           | 152           | 196        |
| \HL Transcrypt  | 1,152         | 1,270        | 1,179       | 65           | 6,135         | 524          | 337           | 971        |
| \HL Skulpt      | 40            | 27           | 1           | 16           | 6,232         | 5.2          | 8             | 18         |
| \HL Brython     | 292           | 166          | 45          | 0.7          | 5,076         | 67           | 9             | 45         |
| \HLM Pyodide    | 400           | 111          | 26          | 5            | 4,425         | 45           | 53            | 73         |
| \HL MicroPython | 69            | 35           | 6           | 16           | 388           | 41           | 22            | 10         |
| \HL RustPython  | 60            | 59           | 8           | 0.8          | 525           | 0.1          | 5             | 6          |

Table: Benchmark results of the Python runtimes measured in operations per second for inputs of size 100 000

 


 Out of the discussed runtime options, Pyodide offers the widest support for packages from the standard library and third-party packages. None of the options support the sockets package due to browser limitations, but an alternative implementation can be built on top of the WebRTC API.

Out of those projects, Py

\newpage


| **Project**     | **Approach**                         | **Startup** | **Benchmark** | **Ecosystem**         |
| --------------- | ------------------------------------ | ----------- | ------------- | --------------------- |
| \MB Transcrypt  | transpiler (\as{aot})                | 0s          | slow          | $$(-)$$ n/a           |
| \HL Skulpt      | \as{js}-based interpreter (\as{jit}) | 0s          | slow          | $$(-)$$ n/a           |
| \HL Brython     | JS-based interpreter (JIT)           | 0s          | 1,370 op/s    | $$(-)$$ no numpy      |
| \HLM Pyodide    | \as{wasm}-based interpreter (JIT)    | 5s          | 298 op/s      | $$(+)$$ asyncio       |
|                 |                                      |             |               | $$(+)$$ numpy         |
|                 |                                      |             |               | $$(+)$$ gmpy2         |
|                 |                                      |             |               | $$(+)$$ scipy         |
|                 |                                      |             |               | $$(+)$$ python wheels |
|                 |                                      |             |               | $$(+)$$ filesystem    |
| \MB             |                                      |             |               | $$(-)$$ no sockets    |
| \HL MicroPython | WASM-based interpreter (JIT)         | 1s          | fast          | $$(-)$$ n/a           |
| \HL RustPython  | WASM-based interpreter (JIT)         | 5s          | fast          | $$(-)$$ n/a           |

Table: Summary of Python runtimes for browsers

<!--

The load time for the runtime of the python interpreter compiled to WebAssembly is around 5-10 seconds depending on the specific project.

The moment of compilation is not as important in our case but for context transpiling Python to JavaScript has to happen in a separate step ahead of time, while with the other approaches there is a Python interpreter in the browser, which allows it to execute the Python code and to modify it at runtime for demonstration purposes.

-->

<!--
Traditionally, web browsers support JavaScript, but the introduction of WebAssembly in 2017 made it possible to use other languages as well. Python
-->
### Design of MPyC Web
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
