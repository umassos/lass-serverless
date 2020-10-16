import flask
from flask import Flask
import os
import random
import sys
sys.path.append("./binaryalert/")

from lambda_functions.analyzer import yara_analyzer
from rules import compile_rules
from lambda_functions.analyzer.common import COMPILED_RULES_FILENAME


app = Flask(__name__)
app.debug = False
analyzer = None


@app.route("/init", methods=["POST"])
def init():
    global analyzer
    compile_rules.compile_rules(COMPILED_RULES_FILENAME)
    analyzer = yara_analyzer.YaraAnalyzer(COMPILED_RULES_FILENAME)
    return ("OK", 200)


@app.route("/run", methods=["POST"])
def run():
    test_filename = random.choice(os.listdir("./test_files/"))
    matches = analyzer.analyze(os.path.join("/app/test_files/", test_filename))
    print(test_filename, matches)
    response = flask.jsonify([match.rule_name for match in matches])
    response.status_code = 200
    return response


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
