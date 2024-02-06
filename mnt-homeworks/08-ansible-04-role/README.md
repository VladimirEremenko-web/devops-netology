# Vector

This role install Vector and set configuration

## Role Variables

| vars                         | description                                                    |
| ---------------------------- | -------------------------------------------------------------- |
| vector_version               | Version of Vector to install                                   |
| vector_package_name          | URL package yam                                                |
| vector_user                  | User for Vector for OS                                         |
| vector_group                 | Group for user                                                 |
| vector_force_reinstall       | Set true to force the download and installation of the package |
| vector_bin_path              | Path for bin                                                   |
| vector_documentation_link    | Documentation link                                             |
| vector_service_enabled       | Start on boot                                                  |
| vector_service_state         | Current state: started, stopped                                |
| vector_log_output            | Output format                                                  |
| vector_config_template_path  | Template path                                                  |
| vector_service_template_path | Template path service                                          |
| vector_data_dir              | Directory path for vector                                      |

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: role_vector}

## License

MIT

## Author Information

Vladimir Eremenko
