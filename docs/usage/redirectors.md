# Redirectors

Currently two pieces of redirecting software are supported out-of-the box for Testudo:

* socat
* [BounceBack](https://github.com/D00Movenok/BounceBack)

To ensure the redirector works after spinning up your C2 servers, please try the following:

* Forward traffic to the C2's internal IP by using socat as a "dumb" redirector
* Access Public IP of redirector from any subnet declared within `ROE_IPS`

If you are able to reach your C2, you are free to use whatever redirector software you are comfortable with now!  BounceBack was packaged with Testudo due to the fact that it was pretty awesome to use when testing!
