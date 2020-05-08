Return-Path: <SRS0=hhxz=6W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55721C38A2A
	for <linux-sgx@archiver.kernel.org>; Fri,  8 May 2020 19:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31328218AC
	for <linux-sgx@archiver.kernel.org>; Fri,  8 May 2020 19:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgEHT4h (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 8 May 2020 15:56:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:28180 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHT4g (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 8 May 2020 15:56:36 -0400
IronPort-SDR: Md3Q+Boyc5oIN5e6H9kuKuPAMyNChTPMjHLpsByVsn3IuTCBfRjGq19giiuVaYOlIhKSMURH8E
 fQv69+mqq0QA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 12:56:36 -0700
IronPort-SDR: 5dvUlHF0eVomO7/SJ8Ft/0t312Z5Qft3VfjLwBlw3b+HpF2haHTQ5a2NFlWrt2OpYTu5cNOtGy
 tD2mYVzEQvXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,368,1583222400"; 
   d="scan'208";a="296246998"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2020 12:56:35 -0700
Date:   Fri, 8 May 2020 12:56:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200508195635.GR27052@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <20200426165753.GA11046@wind.enjellic.com>
 <87d07gk24l.fsf@nanos.tec.linutronix.de>
 <20200508190226.GA31465@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508190226.GA31465@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 08, 2020 at 02:02:26PM -0500, Dr. Greg wrote:
> On Thu, May 07, 2020 at 02:41:30AM +0200, Thomas Gleixner wrote:
> > The diffstat of your patch is irrelevant. What's relevant is the
> > fact that it is completely unreviewed and that it creates yet
> > another user space visible ABI with a noticable lack of
> > documentation.

...

> As to lack of review, we would certainly welcome technical and API
> comments but we cannot force them.

Thomas' point isn't that your code needs to be reviewed, it's that trying
to squeeze it into the initial merge will, not might, _will_ push out the
acceptance of SGX.  The same is true for other features we have lined up,
e.g. KVM and cgroup support.  It's not a slight on your code, it's just
reality at this point.

> In fact, anyone who reviews the patch will see that the current driver
> creates a pointer in the ioctl call to pass downward into the hardware
> initialization routines.  Our code simply replaces that pointer with
> one supplied by userspace.

Personally, I'm in favor of adding a reserved placeholder for a token so
as to avoid adding a second ioctl() in the event that something gets
upstreamed that wants the token.  Ditto for a file descriptor for the
backing store in sgx_enclave_create.

But, I have contributed exactly zero ioctls to the kernel, so take that
with a big block of salt :-)

> At the very least a modular form of the driver should be considered
> that would allow alternate implementations.  Sean indicated that there
> was a 'kludgy' approach that would allow an alternate modular
> implementation alongside the in-kernel driver.  I believe that Andy
> has already indicated that may not be an advisable approach.

Modularizing the the driver does nothing for your use case.  The "driver"
is a relatively lightweight wrapper, removing that is akin to making
/dev/sgx/enclave inaccessible, i.e. it doesn't make the EPC tracking and
core code go away.  Modularizing the whole thing is flat out not an option,
as doing so is not compatible with an EPC cgroup and adds unnecessary
complexity to KVM enabling, both of which are highly desired features by
pretty much everyone that plans on using SGX.

Andy is right to caution against playing games to squish in-kernel things,
but the virtualization snafu is a completely different beast.  E.g. SGX
doesn't require fiddling with CR4, won't corrupt random memory across
kexec(), doesn't block INIT, etc...  And I'm not advocating long-term
shenanigans, I just wanted to point out that there are options for running
out-of-tree drivers in the short term, e.g. until proper policy controls
land upstream.
