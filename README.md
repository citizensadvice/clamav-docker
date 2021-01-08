# About this Repo

This is the Citizens Advice ClamAV docker image. The virus definitions are updated daily. The latest docker image can be pulled from `public.ecr.aws/citizensadvice/clamav:latest`

To test:

    docker build . -t local/clamav
    docker run -p 3310:3310 local/clamav

Wait for the following messages:

    Mon Sep 23 14:07:46 2019 -> Archive support enabled.
    Mon Sep 23 14:07:46 2019 -> BlockMax heuristic detection disabled.
    Mon Sep 23 14:07:46 2019 -> Algorithmic detection enabled.
    Mon Sep 23 14:07:46 2019 -> Portable Executable support enabled.
    Mon Sep 23 14:07:46 2019 -> ELF support enabled.
    Mon Sep 23 14:07:46 2019 -> Mail files support enabled.
    Mon Sep 23 14:07:46 2019 -> OLE2 support enabled.
    Mon Sep 23 14:07:46 2019 -> PDF support enabled.
    Mon Sep 23 14:07:46 2019 -> SWF support enabled.
    Mon Sep 23 14:07:46 2019 -> HTML support enabled.
    Mon Sep 23 14:07:46 2019 -> XMLDOCS support enabled.
    Mon Sep 23 14:07:46 2019 -> HWP3 support enabled.
    Mon Sep 23 14:07:46 2019 -> Self checking every 3600 seconds.

Now run the test script

    ruby test-clamd.rb localhost 3310

You should get the result

    stream: Eicar-Test-Signature FOUND
    A virus was found: stream: Eicar-Test-Signature FOUND
