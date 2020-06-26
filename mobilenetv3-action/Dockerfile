FROM bitnami/pytorch:1.5.1

WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY mobilenetv3_small_67.4.pth.tar mobilenetv3_small_67.4.pth.tar
COPY mobilenetv3.py mobilenetv3.py
COPY classifier.py classifier.py

ENTRYPOINT [ "python3", "-u", "classifier.py" ]
