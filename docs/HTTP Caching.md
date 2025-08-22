# HTTP Caching

Two types of cache are widely used
* nginx caching (server side)
* client caching (browser side)

Caching is controlled by setting appropriate HTTP headers.

### Nginx caching

20s micro-caching is used - this prevents app overload in case many clients request the same resource within short time:

```
[insights-api@lima nginx]$ grep 20s *.conf
api.kontur.nginx.conf:	proxy_cache_valid 20s;
apps.kontur.nginx.conf:	proxy_cache_valid 20s;
disaster.ninja.nginx.conf:	    proxy_cache_valid 20s;
```

There was a problem with cache key - as it did not contain the auth header: [[Tasks/Task: Add $http_authorization to proxy_cache_key of the nginx microcache#^7b708802-3c0b-11e9-9428-04d77e8d50cb/83866c30-8a59-11ec-8974-d1b39a69a643]] 

If the same if API is expected to return different results for similar requests done within a few seconds, microcache should be bypassed, this can be done using client `Cache-Control: no-cache` header: [[Tasks/Task: After creating a new layer the request POST /layers/search/does not return this layer #^7b708802-3c0b-11e9-9428-04d77e8d50cb/d9a15cd0-af78-11ec-a9dc-f17256a34723]] 

### Client caching

It's a good idea to set appropriate headers in the application code as you have the most knowledge of response contents there. If no cache controlling headers are explicitly added by the API, this does not mean no caching will happen.

One good-to-know point is that PUT/POST requests are not idempotent so by default browsers don't cache them. But GET requests are idempotent (several executions in a row lead to the same result) - hence they're automatically cached by the browsers unless there are any headers preventing this.

However, nginx configuration allows adding/replacing headers in the response on its way to client. This is configured in /etc/nginx/\*.conf files, see some examples below:

```
[disaster-ninja@zigzag nginx]$ grep expires *.conf

api.kontur.nginx.conf:	expires -1;
apps.kontur.nginx.conf:	    expires -1;
apps.kontur.nginx.conf:	    expires -1;
apps.kontur.nginx.conf:	    expires -1;
apps.kontur.nginx.conf:	    expires -1;
apps.kontur.nginx.conf:	    expires -1;
apps.kontur.nginx.conf:	    expires -1;
apps.kontur.nginx.conf:	    expires -1;
disaster.ninja_2021.maps.nginx.conf:	map "$sent_http_content_type:$request_uri" $dn2021_expires {
disaster.ninja_2021.nginx.conf:	expires $dn2021_expires;
disaster.ninja.maps.nginx.conf:	map "$sent_http_content_type:$request_uri" $dn_expires {
disaster.ninja.nginx.conf:	    expires $dn2021_expires;
disaster.ninja.nginx.conf:	    expires $dn_expires;
```

"expires -1" means that responses will have "cache-control: no-cache" header which is enough (it actually allows client to cache the response but the client is required to reload it from the API before each usage - which effectively means no caching).

"expires $dn2021_expires" means that headers will be set depending on the map named "$dn2021_expires" which is in the disaster.ninja_2021.maps.nginx.conf file (example contents below):

```
#
	map "$sent_http_content_type:$request_uri" $dn2021_expires {
	    "~^.*:/active/api/"				-1;
#	    "~^.*:/graphql"				off;

	    "~^.*:/$"					-1;
	    "~^.*:/active/$"				-1;

	    "~^application/vnd.mapbox-vector-tile:"	12h;
	    "~^application/javascript:"			12h;
	    "~^application/json:"			12h;
	    "~^text/.*"					12h;
	    "~^image/.*"				12h;
	}
```

 As per this config, all requests to /active/api will also have no-cache header (expires -1 as explained above).

This is a map where key consists of http content type and request uri and the value is the caching time allowed for the client. This example configuration allows the client to cache a wide range of responses locally for 12 hours. Special attention should be payed to this line:

```
"~^application/json:"                       12h;
```

It allows caching any json responses for 12 hours. The user will get the same responses from all java/rest GET endpoints during 12 hours since the first request. (POST/PUT are not impacted - see above).

To avoid such situations - allowed caching time should be properly configured per app/url/content type/request method (see **"\~^.\*:/active/api/" -1** in the same example above). Caching is required as there really are resources which can be cached even for much longer (i.e. some static resources, like static images), but api responses mostly should not be cached on client side.

### Two mega-useful hints from Darafei:

<https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_use_stale>

<https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_lock>

(also see <https://datatracker.ietf.org/doc/html/rfc5861#section-3>)
