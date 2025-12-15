#!/usr/bin/env zsh

set -e

ENV_FILE=".env"
TARGET_FILE="./Packages/OMGAPI/Sources/OMGAPI/Requests/AuthRequestFactory.swift"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo "${RED}[ERROR]${NC} $1" >&2
}

print_warning() {
    echo "${YELLOW}[WARNING]${NC} $1"
}

if [[ ! -f "$ENV_FILE" ]]; then
    print_error ".env file not found at: $ENV_FILE"
    exit 1
fi

if [[ ! -f "$TARGET_FILE" ]]; then
    print_error "Target file not found at: $TARGET_FILE"
    exit 1
fi

print_info "Reading credentials from $ENV_FILE"

CLIENT_ID=""
CLIENT_SECRET=""
REDIRECT_URI=""

while IFS='=' read -r key value; do
    key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    [[ -z "$key" || "$key" =~ ^# ]] && continue
    
    value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
    
    case "$key" in
        OMGLOL_CLIENT_ID|CLIENT_ID)
            CLIENT_ID="$value"
            ;;
        OMGLOL_CLIENT_SECRET|CLIENT_SECRET)
            CLIENT_SECRET="$value"
            ;;
        OMGLOL_REDIRECT_URI|REDIRECT_URI)
            REDIRECT_URI="$value"
            ;;
    esac
done < "$ENV_FILE"

if [[ -z "$CLIENT_ID" ]]; then
    print_error "CLIENT_ID not found in .env file"
    print_warning "Expected keys: OMGLOL_CLIENT_ID or CLIENT_ID"
    exit 1
fi

if [[ -z "$CLIENT_SECRET" ]]; then
    print_error "CLIENT_SECRET not found in .env file"
    print_warning "Expected keys: OMGLOL_CLIENT_SECRET or CLIENT_SECRET"
    exit 1
fi

if [[ -z "$REDIRECT_URI" ]]; then
    print_error "REDIRECT_URI not found in .env file"
    print_warning "Expected keys: OMGLOL_REDIRECT_URI or REDIRECT_URI"
    exit 1
fi

print_info "Found credentials:"
print_info "  CLIENT_ID: ${CLIENT_ID:0:10}... (${#CLIENT_ID} chars)"
print_info "  CLIENT_SECRET: ${CLIENT_SECRET:0:10}... (${#CLIENT_SECRET} chars)"
print_info "  REDIRECT_URI: $REDIRECT_URI"

BACKUP_FILE="${TARGET_FILE}.backup"
cp "$TARGET_FILE" "$BACKUP_FILE"
print_info "Created backup at: $BACKUP_FILE"

escape_sed() {
    echo "$1" | sed -e 's/[\/&]/\\&/g'
}

CLIENT_ID_ESCAPED=$(escape_sed "$CLIENT_ID")
CLIENT_SECRET_ESCAPED=$(escape_sed "$CLIENT_SECRET")
REDIRECT_URI_ESCAPED=$(escape_sed "$REDIRECT_URI")

print_info "Updating $TARGET_FILE"

sed -i.tmp \
    -e "s/static let id = \"\"/static let id = \"$CLIENT_ID_ESCAPED\"/" \
    -e "s/static let secret = \"\"/static let secret = \"$CLIENT_SECRET_ESCAPED\"/" \
    -e "s/static let redirectURI = \"\"/static let redirectURI = \"$REDIRECT_URI_ESCAPED\"/" \
    "$TARGET_FILE"

rm -f "${TARGET_FILE}.tmp"

if grep -q "static let id = \"$CLIENT_ID\"" "$TARGET_FILE" && \
   grep -q "static let secret = \"$CLIENT_SECRET\"" "$TARGET_FILE" && \
   grep -q "static let redirectURI = \"$REDIRECT_URI\"" "$TARGET_FILE"; then
    print_info "${GREEN}✓${NC} Successfully updated OAuth credentials"
    print_info "Backup saved at: $BACKUP_FILE"
else
    print_error "Failed to verify changes. Restoring backup..."
    mv "$BACKUP_FILE" "$TARGET_FILE"
    exit 1
fi

print_info "Done!"
