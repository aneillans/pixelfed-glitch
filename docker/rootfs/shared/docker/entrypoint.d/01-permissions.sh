#!/usr/bin/env bash
: "${ENTRYPOINT_ROOT:="/docker"}"

# shellcheck source=SCRIPTDIR/../helpers.sh
source "${ENTRYPOINT_ROOT}/helpers.sh"

entrypoint-set-script-name "$0"

# Optionally fix ownership of configured paths
: "${DOCKER_APP_ENSURE_OWNERSHIP_PATHS:=""}"

declare -a ensure_ownership_paths=()
IFS=' ' read -r -a ensure_ownership_paths <<<"${DOCKER_APP_ENSURE_OWNERSHIP_PATHS}"

if [[ -z "${DOCKER_APP_ENSURE_OWNERSHIP_PATHS}" || "${DOCKER_APP_ENSURE_OWNERSHIP_PATHS}" == "true" ]]; then
    log-info "Checking permissions. Deactivate with [\$DOCKER_APP_ENSURE_OWNERSHIP_PATHS = false] or specify paths to check."
    # Ensure the Docker volumes and required files are owned by the runtime user as other scripts
    # will be writing to these
    run-as-current-user chown --verbose "${RUNTIME_UID}:${RUNTIME_GID}" "./.env"
    run-as-current-user chown --verbose "${RUNTIME_UID}:${RUNTIME_GID}" "./bootstrap/cache"
    run-as-current-user chown --verbose "${RUNTIME_UID}:${RUNTIME_GID}" "./storage"
    ensure-directory-exists "./storage/docker"
    run-as-current-user chown --verbose --recursive "${RUNTIME_UID}:${RUNTIME_GID}" "./storage/docker"
else
    if [[ "${DOCKER_APP_ENSURE_OWNERSHIP_PATHS}" == "false" || ${#ensure_ownership_paths[@]} == 0 ]]; then
        log-info "No paths has been configured for ownership fixes via [\$DOCKER_APP_ENSURE_OWNERSHIP_PATHS]."

        exit 0
    fi

    for path in "${ensure_ownership_paths[@]}"; do
        log-info "Ensure ownership of [${path}] is correct"
        ensure-directory-exists "${path}"
        stream-prefix-command-output run-as-current-user chown --recursive "${RUNTIME_UID}:${RUNTIME_GID}" "${path}"
    done
fi
