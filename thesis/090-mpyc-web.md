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

Another important aspect is the runtime performance due to the heavy operations involved in \as{mpc}s.

Fast startup time, low build and deployment complexity are less crucial but nice to have properties of the runtime, as they offer a better experience for both users and developers.

To summarize, our criteria for runtime selection are:

- Python ecosystem/package availability
- Runtime performance
- Startup, build and deployment time

#### Available Solutions

There are a number of available solutions for using Python in web browsers, falling under three main categories[@pyodideIntroMozilla] [@anvilPythonBrowser]:

1. Transcrypt[@transcryptRepo] - \gls{aot} JavaScript transpiler - the Python code is transpiled to JavaScript and the resulting code is executed by the browser at runtime. is an example project
2. Skulpt[@skulptDocs], Brython[@brythonDocs] - \gls{jit} JavaScript interpreters - the Python code is converted to JavaScript in the browser at runtime
3. Pyodide[@pyodideDocs], MicroPython[@microPythonDocs], RustPython[@rustPythonDocs] - \gls{wasm}[@wasmDocs] interpreters - a Python interpreter is implemented in a compiled language like C/C++/Rust/Go that can target WASM - a secure and efficient binary instruction format for a virtual machine that can run in browsers with close to native performance.

#### Ecosystem Availability

From the listed

#### Preliminary Runtime Benchmarks

We will measure the time it takes each Python runtime to execute a given set of benchmark functions to have a preliminary indication of how they might perform for MPyC. To put that data in context, we will also include the results for the native performance of Python's default implementation (CPython) as well as JavaScript running in a browser.

The results will be presented in terms of operations per second, for an input size of 100 000, e.g. if a script benchmarks integer additions, then a loop of 100 000 additions is considered 1 operation. Similarly if we are copying a list or generating a sequence of numbers, then a single operation will be a sequence of 100 000 numbers. This is done to keep the relative number of function calls much lower than the operation being tested, as function calls are generally more computationally expensive and can skew the results.

Additionally our setup will make sure to run each benchmark for at least 0.2 seconds in order to reduce the volatility of the results. It will start with a single iteration of the 100 000-sized operation and then exponentially increase the iterations until the time limit is reached.

The set of benchmark functions was chosen based on implementation simplicity and portability across the tested runtimes. We will only show a few code examples below for illustration purposes, but the full benchmark suite can be found on GitHub:

- **assign** - assigning a number to a variable

```python
def assign(iters=100_000):
    for _ in itertools.repeat(None, iters):
        x = 1
```

- **multiply** - multiplying two numbers

```python
def multiply(iters=100_000):
    for _ in itertools.repeat(None, iters):
        17 * 41
```

- **bigint** - large number arithmetics
- **randlist** - generates a list of 100 000 random integers
- **cpylist** - copies a pre-generated list of 100 000 integers
- **sortlist** - sorts a list of 100 000 integers
- **fibonacci** - generating the fibonacci sequence mod 100 000
   <!-- . The modulo is used because the numbers otherwise became too large and crashed on MicroPython: -->

```python
def fibonacci(n=100_000):
    if n < 2:
        return n
    a, b = 1, 2
    for _ in itertools.repeat(None, iters):
        a, b = b, (a + b) % 100_000
    return a
```

- **primes** - generates the prime numbers from 0 to 100 000

The following machine was used for conducting the tests:

- OS - Microsoft Windows
- CPU - AMD Ryzen 7 2700X
- RAM - 32 GB
- Browser: Google Chrome v123.0.6312.28

Table \ref{runtime-benchmarks} shows the benchmark results. A few interesting observations:

- JavaScript in a browser is a lot faster than native Python in most of the tests
<!-- except sorting? -->
- Transcrypt is faster than the other browser-based runtimes, probably because it is able to optimize the JavaScript code as it generates it ahead of time and it is also less focused on parity with CPython and more on interoperability with the JavaScript ecosystem
- The results vary quite a bit, e.g. Pyodide is faster than Brython at generating the fibonacci sequence, but slower at big int arithmetics and multiplications
- Pyodide appears to be faster on average than the other WASM-based and JS-based interpreters

|                 | **Benchmark** |              | **Results** |              | **(ops/sec)** |              |               |            |
| --------------- | ------------- | ------------ | ----------- | ------------ | ------------- | ------------ | ------------- | ---------- |
| \MB Project     | **assign**    | **multiply** | **bigint**  | **randlist** | **cpylist**   | **sortlist** | **fibonacci** | **primes** |
| \HF JavaScript  | 19,327        | 19,413       | 19,351      | 713          | 4,227         | 35           | 3,271         | 1,029      |
| \HF CPython     | 775           | 380          | 69          | 21           | 4,280         | 81           | 168           | 200        |
| \HL Transcrypt  | 1,289         | 1,285        | 1,282       | 176          | 6,135         | 35           | 337           | 1124       |
| \HLM Pyodide    | 400           | 111          | 26          | 5            | 4,425         | 45           | 53            | 73         |
| \HL Brython     | 292           | 166          | 45          | 0.7          | 5,076         | 67           | 9             | 45         |
| \HL MicroPython | 69            | 36           | 6           | 16           | 403           | 41           | 22            | 10         |
| \HL Skulpt      | 40            | 27           | 1           | 16           | 6,232         | 5.2          | 8             | 18         |
| \HL RustPython  | 60            | 59           | 8           | 0.8          | 525           | 0.1          | 6             | 6          |

