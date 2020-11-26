docker build -t rxcppdev \
  --build-arg userid=$(id -u) \
  --build-arg groupid=$(id -u) \
  .
