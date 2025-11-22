#!/bin/bash
set -e

# Check if Xeams directory is empty (first run with volume)
if [ -z "$(ls -A ${INSTALL_DIR} 2>/dev/null)" ]; then
    echo "Initializing Xeams installation..."
    cp -a /opt/Xeams-initial/. ${INSTALL_DIR}/
    echo "Initialization complete."
fi

# Execute the main command
exec "$@"
