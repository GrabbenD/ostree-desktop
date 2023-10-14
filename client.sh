#!/bin/bash
set -x
set -u
set -e

# [CONTAINER]: OVERRIDE DEFAULTS
function CTR_CREATE_OPTS {
    export CLIENT_TTY=${CLIENT_TTY:=$(tty)}

    export PODMAN_BUILD_NAME=${PODMAN_BUILD_NAME:="game"}
    export PODMAN_BUILD_FILE=${PODMAN_BUILD_FILE:="$(dirname $0)/Containerfile.${PODMAN_BUILD_NAME}"}
    export PODMAN_BUILD_TAG=${PODMAN_BUILD_TAG:="localhost/${PODMAN_BUILD_NAME}"}

    export PODMAN_BUILD_ARGS=(
        # Todo: reuse host cache
        --volume="/var/cache/pacman/pkg:/var/cache/pacman/pkg:rslave"
        # Config files
        --volume="/var/home/monorepo:/home/monorepo:rslave"
    )

    export PODMAN_START_ARGS=(
        --name="${PODMAN_BUILD_NAME}"
        --hostname="client"

        # Detect file changes in Containerfile
        --rm="true"
        --replace="true"

        # Support /sbin/init
        --systemd="always"

        # Performance tweaks
        --pids-limit="-1"
        --security-opt="seccomp=unconfined"

        # Bridge network
        --network="host"

        # GPU access
        --privileged="true"
        --ipc="host" # /dev/shm
        --device="/dev/dri:/dev/dri:rwm"
        --device="/dev/fb0:/dev/fb0:rwm"

        # Seats
        --cap-add="SYS_TTY_CONFIG,SYS_NICE"
        --volume="/dev/tty0:/dev/tty0:rslave"
        --volume="/dev/tty1:/dev/tty1:rslave"

        # Peripherals
        --volume="/dev/input:/dev/input:rslave"
        --volume="/run/udev:/run/udev:rslave"

        # Audio/Mic
        --volume="/dev/snd:/dev/snd:rslave"

        # [QEMU] Virt-Manager
        #--volume="/var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock"
        #--volume="/var/lib/libvirt/images:/var/lib/libvirt/images"
    )
}

# [CONTAINER]: NAMESPACE
# | Todo tag :latest :previous
function CTR_CREATE_IMAGE {
    podman build \
        ${PODMAN_BUILD_ARGS[@]} \
        -t ${PODMAN_BUILD_TAG} \
        -f ${PODMAN_BUILD_FILE} \
        $@
}

# [CONTAINER]: RUNTIME
function CTR_DEPLOY_IMAGE {
    # CTRL+P+Q to quit
    podman run \
        "${PODMAN_START_ARGS[@]}" \
        "${PODMAN_BUILD_ARGS[@]}" \
        -d ${PODMAN_BUILD_TAG}

    systemctl disable --now getty@tty0.service
    systemctl disable --now getty@tty1.service
}

# [CLI]: TASKS FINECONTROL
action=${1:-}

# Argument
case ${action} in
    backup)
        CTR_CREATE_OPTS
        podman commit ${PODMAN_BUILD_NAME} ${PODMAN_BUILD_TAG}
    ;;

    build)
        CTR_CREATE_OPTS
        CTR_CREATE_IMAGE
        #CTR_DEPLOY_IMAGE
    ;;

    enter)
        CTR_CREATE_OPTS
        podman exec -it ${PODMAN_BUILD_NAME} /bin/login
    ;;

    start)
        CTR_CREATE_OPTS
        CTR_DEPLOY_IMAGE
    ;;

    stop)
        CTR_CREATE_OPTS
        podman stop ${PODMAN_BUILD_NAME}
    ;;

    *)
        echo "Usage: client.sh {build|enter|start|stop}"
    ;;
esac
