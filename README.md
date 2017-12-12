# IWA-Proxy
**Integrated Windows Authentication Proxy Gateway Docker Container**

Author: David Lloyd

Docker Image: davlloyd/iwaproxy

Version History:

Version | Date | Comment
--- | --- | ---
1.00 | 12/12/2017 | Inital Release

## Description
This docker image uses the CNTML (http://cntlm.sourceforge.net/) application to 
provide an Integrated Windows Authentication web proxy for those services 
that do not support it natively. Examples can include call home faclities without
Windows support or Linux desktops using a non windows supporting browser

By redirecting proxy settings to this image you can set it with no credentials as
The traffic will then be passed on to the configured proxy as defined within the
'Proxy Address' of the container instance with the appended windows credentials as
defined within the environment variables passed to the container at runtime.

CNTLM will attempt to authenticate with NTMLMV2, others are configured as part of the 
configuration file creation but not active.

**Considerations for future changes**
1. Currently credentials are passed as environment variables which is not ideal. Can look to leverage Docker Secrets in the future although this then relies on Swarm. Alternatively look at some intermediate hashing process to further secure the credentials
2. include examples for deploying a stack/pod into high level schedulers

# Instructions

The docker container davlloyd/iwaproxy needs to be run with the following considerations:
1. Credentials are passed with environment variables (i.e. use the -e argument within docker run)
2. The gateway proxy is passed as a variable and needs to include address and port
3. The port mapping also needs to be exposed so that the container can be accessed externally. This is defaulted to 3128 but can be changed with the environment variable *listenaddress*
4. The application runs in console interactive mode so you can see the status by using the terminal argument (-t) with docker run

Once done just point the source device to the docker host and container runtime port to have traffic redirected to 
proxy with appended Windows credentials

## Environment Variables Required

Variable | Required | Default | Example | Description
--- | --- | --- | --- | ---
*useraccount* | yes | N/A | bill | Windows Account Name 
*userdomain*  | yes | N/A | mydom.com | Windows Domain Name
*userpassword* | yes | N/A | pass! |  Accounts Password
*proxyaddress* | yes | N/A | 192.168.0.20:8080 | Proxy address and port for traffic to be forwarded to
*listenaddress* | no | 0.0.0.0:3128 | | Address which cntlm service listens on


### Example docker command line

docker run -t -p 3128:3128 /
                -e useraccount='user' /
                -e userdomain='user.dom' /
                -e userpassword='pass' /
                -e proxyaddress='192.168.0.10:8080' /
                -n myproxy iwaproxy


