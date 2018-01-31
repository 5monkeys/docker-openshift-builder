Custom builder for OpenShift
============================

OpenShift doesn't have (at the time of writing) built-in support for
Docker CE build time features. Even if you manage to run OpenShift within
Docker CE, the docker strategy can't handle certain Dockerfile syntaxes. As a
workaround you can deploy a Docker CE pod inside your cluster using the official
`docker:dind` image and then configure your `BuildConfig` to use this image for
a custom builder pod.

Example usage
-------------

    apiVersion: v1
    kind: BuildConfig
    metadata:
       ...

    spec:
       ...

       strategy:
         customStrategy:
           forcePull: True

           from:
             kind: DockerImage
             name: 5monkeys/openshift-builder:latest

           env:
             - name: BUILD_COMMAND
               value: make image && make push

             - name: DOCKER_HOST
               value: tcp://<docker-ce-service-domain-name>:2375
