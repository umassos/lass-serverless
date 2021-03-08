import flask
from flask import Flask
from mobilenet import mobilenet_v2
import torch

app = Flask(__name__)
app.debug = False
model = None

@app.route("/init", methods=["POST"])
def init():
    global model
    model = mobilenet_v2(pretrained=True)
    return ('OK', 200)

@app.route("/run", methods=["POST"])
def run():
    input_size=(1, 3, 224, 224)
    x = torch.randn(input_size)
    out = model(x)
    response = flask.jsonify({"message": "success"})
    response.status_code = 200
    return response

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
