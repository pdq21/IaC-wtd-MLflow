ARG BASEIMAGE="docker.io/library/python:3.7-alpine"
ARG BASEIMAGE_USECASE="devtools"


FROM --platform=x86_64 ${BASEIMAGE} as devtools

LABEL io.while-true-do.site="https://while-true-do.io"
LABEL io.while-true-do.blog="https://blog.while-true-do.io"
LABEL io.while-true-do.code="https://github.com/whiletruedoio"
LABEL io.while-true-do.mail="hello@while-true-do.io"
#LABEL io.while-true-do.image.authors="dschier@while-true-do.io"

ARG USER="user"
ARG HOME="/home/${USER}"
ARG LIBGITVER="1.4.1"
ARG LIBGIT2="/lib64"

RUN set -xe \
  && adduser -D -h ${HOME} ${USER} \
  && apk add git \
  && apk add --no-cache --virtual .tmp-build-deps \
    openssl-dev cmake build-base libffi-dev libc-dev
#install libgit2 from source, no latest alpine pkgs provided
#libgit uses non-standard install path
#https://pkgs.org/search/?q=libgit
#https://www.pygit2.org/install.html#install-libgit2-from-source
RUN set -xe \
  && lgtmp="/libgit-temp" \
  && lgtar="${LIBGITVER}.tar.gz" \
  && lgurl="https://github.com/libgit2/libgit2/archive/refs/tags/v${lgtar}" \
  && mkdir -p $lgtmp && cd $lgtmp \
  && wget $lgurl -O $lgtar && tar xzf $lgtar && rm -f $lgtar \
  && cd "libgit2-${LIBGITVER}" \
  && cmake . -DCMAKE_INSTALL_PREFIX=$LIBGIT2 \
  && cmake --build . --target install \
  && cd / && rm -rf $lgtmp


FROM --platform=x86_64 ${BASEIMAGE_USECASE} as usecase

LABEL io.while-true-do.site="https://while-true-do.io"
LABEL io.while-true-do.blog="https://blog.while-true-do.io"
LABEL io.while-true-do.code="https://github.com/whiletruedoio"
LABEL io.while-true-do.mail="hello@while-true-do.io"
#LABEL io.while-true-do.image.authors="dschier@while-true-do.io"

ARG USER="user"
ARG HOME="/home/${USER}"
ARG FILES_IN="files/usr"
ARG FILES_USR="${HOME}/.local/bin"
ARG EP="${FILES_USR}/entrypoint.sh"
ARG MLFLOW_GET_EXTRAS=""

#ERROR BLAS (Basic Linear Algebra Subprograms)
#or LAPACK (Linear Algebra PACKage) not found
#https://stackoverflow.com/questions/33368261/what-is-the-easiest-way-to-install-blas-and-lapack-for-scipy
#https://pkgs.org/download/lapack
RUN set -xe \
  && apk add --no-cache lapack lapack-dev \
    libgfortran libgcc libquadmath musl blas blas-dev \
    postgresql-dev libffi-dev libressl-dev libxml2 \
    libxml2-dev libxslt libxslt-dev libjpeg-turbo-dev zlib-dev

USER ${USER}
WORKDIR ${HOME}

#ENV ATLAS=""
#ENV LAPACK="/usr/lib/"

#alpine musl and python wheels
#'musl-libc is not compatible to Python's Wheels format,
#all packages installed with pip have to be built from source'
#https://stackoverflow.com/questions/54890328/installing-pandas-in-docker-alpine
#MLflow extras
#https://github.com/mlflow/mlflow/blob/master/EXTRA_DEPENDENCIES.rst
RUN set -xe \
  && python3 -m pip install --upgrade pip \
  && pip install --no-cache --user scipy
RUN set -xe \
  && pip install --no-cache --user pandas
RUN set -xe \
  && pip install --no-cache --user mlflow[${MLFLOW_GET_EXTRAS}] \
  && rm -rf ${HOME}/.cache

COPY --chown=${USER}:${USER} ${FILES_IN} ${FILES_USR}
RUN chmod +x ${EP}
RUN ${EP}

CMD sh
#ENTRYPOINT dvc ${GITNAME} ${GITDOMAIN}

USER root
RUN apk del .tmp-build-deps \
  && rm -rf /var/cache/apk/* /tmp/* \
    /usr/lib/python*/ensurepip
