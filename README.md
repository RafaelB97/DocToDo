# README

## Getting Started

### Prerequisites
- **PostgreSQL 12.4 or later**, you can follow the official documentation to download [here]( https://www.postgresql.org/download/)
- **Ruby 2.6**, we suggest to use [rbenv]( https://github.com/rbenv/rbenv), then use this command `rbenv install 2.7.`
- **Rails 6.0.3.4**, once you have ruby install rails with the command `gem install rails`
- **Yarn 1.22.4**, require npm to install yarn
- **Git**
- **Unix system** preference any linux flavor or MacOs

### Installation

1. Make sure you have a postgres role called doc_to_do with any password, create the use with the next command.

    ` sudo -u postgres createuser -s doc_to_do -P`

    With the `-P` value postgres ask you to type a password. Once you have your user use this command to add the password in your environment variables.

    `echo 'export DOC_TO_DO_DATABASE_PASSWORD="PostgreSQL_Role_Password"' >> ~/.bashrc`

    Where `PostgresSQL_ROLE_Password` is the password you assing to doc_to_do role.

2. Clone this repository

    `git clone https://github.com/RafaelB97/DocToDo.git`

3. Install dependencies using bundle and yarn:
    ```bash
    cd DocToDo
    bundle && yarn
    ```

3. Initialize the database.
    ```bash
    rails db:create
    rails db:migrate
    ```

## Use

### Run rails
This runs the server in your localhost:3000
`rails server`

To stop the server use control+c