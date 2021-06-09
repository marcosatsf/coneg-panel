FROM python:3.8
WORKDIR /coneg-panel
COPY /build/web/ .
CMD ["python", "-m", "http.server", "8080"]