
theme=$1

if test $theme; then
curl http://bootswatch.com/$theme/bootstrap.min.css -o public/css/bootstrap.min.css
curl http://bootswatch.com/$theme/bootstrap.css -o public/css/bootstrap.css
else
  echo "usage: $0 theme"
  echo "example: $0 superhero"

fi
