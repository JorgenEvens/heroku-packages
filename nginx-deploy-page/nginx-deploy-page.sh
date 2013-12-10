#!/bin/sh

dependency_require "nginx"

cat > "${BUILD_DIR}/src/nginx-status.html" << EOF
<html>
	<head>
		<title>Deployment status</title>
	</head>
	<body>
		<h1>Deployment success!</h1>
		<p>
			Service running at port \$PORT as user \$USER on \$HOSTNAME.
		</p>
	</body>
</html>
EOF

cat >> ${BUILD_DIR}/boot.sh << EOF
sed -i "s/\\\$PORT/\$PORT/g" "/app/src/nginx-status.html"
sed -i "s/\\\$USER/\$(whoami)/g" "/app/src/nginx-status.html"
sed -i "s/\\\$HOSTNAME/\$(hostname)/g" "/app/src/nginx-status.html"
EOF
