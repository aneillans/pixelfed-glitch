#!/bin/bash
: "${ENTRYPOINT_ROOT:="/docker"}"

# shellcheck source=SCRIPTDIR/../helpers.sh
source "${ENTRYPOINT_ROOT}/helpers.sh"

entrypoint-set-script-name "$0"

# Validating dot-env files for any issues
for file in "${dot_env_files[@]}"; do
    if file-exists "$file"; then
        log-warning "Could not source file [${file}]: does not exists"
        continue
    fi

    log-info "Linting dotenv file ${file}"
    dotenv-linter --skip=QuoteCharacter --skip=UnorderedKey "${file}"
done
