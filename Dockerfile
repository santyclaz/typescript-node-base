ARG VARIANT=24-trixie
FROM node:${VARIANT} AS dev

ARG USERNAME=node

ARG NPM_GLOBAL=/usr/local/share/npm-global

# Add NPM global to PATH
ENV PATH=${NPM_GLOBAL}/bin:${PATH}
# Set NPM_global as prefix
RUN npm config -g set prefix ${NPM_GLOBAL}

# Install node packages
ARG NODE_PACKAGES="eslint tslint-to-eslint-config typescript"
RUN npm install -g ${NODE_PACKAGES} \
	&& npm cache clean --force > /dev/null 2>&1

# For persisting bash history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/cmdhistory/.bash_history" \
	&& mkdir /cmdhistory \
	&& touch /cmdhistory/.bash_history \
	&& chown -R $USERNAME /cmdhistory \
	&& echo "$SNIPPET" >> "/home/$USERNAME/.bashrc"

WORKDIR "/workspace"


# [STAGE] dev-claude
# - Sets up claude-code along with additional security protections
# - https://github.com/anthropics/claude-code/blob/74cc597eb5c1a604e955ce97e7e3b82524f1062c/.devcontainer/Dockerfile#L81-L91

FROM dev AS dev-claude

ARG CLAUDE_CODE_VERSION=latest

# Install Claude
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

# For persisting claude config
RUN mkdir -p /home/$USERNAME/.claude \
	&& chown -R node:node /home/$USERNAME/.claude

# Install deps for firewall script
RUN apt-get update && apt-get install -y --no-install-recommends \
	iptables \
	ipset \
	dnsutils \
	aggregate \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy and set up firewall script
# CAUTION: Running this script requires running with increased network privileges (e.g. NET_ADMIN)
# As a result, be very careful when modifying this block for security purposes
COPY .devcontainer/init-firewall.sh /usr/local/bin/
USER root
RUN mkdir -p /etc/sudoers.d
RUN chmod +x /usr/local/bin/init-firewall.sh && \
	echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
	chmod 0440 /etc/sudoers.d/node-firewall
USER $USERNAME
