#!/bin/bash

# k3s Setup Script
# This script downloads k3s binary and provides options to start server or agent

set -e

# Configuration variables
K3S_VERSION="v1.26.5+k3s1"
K3S_BINARY_PATH="/usr/local/bin/k3s"
K3S_URL="https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Function to download k3s binary
download_k3s() {
    print_status "Downloading k3s ${K3S_VERSION}..."
    
    if curl -Lo "${K3S_BINARY_PATH}" "${K3S_URL}"; then
        chmod a+x "${K3S_BINARY_PATH}"
        print_status "k3s binary installed successfully to ${K3S_BINARY_PATH}"
    else
        print_error "Failed to download k3s binary"
        exit 1
    fi
}

# Function to start k3s server
start_server() {
    print_status "Starting k3s server..."
    print_status "Setting kubeconfig permissions to 644"
    
    # Set environment variable for kubeconfig permissions
    export K3S_KUBECONFIG_MODE="644"
    
    # Start k3s server with write-kubeconfig-mode flag as well
    exec k3s server --write-kubeconfig-mode=644
}

# Function to start k3s agent
start_agent() {
    local server_url="$1"
    local token="$2"
    
    if [ -z "$server_url" ] || [ -z "$token" ]; then
        print_error "Server URL and token are required for agent mode"
        echo "Usage: $0 agent <server-url> <token>"
        echo "Example: $0 agent https://k3s.example.com mypassword"
        exit 1
    fi
    
    print_status "Starting k3s agent..."
    print_status "Server: $server_url"
    print_status "Token: [REDACTED]"
    
    exec k3s agent --server "$server_url" --token "$token"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  install              Download and install k3s binary"
    echo "  server               Start k3s server"
    echo "  agent <url> <token>  Start k3s agent"
    echo "  help                 Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 install"
    echo "  $0 server"
    echo "  $0 agent https://k3s.example.com mypassword"
    echo ""
    echo "Environment Variables:"
    echo "  K3S_KUBECONFIG_MODE  Set kubeconfig file permissions (default: 644)"
    echo ""
}

# Main script logic
main() {
    case "${1:-}" in
        "install")
            check_root
            download_k3s
            ;;
        "server")
            check_root
            if [ ! -f "${K3S_BINARY_PATH}" ]; then
                print_warning "k3s binary not found. Installing first..."
                download_k3s
            fi
            start_server
            ;;
        "agent")
            check_root
            if [ ! -f "${K3S_BINARY_PATH}" ]; then
                print_warning "k3s binary not found. Installing first..."
                download_k3s
            fi
            start_agent "$2" "$3"
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        "")
            print_error "No command specified"
            show_usage
            exit 1
            ;;
        *)
            print_error "Unknown command: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
