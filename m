Return-Path: <SRS0=JOly=6K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09BDC54FCB
	for <linux-sgx@archiver.kernel.org>; Sun, 26 Apr 2020 16:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 877B72071C
	for <linux-sgx@archiver.kernel.org>; Sun, 26 Apr 2020 16:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgDZQ6b (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 26 Apr 2020 12:58:31 -0400
Received: from wind.enjellic.com ([76.10.64.91]:42202 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgDZQ6b (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 26 Apr 2020 12:58:31 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 03QGvrsi012077;
        Sun, 26 Apr 2020 11:57:53 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 03QGvrY2012076;
        Sun, 26 Apr 2020 11:57:53 -0500
Date:   Sun, 26 Apr 2020 11:57:53 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200426165753.GA11046@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 26 Apr 2020 11:57:54 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 22, 2020 at 12:52:56AM +0300, Jarkko Sakkinen wrote:

Good day, I hope the weekend is going well for everyone.

> Intel(R) SGX is a set of CPU instructions that can be used by applications
> to set aside private regions of code and data. The code outside the enclave
> is disallowed to access the memory inside the enclave by the CPU access
> control.
>
> ... [ elided ] ..
> 
> The current implementation requires that the firmware sets
> IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> decide what enclaves it wants run. The implementation does not create
> any bottlenecks to support read-only MSRs later on.

It seems highly unlikely that a driver implementation with any type of
support for read-only launch control registers would ever get into the
kernel.  All one needs to do is review the conversations that Matthew
Garrett's lockdown patches engender to get a sense of that, ie:

https://lwn.net/Articles/818277/

As a result, the proposed SGX driver needs support for cryptographic
policy management before it goes into the kernel.  Either the patch
that we have offered or something equivalent.

Absent that, the driver won't address the full needs of the
development community implementing runtimes.  In addition it also
poses security and privacy issues that are well documented in the
literature.

As an aside, for those who haven't spent the last 5+ years of their
life working with this technology.  SGX2 hardware platforms have the
ability to allow unrestricted code execution in enclave context.  No
amount of LSM or IMA interventions can provide any control over that.

In fact, the Confidential Computing Consortium, sponsored by none
other then the Linux Foundation, has at its fundamental tenant, the
notion of developing an eco-system that allows the execution of code
and processing of data, over which, the owner or administrator of the
platform has no visibility or control.  It would seem only logical
that adversarial interests would indulge themseleves in those
capabilities as well.

With respect to SGX and these issues, cryptographic policy management
is important for the same reason that 2-factor authentication is now
considered standard practice in the security industry.

We appreciate, Jarkko, that you feel that such infrastructure is
optional, like virtualization support, and is something that can go in
after the driver is mainlined.  As the diffstat for our patch points
out, the proposed support has virtually no impact on the driver, the
same cannot be said for virtualization capabilities.

Moreover, adding support for key based policy management later would
require the addition of another ioctl in order to avoid ABI
compatibility issues.  The current initialization ioctl is best
suited, from an engineering perspective, to support this type of
infrastructure.  In fact, the necessary support was removed from the
ioctl for political reasons rather then for any valid engineering
rationale on flexible launch control platforms, particularly with our
patch or an equivalent approach.

For the benefit of the kernel community at large, I will follow up this
e-mail with a copy of our patch for review.  In case anyone misses it,
or it is corrupted, the patch can be pulled from the following URL:

ftp://ftp.enjellic.com/pub/sgx/kernel/SFLC-current.patch

We believe the patch or an equivalent approach deserves consideration
for the following reasons:

1.) It does not modify the default behavior of the driver. ie. any
enclave will be initialized that is presented.

2.) It enables needed functionality only at the discretion and control
of the platform owner/administrator.

3.) The impact on the architecture of the driver is negligible.

In closing, it is important to note that the proposed SGX driver is
not available as a module.  This effectively excludes any alternative
implementations of the driver without replacement of the kernel at
large.  It also means that any platform, with SGX hardware support,
running a kernel with this driver, has the potential for the
security/privacy issues noted above.

If key based policy management is not allowed, then the driver needs
to be re-architected to have modular support so that alternative
implementations or the absence of any driver support are at least
tenable.

Hopefully this is a reasoned technical approach to what has been a
long standing issue surrounding this technology.

Best wishes for a productive week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      SGX secured infrastructure and
Enjellic Systems Development, LLC     autonomously self-defensive
4206 N. 19th Ave.                     platforms.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Opportunity is missed by most people because it is dressed in overalls
 and looks like work."
                                -- Thomas Edison
