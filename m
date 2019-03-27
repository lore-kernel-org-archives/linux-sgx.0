Return-Path: <SRS0=L3CU=R6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50770C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 20:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 200F02147C
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 20:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfC0UGM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:06:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:40365 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbfC0UGM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 Mar 2019 16:06:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Mar 2019 13:06:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,277,1549958400"; 
   d="scan'208";a="137797702"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga003.jf.intel.com with ESMTP; 27 Mar 2019 13:06:11 -0700
Date:   Wed, 27 Mar 2019 13:06:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190327200610.GF9310@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
 <20190326132650.GA31662@linux.intel.com>
 <20190326235852.GL3757@linux.intel.com>
 <20190327052830.GF15397@linux.intel.com>
 <825f5477-c90a-b54b-efeb-a1dc43ccc9d2@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <825f5477-c90a-b54b-efeb-a1dc43ccc9d2@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 27, 2019 at 06:38:57PM +0000, Jethro Beekman wrote:
> On 2019-03-26 22:28, Jarkko Sakkinen wrote:
> >On Tue, Mar 26, 2019 at 04:58:52PM -0700, Sean Christopherson wrote:
> >>On Tue, Mar 26, 2019 at 03:26:50PM +0200, Jarkko Sakkinen wrote:
> >>>On Thu, Mar 21, 2019 at 05:51:11PM +0200, Jarkko Sakkinen wrote:
> >>>>>Yuck.  If we remove the driver specific Makefile then we can eliminate
> >>>>>the "../" prefix here.  E.g. in the main SGX Makefile:
> >>>>>
> >>>>>obj-$(CONFIG_INTEL_SGX_DRIVER) += driver/main.o driver/ioctl.o
> >>>>
> >>>>I think this is a great idea.
> >>>
> >>>On a 2nd thought not gonna do anything to that because it would
> >>>require to move driver.h and it is cleaner to keep all the driver
> >>>files in the same directory (and separated from the core).
> >>
> >>What about collapsing driver/*.c into driver.c and moving driver.{c,h}
> >>to the root sgx directory?  The bulk of driver/main.c is securityfs
> >>and platform driver code, e.g. has a good chance of going away entirely
> >>or being moved out of the "driver".  At that point there probably isn't
> >>a strong reason to have driver/main.c and driver/ioctl.c.
> >
> >I think doing anything major would require to lock in whether to have
> >the LKM for the driver at all. If we wipe out the driver, then this is
> >just matter of moving dev management part to lets say dev.c.
> >
> >Unless there is some real production use I can wipe it away. For v19
> >I wanted to fix it namely because in v18 LKM was just broken. It is
> >always good to make decisions based on working code.
> 
> It should be a module because things should be modules when possible. I'm
> not sure what the "Linux policy" is here but this seems obvious to me.
> 
> For example:
> 
> * Modules allow users to easily disable functionality that they don't use/is
> buggy for them/other reasons using blacklisting.
> * Modules allow users to customize their functionality without having to
> rebuild the entire kernel.
> * Modules allow developers to customize their modules without having to
> rebuild the entire kernel.

I agree with all of the above, but unfortunately blacklisting is really
the only benefit that would be realized by modularizing the driver.  The
"driver" at this point is just the device and its ioctls, the meat of
the functionality has been moved into the subsystem proper.  And the few
remaining tidbits of functionality, e.g. sgx_encl_page_alloc() and
sgx_encl_alloc(), probably should be moved out of ioctl.c as well.

Theoretically, we could revert to the old model, i.e. move a big pile of
code back into the driver, but that approach has a variety of technical
issues that IMO outweigh the benefits of having a module.

Tying into the your comment of "things should be modules when possible",
we've gradually come to the realization that truly modularizing the SGX
driver isn't possible, at least not without compromising other parts of
the design.

For example, relying on the EPC ACPI entry to autoprobe the driver falls
apart when virtualization support also wants to add an SGX device (or we
end up with a weird split model where the uapi driver is autoprobed via
ACPI and the virtualization device is probed by the SGX subsystem).

Relying on the EPC ACPI entry really shows its warts when systems
with multiple EPC sections show up.  The SGS BIOS writer's guide
(allegedly, I haven't personally read it) says that one and only one
EPC entry should be created in the ACPI tables, i.e. software must
use CPUID to enumerate the base+size of EPC sections.

In other words, the whole ACPI entry and platform device approach was a
hack purely to allow SGX to be implemented as an out-of-kernel driver.
If the darn ACPI hack had never been added in the first place, i.e.
CPUID is the only way to enumerate/probe SGX, then odds are we wouldn't
even be having this dicsussion and no one would bat an eye at SGX being
implemented as an Intel-specific feature that is baked into the kernel.

> Specifically for SGX I can think of the following reasons as well:
> 
> * Module-based hypervisors may want to make EPC allocations for their
> guests.
> * Easy experimentation with different EPC interfaces
> * Easy experimentation with in-kernel LE
> 
> --
> Jethro Beekman | Fortanix
> 
> >
> >/Jarkko
> >
> 


