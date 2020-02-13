Return-Path: <SRS0=OjbW=4B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE01C2BA83
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 18:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 944E220659
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 18:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgBMSHk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Feb 2020 13:07:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:55155 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgBMSHk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Feb 2020 13:07:40 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 10:07:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,437,1574150400"; 
   d="scan'208";a="238107659"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 13 Feb 2020 10:07:37 -0800
Date:   Thu, 13 Feb 2020 10:07:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200213180737.GC18610@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <d17c50a7-6900-731b-43a2-d6e49b8eb44d@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d17c50a7-6900-731b-43a2-d6e49b8eb44d@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 13, 2020 at 02:59:52PM +0100, Jethro Beekman wrote:
> On 2020-02-09 22:25, Jarkko Sakkinen wrote:
> > +/**
> > + * struct sgx_enclave_add_pages - parameter structure for the
> > + *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> > + * @src:	start address for the page data
> > + * @offset:	starting page offset
> > + * @length:	length of the data (multiple of the page size)
> > + * @secinfo:	address for the SECINFO data
> > + * @flags:	page control flags
> > + * @count:	number of bytes added (multiple of the page size)
> > + */
> > +struct sgx_enclave_add_pages {
> > +	__u64	src;
> > +	__u64	offset;
> > +	__u64	length;
> > +	__u64	secinfo;
> > +	__u64	flags;
> > +	__u64	count;
> > +};
> 
> Compared to the last time I looked at the patch set, this API removes the
> ability to measure individual pages chunks. That is not acceptable.

Why is it not acceptable?  E.g. what specific use case do you have that
_requires_ on measuring partial 4k pages of an enclave?

> On 2019-10-11 16:37, Sean Christopherson wrote:
> > Hiding the 256-byte granualarity from userspace is a good idea as it's not
> > intrinsically tied to the SGX architecture and exists only because of
> > latency requirements.
> 
> What do you mean by "it's not intrinsically tied to the SGX architecture"?
> This is a fundamental part of the SGX instruction set. This is the
> instruction definition from the SDM: "EEXTEND—Extend Uninitialized Enclave
> Measurement by 256 Bytes".

SGX fundamentally works at a 4k granularity.  EEXTEND is special cased
because extending the measurement is a slow operation, i.e. EEXTEND on more
than 256 byte chunks, *with the current implementation*, would exceeded
latency requirements, e.g. block interrupts for too long and hose the
kernel.

A future implementation of SGX could change the latency of extending the
measurement, e.g. a different algorithm that is slower/faster, and so could
introduce EEXTEND2 which would work at a different granularity than EEXTEND.

EEXTEND could have avoided the latency problems via other methods, e.g. by
being interruptible a la EINIT and/or by being restartable.  But that ship
has sailed, so to avoid future complication in the kernel's ABI we're
proposing/advocating supporting only measuring at a 4k granularity.
 
> The exact sequence of EADD/EEXTEND calls is part of the enclave hash. The OS
> mustn't arbitrarily restrict how an enclave may be loaded. If the enclave

It's not arbitrary, there are good reasons for wanting to work with 4k
granularity.  Regardless, there are many examples of the kernel arbitrarily
restricting what can be done relative to what is physically possible in
hardware.

> loader were to follows OS-specific restrictions, that would result in
> effectively different enclaves. Because of these interoperability concerns,
> 256-byte granularity *must* be exposed through the UAPI.

Interoperability with what?  Other OSes? 

> Besides only partially measuring a page, there are some other fringe cases
> that are technically possible, although I haven't seen any toolchains that do
> that. These include not interleaving EADD and EEXTEND, not using logical
> ordering for the EEXTENDs, and call EEXTEND multiple times on the same chunk.
> Maximum interoperability would require supporting any EADD/EEXTEND sequence.

Same interoperability question as above.

> Maybe we should just add an EEXTEND@offset ioctl? This would give
> fine-grained control when needed (one could set flags=0 in the add pages
> ioctl and interleave with EEXTEND as needed). If you're ok adding an EEXTEND
> ioctl I don't think this issue needs to block landing the driver in its
> current form, in which case:

We've also discussed an EEXTEND ioctl(), but ultimately couldn't come up
with a use case that _required_ partial page measurement.

> Tested-by: Jethro Beekman <jethro@fortanix.com>
> 
> Sorry for being super late with this, I know you asked me for feedback about
> this specific point in October. However, I did previously mention several
> times that being able to measure individual 256-byte chunks is necessary.
> 
> -- Jethro Beekman | Fortanix
