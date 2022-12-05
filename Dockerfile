# node > 14.6.0 is required for the SFDX-Git-Delta plugin
FROM node:17-alpine

#add usefull tools
RUN apk add --update git

# install Salesforce CLI from npm
RUN npm install sfdx-cli --global
RUN sfdx --version

# install SFDX-Git-Delta plugin - https://github.com/scolladon/sfdx-git-delta
RUN echo y | sfdx plugins:install sfdx-git-delta
RUN sfdx plugins