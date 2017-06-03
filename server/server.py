from http.server import BaseHTTPRequestHandler, HTTPServer
from gamehandler import *

game_state = GameState()

# HTTPRequestHandler class
class testHTTPServer_RequestHandler(BaseHTTPRequestHandler):
    # For now, all GET requests return the index page
    def do_GET(self):
        print("Got GET request for: ", self.path)

        self.send_response(200)

        if self.path == "/":
            self.path = "/index.html"
        path = "../frontend/output" + self.path

        file_extension = path.split(".")[-1]

        if file_extension == "html":
            self.send_header('content-type', 'text/html')
        elif file_extension == "css":
            self.send_header('content-type', 'text/css')
        elif file_extension == "js":
            self.send_header('content-type', 'text/javascript')
        else:
            self.send_header('content-type', 'text/text')
        self.end_headers()


        print(path)
        with open(path) as page:
            self.wfile.write(bytes(page.read(), 'utf8'))

        return

    # POST requests, used for actual data
    def do_POST(self):

        body=self.rfile.read(int(self.headers['Content-Length']))
        body=body.decode("utf-8")
        print(body)
        message = handle_request(body,game_state)
        print(message)
        #if self.path.endswith("/penis"):
        # Send response status code
        self.send_response(200)

        # Send headers
        self.send_header('Content-type','text/html')
        self.end_headers()

        # Send message back to client
        # message = "Hello world!"
        # Write content as utf-8 data
        self.wfile.write(bytes(message, "utf8"))
        return

def run():
    print('starting server...')

    # Server settings
    # Choose port 8080, for port 80, which is normally used for a http server, you need root access
    server_address = ('127.0.0.1', 8081)
    httpd = HTTPServer(server_address, testHTTPServer_RequestHandler)
    print('running server...')
    httpd.serve_forever()


run()
