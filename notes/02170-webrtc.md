## WebRTC

- Peer to peer communications for browsers
    - can also work without a browser
    - Mainly used for multimedia communications - Peer-to-peer Audio/Video/VoIP
- Spec - [https://www.w3.org/TR/webrtc/](https://www.w3.org/TR/webrtc/#persistent-information-exposed-by-webrtc)
- Uses [nat](02021-internet-protocol.md) STUN/TURN/ICE
- Data is encrypted
- Identity
    - Session Description Protocol (SDP)
    - peer certificates are generated and announced over SDP
    - ICE Candidates are negotiated for STUN/TURN connections
- Not a VPN
    - I think it can’t serve as a TCP/IP network overlay that other applications can use
- Does not require additional plugins or native apps
- We could design a solution based on WebRTC in a browser by compiling the MPyC demos to web assembly or using PyScript.
	- https://www.win.tue.nl/~berry/mpyc/pyscript.html
	- https://pyscript.net/
- There seem to be many publicly available services that can be used as ICE servers for WebRTC
    - [stun.l.google.com:19302](http://stun.l.google.com:19302/)
    - [https://gist.github.com/zziuni/3741933](https://gist.github.com/zziuni/3741933)
- Examples
    - [https://github.com/pion/webrtc](https://github.com/pion/webrtc)
    - https://github.com/pion/awesome-pion
    - [https://github.com/pojntfx/weron](https://github.com/pojntfx/weron)
    - https://github.com/takutakahashi/wg-connect
    - https://github.com/stv0g/cunicu
    - https://github.com/gavv/webrtc-cli
    - https://github.com/szpnygo/gtc
    - https://github.com/cretz/webrtc-ipfs-signaling
    - https://github.com/pion/example-webrtc-applications
    - https://github.com/pion/webrtc/tree/master/examples
- Resources
    - [https://webrtcforthecurious.com/](https://webrtcforthecurious.com/)
    - [https://temasys.io/guides/developers/webrtc-ice-sorcery/](https://temasys.io/guides/developers/webrtc-ice-sorcery/)
    - [https://web.dev/webrtc-basics/](https://web.dev/webrtc-basics/#toc-rtcpeerconnection)