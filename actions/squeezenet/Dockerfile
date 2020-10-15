FROM bitnami/pytorch:1.5.1

WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY squeezenet1_0-a815701f.pth squeezenet1_0-a815701f.pth
COPY squeezenet1_1-f364aa15.pth squeezenet1_1-f364aa15.pth
COPY squeezenet.py squeezenet.py
COPY classifier.py classifier.py

ENTRYPOINT [ "python3", "-u", "classifier.py" ]
