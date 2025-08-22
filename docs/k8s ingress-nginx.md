# k8s ingress-nginx

In the custom **ingress-nginx-kontur** build, the modules were compiled and added separately (<https://github.com/konturio/puppetmaster2022/blob/main/provisioning/roles/ingress-nginx-builder/files/kontur-ingress-nginx/Dockerfile>), but now all the modules we need (except **njs**) are included in the official release. The **njs** module, which lets us generate CORS on the fly with JS scripts by including them in an `http-snippet` via `js_import`, was removed in chart versions >4.8.2 and is no longer officially supported (<https://github.com/kubernetes/ingress-nginx/issues/13135#issuecomment-2770551734>). This means we're locked to a controller version that still supports **njs**. In general, annotations should be used instead of JS scripts because that's the correct way to set CORS; modifying the nginx base images in the ingress controller is discouraged since dependency management then becomes impossible.

The automated build assumes the use of official, unmodified nginx images, which is no longer relevant for the single customization that is now unsupported. We must update the ingress controller by bumping the Helm chart version, but before upgrading we need to\
drop the **njs** module and rewrite all CORS blocks for the required ingresses using ingress-nginx annotations.

The image is currently built as follows:

1. `git clone --depth 1 --branch helm-chart-4.8.2 https://github.com/kubernetes/ingress-nginx.git`\
   (changes: <https://github.com/konturio/ingress-nginx/commit/8eb2157f4437f3d4158c4f4e49addbdfb41ab5a1> + <https://github.com/konturio/ingress-nginx/commit/9c62668971557a9365618d438683a163effc0309>)
2. build:\
   a)

   ```
   cd images/nginx/rootfs
   docker build -t nginx-base:1.12.1 -f Dockerfile .
   docker tag nginx-base:1.12.1 nexus.kontur.io:8085/konturdev/nginx-base:1.12.1
   docker push nexus.kontur.io:8085/konturdev/nginx-base:1.12.1
   ```

   b) 

   ```
   from the repo root:
   make build
   ```

   c)

   ```
   cd rootfs
   docker build --no-cache \
     --build-arg TARGETARCH=amd64 \
     --build-arg VERSION=controller-v1.8.0a \
     --build-arg COMMIT_SHA=$(git rev-parse --short HEAD) \
     --build-arg BASE_IMAGE=nginx-base:1.8.0a \
     -t ingress-nginx-controller-custom:1.8.0a .
   ```
