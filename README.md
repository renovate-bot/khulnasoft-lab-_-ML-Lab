<h1 align="center">
    <a href="https://github.com/khulnasoft/ml-lab" title="ML Lab Home">
    <img width=80% alt="" src="./docs/images/lab-header.png"> </a>
</h1>

<p align="center">
    <strong>End-to-end collaborative development platform to build and run machine learning solutions.</strong>
</p>

<p align="center">
    <a href="https://github.com/khulnasoft/ml-lab/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/khulnasoft/ml-lab/py-ml-lab"></a>
    <a href="https://github.com/khulnasoft/ml-lab/blob/master/LICENSE" title="ML Lab License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg"></a>
    <a href="https://api.reuse.software/info/github.com/khulnasoft/ml-lab" title="REUSE status"><img src="https://api.reuse.software/badge/github.com/khulnasoft/ml-lab"></a>
</p>

<p align="center">
  <a href="#getting-started">Architecture</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#development">Development</a> •
</p>

ML Lab is a centralized hub for development teams to seamlessly build, deploy, and operate machine learning solutions at scale. It is designed to cover the end-to-end machine learning lifecycle from data processing and experimentation to model training and deployment. It combines the libraries, languages, and tools data scientists love, with the infrastructure, services and workflows they need to deliver machine learning solutions into production.

>❗❗❗  
> This branch contains a new experimental version of ML Lab rewritten in python. The original java version can be found in the branch ml-lab-java.

## Highlights

- 🔐 Secure multi-user development platform for machine learning solutions.
- 🛠 Workspace with integrated tooling (Jupyter, VS Code, SSH, VNC, Hardware Monitoring, ...)
- 🗃️ Upload, manage, version, and share datasets & models.
- 🎛 Deploy and operate machine learning solutions for productive usage.
- 🐳 Deployable on a single-server via Docker or a server-cluster via Kubernetes.

## Architecture
Machine Learning Lab (ML Lab) builds on the [docknet](https://github.com/khulnasoft/docknet) server which provides a generic API for managing users and projects, storing files, deploying services and database access.
Using the extension mechanism of docknet, ML Lab builds machine learning specific functionality on top.
These extensions are called ML Lab components and each have their own backend, frontend and docker image.
The ML Lab backend image leverages the docknet library to combine all ML Lab components and adds a React frontend application.
The different parts of an ML Lab installation are shown in this diagram:
![Lab Architecture](./docs/images/lab-architecture.png)


## Getting Started

### Local Docker Installation

The latest ML Lab docker image are pushed in the [GitHub container registry](https://github.com/orgs/khulnasoft-lab/packages?repo_name=ml-lab).
ML Lab can be run locally using docker compose which will start the ML Lab backend, the Postgres and Minio Database and the ML Lab Components (Workspace Manager, etc.)
```
cd deployment/mllab-docker
docker pull ghcr.io/khulnasoft/ml-lab/lab-backend
docker tag ghcr.io/khulnasoft/ml-lab/lab-backend lab-backend
docker pull ghcr.io/khulnasoft/ml-lab/lab-workspace-manager
docker tag ghcr.io/khulnasoft/ml-lab/lab-workspace-manager lab-workspace-manager
docker pull khulnasoft/ml-workspace-minimal
docker-compose up
# Visit http://localhost:30010/ and login with username and password "admin"
# Run docker-compose up -d to start the application in the background
```
**Important**: The configurations in the docker-compose.yaml are not meant to be used for production
as the JWT secret is the default one and the ports of all services are published, instead of only the ML Lab backend service.
For a list of all configurable environment variables, have a look at the [docknet config file](https://github.com/khulnasoft/docknet/blob/main/backend/src/docknet/config.py#L32).
All fields of the `Settings` class represent an environment variable that can be set.

### Kubernetes Installation

To install ML Lab on Kubernetes, the [helm chart](./deployment/mllab-kubernetes) can be used.
Again, the provided default values are not production ready and can be changed in the [values.yaml](./deployment/mllab-kubernetes/values.yaml) file.


## Development

### The build pipeline
Each folder in this repository that contains a buildable part of ML Lab contains a build.py python script.
This script allows to lint (--check), build (--make) and test (--test) the contents of that folder: 
```
python build.py --check --make --test
```
The build.py script in the root folder calls the build.py scripts of all sub folders and thereby builds the entire ML Lab project.
It is possible to exclude specific folders from the build pipeline:
```
python build.py --skip-path webapp --skip-path components/lab-workspace-manager
```
The build.py script always performs a full rebuild which leads to a long build time.
This is great for a reproducible build in the CI/CD pipeline build but slows down development.
Therefore, it makes sense to use the options below during developing ML Lab.

### Build ML Lab docker image manually
This paragraph describes the steps required for building the ML Lab backend image. 
These steps are basically the same as the ones executed automatically by the build.py script.
However, during development only some steps need to be rerun depending on what files are changed.

Build the webapp bundle (only required when changing the webapp):
```
cd webapp
yarn install        # Only rerun if dependencies changed 
yarn run build
cd ..
```

Build the ML Lab backend image:
``
docker build -t lab-backend .
``

The same commands can be used for building any of the [components](components).

### Developing the ML Lab Web Application
The ML Lab web app is build with JavaScript and React. It communicates with the ML Lab backend (via the docknet API) and provides the overall UI structure of ML Lab. 
The ML Lab components are integrated into this UI via iframes.
During the build process, the web app is compiled into a minified JavaScript bundle and is then later served by the ML Lab backend.
For development, the web app can be started locally and connect to any other local or remote ML Lab instance.
For more information, see the [webapp folder](./webapp).

### Developing Docknet Core Features
Sometimes it is necessary to add new features to the docknet library directly instead of building a docknet extension (ML Lab component).
Detailed information on how to develop docknet can be found in the [docknet repository](https://github.com/khulnasoft/docknet).
To make the development of docknet features in conjunction with ML Lab development easier, the docknet repo is included as a git submodule.
Run the following command to download the docknet source into the [docknet folder](./docknet)
```
git submodule update --init
```
To use this local docknet code in the ML Lab backend image instead of the version [released on PyPi](https://pypi.org/project/docknet/), uncomment the [Dockerfile](./Dockerfile) lines 95-98.
The following `.env` file can be used to connect a locally started docknet server with the Postgres and Minio DB started by the docker compose script in this repository:
```
POSTGRES_CONNECTION_URI=postgresql://postgres:postgres-password-change-me@127.0.0.1:30011/postgres
S3_ENDPOINT=127.0.0.1:30013
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minio-password-change-me
BACKEND_CORS_ORIGINS=http://localhost:3000
SYSTEM_NAMESPACE=pylab
```

### Developing an ML Lab Component
An ML Lab component is its own separate application with a frontend and backend packaged into a docker image.
It is started alongside the ML Lab Backend container which discovers the component via labels set on the container.
The component can extend the ML Lab API and its UI is integrated in the main ML Lab UI with an iframe.
For an example of such an ML Lab component, refer to the [ML Lab Workspace Manager](./components/lab-workspace-manager). It contains further information on how the extension is structured and how to develop it locally.
If you want to develop a new ML Lab component, you can copy the [template component](./components/template) and follow the instruction in that folder.

