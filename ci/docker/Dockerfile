FROM ubuntu

RUN apt-get update && apt-get install -y unzip wget && \
		wget https://releases.hashicorp.com/packer/0.11.0/packer_0.11.0_linux_amd64.zip -O packer.zip && \
		unzip packer.zip && \
		mv packer /usr/local/bin && \
		rm packer.zip
