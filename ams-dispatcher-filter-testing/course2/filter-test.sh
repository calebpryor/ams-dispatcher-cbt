goodurls=(
  "/us/en.html" \
  "/ca/fr.html" \
  "/us/en/magazine.html" \
  "/ca/fr/magazine.html" \
  "/us/en/adventures.html" \
  "/ca/fr/adventures.html" \
  "/us/en/faqs.html" \
  "/ca/fr/faqs.html" \
)

badurls=(
  "/system/console" \
  "/siteadmin" \
  "/crx/de/index.jsp" \
  "/crx/packmgr/index.jsp" \
  "/bin/querybuilder.json" \
  "/content/.infinity.json" \
)

echo "Testing URLs that should be allowed through"

for goodurl in "${goodurls[@]}";do
  echo "Testing http://127.0.0.1:8080$goodurl"
  httpresponsecode=$(curl -s -I http://127.0.0.1:8080$goodurl | grep HTTP | awk '{ print $2}')
  if [[ $httpresponsecode =~ 200 ]]; then
    echo "PASSED"
  else
    echo "FAILED - $httpresponsecode"
  fi
done

echo "Testing URLs that should be blocked"

for badurl in "${badurls[@]}";do
  echo "Testing http://127.0.0.1:8080$badurl"
  httpresponsecode=$(curl -s -I http://127.0.0.1:8080$badurl | grep HTTP | awk '{ print $2}')
  if [[ $httpresponsecode =~ 404 ]]; then
    echo "PASSED"
  else
    echo "FAILED - $httpresponsecode"
  fi
done