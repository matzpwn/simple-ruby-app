FROM ubuntu:16.04

RUN set -ex \
    && apt-get update -y \
    && apt-get install build-essential curl sudo vim -y \
    && curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - \
    && apt-get install nodejs -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd ubuntu -m \
    && echo 'ubuntu ALL=(root) NOPASSWD: ALL' >> /etc/sudoers

COPY Gemfile /home/ubuntu/Gemfile
COPY run.sh /home/ubuntu/run.sh

RUN set -ex \
    && chown ubuntu:ubuntu /home/ubuntu/run.sh \
    && chmod +x /home/ubuntu/run.sh \
    && su - ubuntu -c 'gpg --keyserver hkp://keys.gnupg.net \
    --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
    7D2BAF1CF37B13E2069D6956105BD0E739499BDB' \
    && su - ubuntu -c '\curl -sSL https://get.rvm.io | bash -s stable' \
    && su - ubuntu -c 'source ~/.rvm/scripts/rvm' \
    && su - ubuntu -c 'rvm install 2.5.1' \
    && su - ubuntu -c 'rvm use 2.5.1 --default' \
    && su - ubuntu -c 'gem install rails' \
    && su - ubuntu -c 'rails new app --skip-gemfile' \
    && su - ubuntu -c 'mv ~/Gemfile ~/app/' \
    && su - ubuntu -c 'cd ~/app && bundle install' \
    && su - ubuntu -c 'gem clean'

EXPOSE 3000

CMD ["/home/ubuntu/run.sh"]