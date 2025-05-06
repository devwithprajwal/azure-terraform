#  CI/CD Pipeline for Java Spring Boot App on Azure Kubernetes (AKS)

This repository demonstrates a complete DevOps CI/CD pipeline using **GitHub Actions** that:

- Builds a Java Spring Boot application using **Maven**
- Creates and pushes a **Docker** image to **Docker Hub**
- Deploys the application to an **Azure Kubernetes Service (AKS)** cluster

---

## ⚙️ Workflow :

###  Trigger
1. This triggers the workflow whenever a push is made to the main branch, enabling continuous integration and deployment.
   
```yaml
on:
  push:
    branches:
      - main
```
2. A job named build-and-deploy that runs on the latest Ubuntu runner provided by GitHub Actions.

```yaml
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
```
3. Defines reusable environment variables for your Azure resource group and AKS cluster.

```yaml
env:
      RESOURCE_GROUP_NAME: prajwal-rg
      AKS_CLUSTER_NAME: aksprajwal
```
4. Clones the source code from the GitHub repository into the GitHub Actions runner.

```yaml
steps:
      - name: Checkout repository
        uses: actions/checkout@v2
```
5. Installs Java Development Kit (JDK) version 17 using AdoptOpenJDK to compile the Spring Boot project.

```yaml
- name: Set up JDK 17
        uses: actions/setup-java@v2
        with:
          distribution: 'adopt'
          java-version: '17'
```
6. Runs mvn clean install in the javapack directory to compile the code, run tests, and generate the JAR file.

```yaml
- name: Build with Maven
        run: mvn clean install
        working-directory: javapack
```
7. Logs in to Docker Hub using GitHub Secrets for secure authentication.

```yaml
- name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
```
8.a Builds the Docker image from the javapack directory using the specified Dockerfile.

8.b Pushes the image to Docker Hub with a unique tag based on the GitHub run number for versioning.

```yaml
- name: Build and push Docker image
        uses: docker/build-push-action@v2
        with:
          context: javapack
          file: javapack/Dockerfile
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/springboot-app:${{ github.run_number }}
```
9. Logs out from Docker Hub to improve security and cleanup credentials.

```yaml
- name: Logout from Docker Hub
        run: docker logout
```
10. Authenticates to Azure using a service principal whose credentials are securely stored in GitHub Secrets.

```yaml
- name: Set up Azure CLI
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
```
11. Fetches Kubernetes credentials from your Azure AKS cluster, enabling direct interaction with kubectl.

```yaml
- name: Get AKS credentials
        run: |
          az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $AKS_CLUSTER_NAME --overwrite-existing
```
12.a Updates the deployment.yaml file with the new Docker image tag.

12.b Applies the updated deployment and service configurations to the Kubernetes cluster.

```yaml
- name: Update Kubernetes deployment
        run: |
          sed -i "s|image: .*|image: ${{ secrets.DOCKER_USERNAME }}/springboot-app:${{ github.run_number }}|g" manifest/deployment.yaml
          kubectl apply -f manifest/deployment.yaml
          kubectl apply -f manifest/service.yaml
```
