FROM public.ecr.aws/lambda/ruby:2.7

RUN yum install -y gcc gcc-c++ make mysql-devel \
 && rm -rf /var/cache/yum/* \
 && yum clean all

COPY Gemfile ${LAMBDA_TASK_ROOT}

ENV GEM_HOME=/usr/local/bundle/gems
RUN mkdir -p ${GEM_HOME} \
 && bundle install

COPY app.rb ${LAMBDA_TASK_ROOT}

CMD [ "app.LambdaFunction::Handler.process" ]
