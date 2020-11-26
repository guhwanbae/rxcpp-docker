PROJECT_ROOT=$(git rev-parse --show-toplevel)

docker run -it \
  --rm \
  --user=rxcppdev \
  -v ${PROJECT_ROOT}/workspace:/home/rxcppdev/workspace \
  --workdir=/home/rxcppdev/workspace \
  rxcppdev \
  /bin/bash
