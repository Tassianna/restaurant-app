# Simple HAProxy Configuration

# Global settings
global
    log stdout format raw daemon

# Default settings
defaults
    mode    http
    timeout connect 5000ms
    timeout client  50000ms
    timeout server  50000ms
    log global
    option httplog
    option dontlognull

# Frontend to accept incoming requests on port 80
frontend http-in
    bind *:80
    # Define ACLs to match request paths
    acl is_auth path_beg /api/auth
    acl is_discounts path_beg /api/discounts
    acl is_items path_beg /api/items
    acl is_root path_beg /

    # Use corresponding backend based on ACL
    use_backend auth-backend if is_auth
    use_backend discounts-backend if is_discounts
    use_backend items-backend if is_items
    use_backend frontend-backend if is_root

{% for host in groups[backend] %}
# Backend for the frontend service
backend {{ hostvars[host][‘inventory_host’] }}-backend
    server http://{{ hostvars[host][‘ansible_host’] }}:{{ hostvars[host].port }}
{% endfor %}

{% for host in groups[frontend] %}
# Backend for the frontend service
backend {{ hostvars[host][‘inventory_host’] }}-backend
    server http://{{ hostvars[host][‘ansible_host’] }}:{{ hostvars[host].port }}
{% endfor %}
