import torch
from mobilenetv3 import mobilenetv3
import flask
from flask import Flask

app = Flask(__name__)
app.debug = False
model = None

@app.route("/init", methods=['POST'])
def init():
    global model
    model = mobilenetv3(mode="small")
    state_dict = torch.load('mobilenetv3_small_67.4.pth.tar', map_location=torch.device('cpu'))
    model.load_state_dict(state_dict)
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
