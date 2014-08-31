# Websocket Client

This is a simple websocket client for my study.
Please use eliir-socket library when your job or something needs.

### How to use

```
WebSocket.connect!("ws://localhost:8080/clients/1/echo")
WebSocket.recv |> IO.puts #=> "Some message"
WebSocket.send("Some message")
```
