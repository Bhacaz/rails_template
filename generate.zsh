rails new app --css=tailwind --javascript=importmap --skip-jbuilder --skip-test --skip-action-mailbox --skip-kamal
cd app
bin/rails app:template LOCATION=../template.rb
open http://localhost:3000
bin/rails s
