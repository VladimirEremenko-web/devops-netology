# Lighthouse

This role install nginx and lighthouse

## Role Variables

| vars                  | description                      |
| --------------------- | -------------------------------- |
| lighthouse_data       | Dir for install lighthouse       |
| lighthouse_nginx_port | Nginx port                       |
| lighthouse_nginx_conf | File for set configuration nginx |
| nginx_user            | Nginx user                       |
| lighthouse_code_src   | Repository code Lighthouse       |

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: role_lighthouse}

## License

MIT

## Author Information

Vladimir Eremenko
