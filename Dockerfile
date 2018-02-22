# From official ruby site
FROM ruby:2.5

# build essentials are those c tools and headers you get from xcode on the mac
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# make the application directory in the container
RUN mkdir /emrbear_accounts

WORKDIR /emrbear_accounts

# Copy Gemfile from current directory into container at /emrbear_accounts
COPY Gemfile /emrbear_accounts/Gemfile

# And the Gmfile lock file.
COPY Gemfile.lock /emrbear_accounts/Gemfile.lock

RUN bundle install

# Copy the rest of the application to the container
COPY . /emrbear_accounts