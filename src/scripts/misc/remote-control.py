import sys
import random
from http.server import BaseHTTPRequestHandler
from urllib import parse
from requests import get
import time
import base64
from os import system, remove
from urllib import parse

# Visit http://<parrot>:4071/ to view your screen
# Click anywhere on the image to send the same click to your screen

class GetHandler(BaseHTTPRequestHandler):

    def do_GET(self):

        # Wake screen
        system('tap-tap')

        # Get click X,Y
        params = dict(parse.parse_qsl(parse.urlsplit(self.path).query))
        if params.get("x", None):
            get("http://192.168.90.100:4070/injectMouseEvent?action=%s&x=%s&y=%s&id=%s" % ("down",params["x"],params["y"],0))
            get("http://192.168.90.100:4070/injectMouseEvent?action=%s&x=%s&y=%s&id=%s" % ("release",params["x"],params["y"],0))
            time.sleep(10)

        # Get screenshot to data uri
        ss_url = 'http://cid:4070/screenshot'
        ss_file = get(url=ss_url)
        ss_file = ss_file.json()['_rval_']
        time.sleep(10)
        img = open(ss_file, "rb").read()
        plot_bytes_encode = str(base64.b64encode(img))
        plot_bytes_encode = plot_bytes_encode[0:-1]
        plot_bytes_encode_fin = plot_bytes_encode[2:]
        stringpic = "data:image/png;base64," + plot_bytes_encode_fin

        self.send_response(200)
        self.send_header('Content-Type', 'text/html')
        self.end_headers()

        self.wfile.write(
            bytes(r"""
            <!doctype html>

            <html lang="en">
            <head>
            <meta charset="utf-8">

            <title>Lunars VNC</title>
            <meta name="description" content="Poor man's VNC">
            <meta name="author" content="Lunars https://github.com/Lunars/tesla">
            <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js'></script>
            <script>
                $(document).ready(function() {
                    $('img').on('click', function(t) {
                        var o = t.pageX - this.offsetLeft,
                            p = t.pageY - this.offsetTop;
                        window.location.href = `/?x=${o}&y=${p}`
                    })
                });
            </script>
            </head>

            <body>
                <img height='1920' width='1200' alt='cid' src='""" + stringpic + r"""'/>
            </body>
            </html>

            """, "utf8"))

        remove(ss_file)


if __name__ == '__main__':

    print('configuring iptables for port 4071')
    system('/usr/sbin/iptables -D INPUT -i parrot -p tcp -m tcp --dport 4071 -j ACCEPT')
    system('/usr/sbin/iptables -I INPUT -i parrot -p tcp -m tcp --dport 4071 -j ACCEPT')
    system('{ echo; sleep 1; echo; sleep 1; echo "iptables -t nat -D PREROUTING -i mlan0 -p tcp -m tcp --dport 4071 -j DNAT --to-destination 192.168.20.2:4071"; sleep 1; echo "iptables -t nat -I PREROUTING -i mlan0 -p tcp -m tcp --dport 4071 -j DNAT --to-destination 192.168.20.2:4071"; sleep 1; echo "iptables -D INPUT -p tcp --dport 4071 -j ACCEPT"; sleep 1; echo "iptables -I INPUT -p tcp --dport 4071 -j ACCEPT"; sleep 1; } | socat - tcp:parrot:telnet')

    from http.server import HTTPServer
    server = HTTPServer(('', 4071), GetHandler)
    print('Starting server, ctrl-c to stop')
    server.serve_forever()
