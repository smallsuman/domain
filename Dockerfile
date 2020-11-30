# Adapted from https://github.com/microsoft/vscode-dev-containers/blob/master/containers/python-3/.devcontainer/base.Dockerfile
# [Choice] Python version: 3, 3.9, 3.8, 3.7, 3.6
ARG VARIANT="3.9-slim-buster"
ARG PYTHON_VERSION="3.9.0"
ARG PYTHON_INSTALL_PATH="/usr/local/python${PYTHON_VERSION}"
ARG INSTALL_PYTHON_TOOLS="true"
FROM python:${VARIANT}

# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=freddie
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY ./.devcontainer/library-scripts/common-debian.sh /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common \
    # Install common packages, non-root user
    && bash /tmp/library-scripts/common-debian.sh "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Setup default python tools in a venv via pipx to avoid conflicts
ENV PIPX_HOME=/usr/local/py-utils \
    PIPX_BIN_DIR=/usr/local/py-utils/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}
COPY ./.devcontainer/library-scripts/python-debian.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/python-debian.sh "${PYTHON_VERSION}" "${PYTHON_INSTALL_PATH}" "${PIPX_HOME}" "${USERNAME}" "${INSTALL_PYTHON_TOOLS}" \ 
    && apt-get clean -y && rm -rf /tmp/library-scripts