Table: \label{runtime-benchmarks} Benchmark results of the Python runtimes measured in operations per second for inputs of size 100 000

#### Startup

#### Conclusions

Out of the discussed runtime options, Pyodide offers the widest support for packages from the standard library and third-party packages. None of the options support the sockets package due to browser limitations, but an alternative implementation can be built on top of the WebRTC API.

Out of those projects, Py

\newpage

| **Project**     | **Approach**                         | **Startup** | **Performance** | **Ecosystem**         |
| --------------- | ------------------------------------ | ----------- | --------------- | --------------------- |
| \MB Transcrypt  | transpiler (\as{aot})                | 0s          | fast            | $$(-)$$ n/a           |
| \HL Skulpt      | \as{js}-based interpreter (\as{jit}) | 0s          | slow            | $$(-)$$ n/a           |
| \HL Brython     | JS-based interpreter (JIT)           | 0s          | medium          | $$(-)$$ no numpy      |
| \HLM Pyodide    | \as{wasm}-based interpreter (JIT)    | 5s          | medium+         | $$(+)$$ asyncio       |
|                 |                                      |             |                 | $$(+)$$ numpy         |
|                 |                                      |             |                 | $$(+)$$ gmpy2         |
|                 |                                      |             |                 | $$(+)$$ scipy         |
|                 |                                      |             |                 | $$(+)$$ python wheels |
|                 |                                      |             |                 | $$(+)$$ filesystem    |
| \MB             |                                      |             |                 | $$(-)$$ no sockets    |
| \HL MicroPython | WASM-based interpreter (JIT)         | 1s          | slow            | $$(-)$$ n/a           |
| \HL RustPython  | WASM-based interpreter (JIT)         | 5s          | slow            | $$(-)$$ n/a           |

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

Another important aspect is the runtime performance due to the heavy operations involved in \as{mpc}s.

Fast startup time, low build and deployment complexity are less crucial but nice to have properties of the runtime, as they offer a better experience for both users and developers.

To summarize, our criteria for runtime selection are:

- Python ecosystem/package availability
- Runtime performance
- Startup, build and deployment time

#### Available Solutions

There are a number of available solutions for using Python in web browsers, falling under three main categories[@pyodideIntroMozilla] [@anvilPythonBrowser]:

1. Transcrypt[@transcryptRepo] - \gls{aot} JavaScript transpiler - the Python code is transpiled to JavaScript and the resulting code is executed by the browser at runtime. is an example project
2. Skulpt[@skulptDocs], Brython[@brythonDocs] - \gls{jit} JavaScript interpreters - the Python code is converted to JavaScript in the browser at runtime
3. Pyodide[@pyodideDocs], MicroPython[@microPythonDocs], RustPython[@rustPythonDocs] - \gls{wasm}[@wasmDocs] interpreters - a Python interpreter is implemented in a compiled language like C/C++/Rust/Go that can target WASM - a secure and efficient binary instruction format for a virtual machine that can run in browsers with close to native performance.

#### Ecosystem Availability

From the listed

#### Preliminary Runtime Benchmarks

We will measure the time it takes each Python runtime to execute a given set of benchmark functions to have a preliminary indication of how they might perform for MPyC. To put that data in context, we will also include the results for the native performance of Python's default implementation (CPython) as well as JavaScript running in a browser.

The results will be presented in terms of operations per second, for an input size of 100 000, e.g. if a script benchmarks integer additions, then a loop of 100 000 additions is considered 1 operation. Similarly if we are copying a list or generating a sequence of numbers, then a single operation will be a sequence of 100 000 numbers. This is done to keep the relative number of function calls much lower than the operation being tested, as function calls are generally more computationally expensive and can skew the results.

Additionally our setup will make sure to run each benchmark for at least 0.2 seconds in order to reduce the volatility of the results. It will start with a single iteration of the 100 000-sized operation and then exponentially increase the iterations until the time limit is reached.

The set of benchmark functions was chosen based on implementation simplicity and portability across the tested runtimes. We will only show a few code examples below for illustration purposes, but the full benchmark suite can be found on GitHub:

- **assign** - assigning a number to a variable

