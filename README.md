# pia-proxy
## Summary
A Docker image that connects to a Private Internet Access VPN (PIA) (see [`thrnz/docker-wireguard-pia`](https://github.com/thrnz/docker-wireguard-pia)) and uses Tinyproxy to tunnel HTTP traffic thorugh the VPN connection.

## Disclaimer
The Docker image defined in this repository was created to work around some of the shortcomings of how Tinyproxy is configured and should NOT be considered "best practice" on usage of the base image `thrnz/docker-wireguard-pia`. In short, if you're here to see how to use `thrnz/docker-wireguard-pia` as a base image, you're probably, "...doing it wrong."

## Quickstart
### Create a file with your environment variables
Create a new file that contains the environment variables required to connect to PIA. Below is a sample file named `env`.

```bash
LOC=swiss
USER=p1111111
PASS=myVerySecurePassword!
```

Start the Docker image using the environments file (`env`), with the necissary permissions, and exposing the port. Tinyproxy will automatically be configured with sane defaults on startup.
```bash
user@shell> docker run --cap-add=NET_ADMIN --env-file env -d -p 8888:8888 devdull/pia-proxy
```

In the settings of your web browser (e.g. Chrome, Firefox, etc.) configure a manual proxy at `localhost` on port `8888`, then use your favorite IP verfication site (e.g. [ICanHazIP](https://icanhazip.com/)) to verify that your IP address has changed.

## Additional Tinyproxy configuration
If you need or want to further fine-tune your Tinyproxy configuration, you can override most of the defaults in the Docker image or specify additional configuration parameters by prefixing an environment variable with `TINYPROXY_`. For example, to change the default port from `8888` to `8765`, configure the environment variable `TINYPROXY_Port=8765`. See the [Tinyproxy documentation](https://tinyproxy.github.io/) for a complete list.

**NOTE:** `Bind` and `Listen` values are automatically configured.

**NOTE:** Tinyproxy requires certain configuration values to be within quotes. If Tinyproxy fails to start due to a configuration error, double check that quotes are used where required. For example, `ViaProxyName "tinyproxy"` and _NOT_ `ViaProxyName tinyproxy`. The environment variable to configure `ViaProxyName` would look like, `TINYPROXY_ViaProxyName='"tinyproxy"'` (note the use of mixed quotes to ensure the double quotes are retained).

## Additional VPN (Wireguard) configurations
Please see the [documentation for the `thrnz/docker-wireguard-pia` base image](https://github.com/thrnz/docker-wireguard-pia/tree/master).
