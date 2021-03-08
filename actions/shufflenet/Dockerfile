FROM bitnami/pytorch:1.5.1

WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY shufflenetv2_x0.5-f707e7126e.pth shufflenetv2_x0.5-f707e7126e.pth
COPY shufflenetv2_x1-5666bf0f80.pth shufflenetv2_x1-5666bf0f80.pth
COPY shufflenet.py shufflenet.py
COPY classifier.py classifier.py

ENTRYPOINT [ "python3", "-u", "classifier.py" ]
