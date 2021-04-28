Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77737C433B4
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Apr 2021 10:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44DD660E0C
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Apr 2021 10:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbhD1KZg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 28 Apr 2021 06:25:36 -0400
Received: from wind.enjellic.com ([76.10.64.91]:47592 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239185AbhD1KZf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 28 Apr 2021 06:25:35 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 13SAOXs9024822;
        Wed, 28 Apr 2021 05:24:34 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 13SAOWS3024821;
        Wed, 28 Apr 2021 05:24:32 -0500
Date:   Wed, 28 Apr 2021 05:24:32 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jia Zhang <zhang.jia@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: SGX feature extensions patch.
Message-ID: <20210428102432.GA24783@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20210426094538.GA8264@wind.enjellic.com> <7d8cc81d-79cb-469f-24dd-30905c7e6e0a@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d8cc81d-79cb-469f-24dd-30905c7e6e0a@linux.alibaba.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Wed, 28 Apr 2021 05:24:34 -0500 (CDT)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 28, 2021 at 11:07:34AM +0800, Jia Zhang wrote:

> Hi Dr.Greg,

Good morning Jia, I hope this note finds your day going well.

> Thanks for your great job! I have a question about how do you work
> out psw for non-flc platforms?
>
> The background is that we (inclavare containers project:
> https://github.com/alibaba/inclavare-containers)
>
> also attempt to resolve the conflict between non-flc platform and sgx
> in-tree driver.
>
> Our work is available at
> https://github.com/alibaba/inclavare-containers/tree/master/hack/no-sgx-flc

Thank you, I'm pleased that, as a major SGX user, you see utility in
the work.

We just finished unit testing of the feature patch against the
recently released 5.12 kernel and we will be making that available in
the next day or so.

Please feel free to include our patch in your work or provide a
reference to it if it facilitates your initiatives.  Our approaches
are similar but non-FLC platforms will need the cryptographic policy
controls that we implement in order to get full functionality.

> In addition, I compare the different parts between us for non-flc
> support part:
>
> - Use different ioctl cmd to support init-token ioctl with token
> supplied by caller
>
> - Use different init-token ioctl structure (w/ vs w/o address parameter
> in ELRANGE)

We deliberated at significant length on how to approach this problem,
in the end, using a separate ioctl with its own index number, seemed
to be the approach that would offer the best path forward with respect
to those of us developing SGX runtimes.

The separate ioctl call we implemented acts in a manner identical to
the standard ioctl, if a NULL pointer value is passed as the address
of the EINITTOKEN block.  Thus the ioctl will work on both FLC and
non-FLC platforms and can be used exclusively by runtimes that support
both types of hardware.

A review of the kernel archives will show that I advocated rather
aggressively for the mainline driver to include the pointer in its
EINIT ioctl structure and have the in-kernel ioctl ignore that
pointer.  Unfortunately, the design of the driver was driven by
politics, and not by technology and the needs of the individuals that
will be actually using the driver.

> We did the testing on sgx1 machine and found it is required to modify
> psw. See https://github.com/alibaba/inclavare-containers/blob/master/hack/no-sgx-flc/Linux-SGX-PSW-2.13-Support-SGX1-machine-with-SGX-in-tree-driver.patch
>
> So we are interested how do you avoid to modify PSW to work out.

By definition, the SGX runtimes will need to be modified in order to
make all of work for the user community.  I believe the approach that
we ended up using, with a separate ioctl index, will minimize the
changes that are needed and allow the runtimes to work on both FLC and
non-FLC hardware with minimal changes.

I'm quite familiar with the Intel SDK/PSW, since we did a complete
C-only re-implementation of the PSW, however, I don't have a platform
right now that will build the Intel stack.  I'm assuming you do, so if
you are interested we could collaborate on making the necessary
changes.

The basic strategy would be as follows:

Modify the sgx_enclave_init_in_kernel structure definition in the
following file:

psw/urts/linux/isgx.h

To include a __u64 token structure element.

Modify the following function

psw/enclave_common/sgx_common_enclave.cpp:enclave_initialize()

So that the terminal 'else' clause that ends up handling the
SGX_DRIVER_IN_KERNEL path initializes both pointer values to NULL.

I would lift the code in the first 'if' clause, that loads the launch
token for the out-of-tree driver, into a separate function to avoid
code replication.

In the SGX_DRIVER_IN_KERNEL path use the call that you implemented in
your initial PSW modification, to check on the status of FLC support,
to gate calling the token generation code on a non-FLC platform and
set the token value of the sgx_enclave_init_in_kernel structure to the
address of the token block that the function returns.

That should produce a PSW that initializes enclaves on both non-FLC
and FLC platforms.

If you are interested I can work up a basic outline patch that you can
work from if you are interested.

Obviously, for completeness, the PSW should probe for the existence of
the new ioctl if the in-kernel driver is detected, but that type of
functionality can be added after the basics are working.

> Cheers,
> Jia

Let me know your thoughts and we will go from there.

Best wishes for a productive remainder of the week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Man, despite his artistic pretensions, his sophistication and many
 accomplishments, owes the fact of his existence to a six-inch layer of
 topsoil and the fact that it rains."
                                -- Anonymous writer on perspective.
                                   GAUSSIAN quote.
