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




# Backends
{% for host in groups['backend'] %}
backend {{ host }}-backend
    {% if hostvars[host]['elb_name'] == "" %}
    #server frontend frontend:80 still point to frontend 
    server {{ host }} {{ hostvars[host]['ansible_host'] }}:80
    {% else %}
    #now we point to ELBs
    #server xxx_elb xxx_elb:80
    server {{ hostvars[host]['elb_name'] }} {{ hostvars[host]['elb'] }}:80
    {% endif %}
{% endfor %}

#{% for host in groups['backend'] %}
#backend {{ host }}-backend
#    server {{ host }} {{ hostvars[host]['ansible_host'] }}:{{ hostvars[host]['port'] }}
#{% endfor %}


