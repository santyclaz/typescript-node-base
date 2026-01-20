ARG VARIANT=24-trixie
FROM node:${VARIANT} AS dev

ARG NPM_GLOBAL=/usr/local/share/npm-global

# Add NPM global to PATH
ENV PATH=${NPM_GLOBAL}/bin:${PATH}
# Set NPM_global as prefix
RUN npm config -g set prefix ${NPM_GLOBAL}

# Install node packages
ARG NODE_PACKAGES="eslint tslint-to-eslint-config typescript"
RUN npm install -g ${NODE_PACKAGES} \
	&& npm cache clean --force > /dev/null 2>&1

WORKDIR "/workspace"
