# Clickhouse

This role can install Clickhouse

## Role Variables

| vars                   | description                      |
| ---------------------- | -------------------------------- |
| clickhouse_version     | Version of Clickhouse to install |
| cickhouse_users_custom | add user and password for DB     |

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: role_clickhouse}

## License

MIT

## Author Information

Vladimir Eremenko
