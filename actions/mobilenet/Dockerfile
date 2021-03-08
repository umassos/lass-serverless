FROM bitnami/pytorch:1.5.1

WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY mobilenet_v2-b0353104.pth mobilenet_v2-b0353104.pth
COPY mobilenet.py mobilenet.py
COPY classifier.py classifier.py

ENTRYPOINT [ "python3", "-u", "classifier.py" ]
