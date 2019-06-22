
build:
	@(docker build  -t jeduoliveira/lumisportal-stack:11.2.0.190404  .)
	
push: build
	@(sudo docker push jeduoliveira/lumisportal-stack:11.2.0.190404 )