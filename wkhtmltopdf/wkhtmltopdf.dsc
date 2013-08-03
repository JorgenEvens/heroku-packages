Simple shell utility to convert html to pdf using the webkit rendering engine, and qt.

PHP Example:
exec('/app/vendor/wkhtmltopdf http://google.com /app/src/test.pdf');

Note:
Keep in mind that this can used a lot of memory if it's a complicated page so consider using a 2x Dyno when you doing compicated stuff.