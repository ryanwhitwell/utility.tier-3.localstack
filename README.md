# Tier 3 Local

This is a Docker container meant to simulate Tier 3 services/resources for your application.

## Getting Started

To get started please clone the repository located [here](https://github.com/ryanwhitwell/utility.tier-3.localstack.git).

### Prerequisites

Please install the following products on your local machine:

- [Docker Desktop](https://www.docker.com/products/docker-desktop)

### Installing

#### Follow these steps to get Tier 3 Local working on your local development machine.
*Please use your command shell of choice.*

1. Navigate to the directory where Tier 3 Local is located


2. Ensure Docker is running
    ```
    docker system info
    ```

3. Build the Tier 3 Local image
    ```
    docker-compose build
    ```
4. Run the image
    ```
    docker-compose up
    ```

#### Follow these steps to appropriately stop Tier 3 Local on your local development machine.
*Please use your command shell of choice.*
1. Navigate to the directory where Tier 3 Local is located

2. Terminate the Tier 3 Local process by pressing the escape sequence in your command shell `Ctrl+C` for **Windows**.
 
2. Stop the Docker container
    ```
    docker-compose down
    ```

#### Accessing services in Tier 3 Local
Use the clients for each product embedded in this container (Elasticsearch Head Plugin, MongoDB CLI, etc...). The host for each service is located at the name "localhost".

*Examples* 

1. To connect to the MongoDB instance, use the following connection string in your Mongo CLI:

    ```
    mongo localhost:27017/MyDatabase -u tier_3_user -p tier_3_user
    ```

2. To connect to the Redis instance, install and use the NodeJS client:

    ```
    npm install -g redis-client
    rdclient -p 7000
    ```

3. To connect to the Elasticsearch instance, install the Chrome extension for the   [Elasticsearch head plugin](https://chrome.google.com/webstore/detail/elasticsearch-head/ffmkiejjmecolpfloofpjologoblkegm?hl=en-US).


4. To connect to the RabbitMQ instance, use the [management tool](http://localhost:15672) embedded with the product.
    - *username*: tier_3_admin
    - *password*: tier_3_admin

## Built With

* [Docker](https://www.docker.com/) - Containerization

## Contributing

Please feel free to fork or branch off of `master` at any time as needed.

## Authors

* **Ryan Whitwell** - *Initial work* - [Email](mailto:ryanwhitwell.developer@gmail.com)
