#!/usr/bin/env bash
# Point this shell at the gitignored .secrets file in the repo root.
#
# Setup (variables stay in this shell):
#   source scripts/aws-env.sh
#
# One command (variables die when the command exits):
#   scripts/aws-env.sh aws sts get-caller-identity
#
# Does not print secret values.

_elsevier_aws_env_main() {
  local here root secrets
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  root="$(cd "${here}/.." && pwd)"
  secrets="${root}/.secrets"

  if [[ ! -f "${secrets}" ]]; then
    echo "Missing ${secrets}" >&2
    echo "Create ${secrets} with AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY. Do not add a secrets example file to git." >&2
    return 1
  fi

  set -a
  # shellcheck disable=SC1090
  source "${secrets}"
  set +a

  if [[ -z "${AWS_ACCESS_KEY_ID:-}" || "${AWS_ACCESS_KEY_ID}" == "REPLACE_ME" ]]; then
    echo "Edit ${secrets}. AWS_ACCESS_KEY_ID is still empty or REPLACE_ME." >&2
    return 1
  fi
  if [[ -z "${AWS_SECRET_ACCESS_KEY:-}" || "${AWS_SECRET_ACCESS_KEY}" == "REPLACE_ME" ]]; then
    echo "Edit ${secrets}. AWS_SECRET_ACCESS_KEY is still empty or REPLACE_ME." >&2
    return 1
  fi

  # Drop any profile or credential-file path already in the shell.
  # Otherwise the CLI can keep using a different account.
  unset AWS_PROFILE AWS_SHARED_CREDENTIALS_FILE AWS_CONFIG_FILE

  export AWS_REGION="${AWS_REGION:-us-east-1}"
  export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-${AWS_REGION}}"

  if [[ -z "${AWS_SESSION_TOKEN:-}" ]]; then
    unset AWS_SESSION_TOKEN
  fi

  echo "AWS env is set from the gitignored .secrets file. Region ${AWS_REGION}."
  echo "Next command in this same shell: aws sts get-caller-identity"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  _elsevier_aws_env_main || exit 1
  if [[ $# -eq 0 ]]; then
    echo "This process is exiting, so the variables will not stick." >&2
    echo "Source it instead: source scripts/aws-env.sh" >&2
    exit 1
  fi
  exec "$@"
else
  _elsevier_aws_env_main
fi
