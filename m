Return-Path: <SRS0=BSu2=CF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FF0C433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 14:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F0122B4E
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 14:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgH0Ovq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:51:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:42293 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbgH0N1e (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Aug 2020 09:27:34 -0400
IronPort-SDR: P0z2pDtIWxxFq38bvNzr4kQqYjLagW4ExrFnRyLR3+iWMiwvmMA8zlmlDSfCmnvYVShHmDzYWu
 WxBzv+it4M/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="153895895"
X-IronPort-AV: E=Sophos;i="5.76,359,1592895600"; 
   d="scan'208";a="153895895"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 06:24:50 -0700
IronPort-SDR: Ke2l8t9YhErArjp+te+yH/vIPFO56rsQI3/DhOc+Xg4yTzOeKSk3G0u9JyOR4VVUSOGnOS1shn
 azdhMXNXazYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,359,1592895600"; 
   d="scan'208";a="323592489"
Received: from tbeaumon-mobl3.ger.corp.intel.com (HELO localhost) ([10.252.55.254])
  by fmsmga004.fm.intel.com with ESMTP; 27 Aug 2020 06:24:43 -0700
Date:   Thu, 27 Aug 2020 16:24:36 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20200827132436.GA4674@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
 <20200826145239.GC22390@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826145239.GC22390@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 26, 2020 at 04:52:39PM +0200, Borislav Petkov wrote:
> On Thu, Jul 16, 2020 at 04:52:51PM +0300, Jarkko Sakkinen wrote:
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > index 59472cd6a11d..35f713e3a267 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -323,6 +323,7 @@ Code  Seq#    Include File                                           Comments
> >                                                                       <mailto:tlewis@mindspring.com>
> >  0xA3  90-9F  linux/dtlk.h
> >  0xA4  00-1F  uapi/linux/tee.h                                        Generic TEE subsystem
> > +0xA4  00-1F  uapi/asm/sgx.h                                          Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)
> 
> Again, maybe add <mailto:linux-sgx@vger.kernel.org> ?
> 
> This is from a previous review - please be more careful when addressing
> review comments - either do them or object to them but silently ignoring
> them is not cool.
> 
> >  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> >  0xAB  00-1F  linux/nbd.h
> >  0xAC  00-1F  linux/raw.h
> > diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> > new file mode 100644
> > index 000000000000..3787d278e84b
> > --- /dev/null
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> > @@ -0,0 +1,25 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */
> 
> checkpatch is not happy about something:
> 
> WARNING: 'SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */' is not supported in LICENSES/...
> #79: FILE: arch/x86/include/uapi/asm/sgx.h:1:
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */

I don't know what has gone in my head when I wrote that but it looks
plain wrong even without running checkpatch.pl

The line should express the dijunction of "GPL-2.0+ WITH
Linux-syscall-note" and "BSD-3-Clause".

Grepping the kernel tree, I can find 34 instances of these in uapi
files:

  /* SPDX-License-Identifier: ((GPL-2.0+ WITH Linux-syscall-note) OR BSD-3-Clause) */

I have not checked if this passes checkpatch.pl yet, but I would
be surprised if that did not pass (obviously I'll check that).

> 
> ...
> 
> > +/**
> > + * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
> > + * @filep:	open file to /dev/sgx
> 
> Also from a previous review:
> 
> "That's
> 
> @encl: enclave pointer
> 
> or so."

Yes, for sure. Thanks.

> > + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> > + *
> > + * Allocate kernel data structures for a new enclave and execute ECREATE after
> > + * verifying the correctness of the provided SECS.
> > + *
> > + * Note, enforcement of restricted and disallowed attributes is deferred until
> > + * sgx_ioc_enclave_init(), only the architectural correctness of the SECS is
> > + * checked by sgx_ioc_enclave_create().
> 
> From that same review:
> 
> "Well, I don't see that checking. Where is it?"
> 
> Ok, I'm going to stop here. Please go over v33's review and either
> address *all* feedback or incorporate it into your patches if you agree
> with it but do not silently ignore it. One of the things I very strongly
> detest is ignored review comments.

I'm sorry about that. This was not intentional. I'll revisit them by
going through all your responses from here:

  https://patchwork.kernel.org/patch/11581715/

v34 had the splitting of the big driver patch into multiple patches.

During that process I've obviously failed to address these.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
