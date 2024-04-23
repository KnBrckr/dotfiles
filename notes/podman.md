# podman

## Does docker image exist on server?

 docker manifest inspect gitlab.ilts.com:5050/datatrak-flx/oss/oss/mock_mis:main > /dev/null 2>&1

## Expose UPD ports

    podman run -p hostPort:containerPort/udp

## Tag image with new label

    podman image tag <container-url>:<label> <new-container-url>:<new-label>
    podman push <new-container-url>:<new-label>