```python
def assign(iters=100_000):
    for _ in itertools.repeat(None, iters):
        x = 1
```

- **multiply** - multiplying two numbers

```python
def multiply(iters=100_000):
    for _ in itertools.repeat(None, iters):
        17 * 41
```

- **bigint** - large number arithmetics
- **randlist** - generates a list of 100 000 random integers
- **cpylist** - copies a pre-generated list of 100 000 integers
- **sortlist** - sorts a list of 100 000 integers
- **fibonacci** - generating the fibonacci sequence mod 100 000
   <!-- . The modulo is used because the numbers otherwise became too large and crashed on MicroPython: -->

```python
def fibonacci(n=100_000):
    if n < 2:
        return n
    a, b = 1, 2
    for _ in itertools.repeat(None, iters):
        a, b = b, (a + b) % 100_000
    return a
```

- **primes** - generates the prime numbers from 0 to 100 000

The following machine was used for conducting the tests:

- OS - Microsoft Windows
- CPU - AMD Ryzen 7 2700X
- RAM - 32 GB
- Browser: Google Chrome v123.0.6312.28

Table \ref{runtime-benchmarks} shows the benchmark results. A few interesting observations:

- JavaScript in a browser is a lot faster than native Python in most of the tests
<!-- except sorting? -->
- Transcrypt is faster than the other browser-based runtimes, probably because it is able to optimize the JavaScript code as it generates it ahead of time and it is also less focused on parity with CPython and more on interoperability with the JavaScript ecosystem
- The results vary quite a bit, e.g. Pyodide is faster than Brython at generating the fibonacci sequence, but slower at big int arithmetics and multiplications
- Pyodide appears to be faster on average than the other WASM-based and JS-based interpreters

|                 | **Benchmark** |              | **Results** |              | **(ops/sec)** |              |               |            |
| --------------- | ------------- | ------------ | ----------- | ------------ | ------------- | ------------ | ------------- | ---------- |
| \MB Project     | **assign**    | **multiply** | **bigint**  | **randlist** | **cpylist**   | **sortlist** | **fibonacci** | **primes** |
| \HF JavaScript  | 19,327            | 19,413       | 19,351      | 713          | 4,227         | 35           | 3,271         | 1,029      |
| \HF CPython     | 775           | 380          | 69          | 21           | 4,280         | 81           | 168           | 200        |
| \HL Transcrypt  | 1,289         | 1,285        | 1,282       | 176          | 6,135         | 35           | 337           | 1124       |
| \HLM Pyodide    | 400           | 111          | 26          | 5            | 4,425         | 45           | 53            | 73         |
| \HL Brython     | 292           | 166          | 45          | 0.7          | 5,076         | 67           | 9             | 45         |
| \HL MicroPython | 69            | 36           | 6           | 16           | 403           | 41           | 22            | 10         |
| \HL Skulpt      | 40            | 27           | 1           | 16           | 6,232         | 5.2          | 8             | 18         |
| \HL RustPython  | 60            | 59           | 8           | 0.8          | 525           | 0.1          | 6             | 6          |

Table: \label{runtime-benchmarks} Benchmark results of the Python runtimes measured in operations per second for inputs of size 100 000

#### Startup

#### Conclusions

Out of the discussed runtime options, Pyodide offers the widest support for packages from the standard library and third-party packages. None of the options support the sockets package due to browser limitations, but an alternative implementation can be built on top of the WebRTC API.

Out of those projects, Py

\newpage

| **Project**     | **Approach**                         | **Startup** | **Performance** | **Ecosystem**         |
| --------------- | ------------------------------------ | ----------- | --------------- | --------------------- |
| \MB Transcrypt  | transpiler (\as{aot})                | 0s          | fast            | $$(-)$$ n/a           |
| \HL Skulpt      | \as{js}-based interpreter (\as{jit}) | 0s          | slow            | $$(-)$$ n/a           |
| \HL Brython     | JS-based interpreter (JIT)           | 0s          | medium          | $$(-)$$ no numpy      |
| \HLM Pyodide    | \as{wasm}-based interpreter (JIT)    | 5s          | medium+         | $$(+)$$ asyncio       |
|                 |                                      |             |                 | $$(+)$$ numpy         |
|                 |                                      |             |                 | $$(+)$$ gmpy2         |
|                 |                                      |             |                 | $$(+)$$ scipy         |
|                 |                                      |             |                 | $$(+)$$ python wheels |
|                 |                                      |             |                 | $$(+)$$ filesystem    |
| \MB             |                                      |             |                 | $$(-)$$ no sockets    |
| \HL MicroPython | WASM-based interpreter (JIT)         | 1s          | slow            | $$(-)$$ n/a           |
| \HL RustPython  | WASM-based interpreter (JIT)         | 5s          | slow            | $$(-)$$ n/a           |

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
