web: ./script/server --environment=$RAILS_ENV --port=$RAILS_PORT
shpinx: searchd --console --port $SPHINX_PORT --config $SPHINX_CONFIG
worker: bundle exec rake jobs:work
