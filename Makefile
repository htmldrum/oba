test:
bundle exec spring rspec && bundle exec brakeman && make rubocop
rubocop:
bundle exec rubocop -DRa -c .prubocop.yml
watch:
while true; do spring rspec; sleep 1; done
rdb:
heroku pg:psql
rc:
heroku run rails console
rdb_status:
heroku pg
ssh:
heroku run bash
deploy:
git push heroku master && heroku run rake db:migrate && ruby ./bin/deploy
docs:
bundle exec rake docs:generate
populate_sites:
RAILS_ENV='prod' bundle exec rake 'db:populate_sites[200]'
.PHONY:	test watch rdb rc rdb_status ssh deploy docs rubocop populate_sites
