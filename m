Return-Path: <SRS0=PIOK=C3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D5AC43464
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 23:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB0D021D43
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 23:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgIRXxq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Sep 2020 19:53:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:33797 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgIRXxq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Sep 2020 19:53:46 -0400
IronPort-SDR: w88lfMPgP8nXs6QNBM3G9+SRjZ14xkOCZ5XgA13OPSP9X04b0sjDBzC0nzr1DkG4NMrOIrcm8e
 GdoUPGxCptDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="160973147"
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="160973147"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:53:41 -0700
IronPort-SDR: 7Tx3tHHwo1WoVwkybdZU7HNvtlLMmqX3VW0acb1K3sujhz8PdF+fzQtAi4QgCRrc9FtFlGDduE
 oOSShv2q69YQ==
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="381080557"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:53:38 -0700
Date:   Fri, 18 Sep 2020 16:53:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200918235337.GA21189@sjchrist-ice>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-11-jarkko.sakkinen@linux.intel.com>
 <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 18, 2020 at 08:09:04AM -0700, Andy Lutomirski wrote:
> On Tue, Sep 15, 2020 at 4:28 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Add vm_ops()->mprotect() for additional constraints for a VMA.
> >
> > Intel Software Guard eXtensions (SGX) will use this callback to add two
> > constraints:
> >
> > 1. Verify that the address range does not have holes: each page address
> >    must be filled with an enclave page.
> > 2. Verify that VMA permissions won't surpass the permissions of any enclave
> >    page within the address range. Enclave cryptographically sealed
> >    permissions for each page address that set the upper limit for possible
> >    VMA permissions. Not respecting this can cause #GP's to be emitted.

Side note, #GP is wrong.  EPCM violations are #PFs.  Skylake CPUs #GP, but
that's technically an errata.  But this isn't the real motivation, e.g.
userspace can already trigger #GP/#PF by reading/writing a bad address, SGX
simply adds another flavor.

> It's been awhile since I looked at this.  Can you remind us: is this
> just preventing userspace from shooting itself in the foot or is this
> something more important?

Something more important, it's used to prevent userspace from circumventing
a noexec filesystem by loading code into an enclave, and to give the kernel the
option of adding enclave specific LSM policies in the future.

The source file (if one exists) for the enclave is long gone when the enclave
is actually mmap()'d and mprotect()'d.  To enforce noexec, the requested
permissions for a given page are snapshotted when the page is added to the
enclave, i.e. when the enclave is built.  Enclave pages that will be executable
must originate from an a MAYEXEC VMA, e.g. the source page can't come from a
noexec file system.

The ->mprotect() hook allows SGX to reject mprotect() if userspace is declaring
permissions beyond what are allowed, e.g. trying to map an enclave page with
EXEC permissions when the page was added to the enclave without EXEC.

Future LSM policies have a similar need due to vm_file always pointing at
/dev/sgx/enclave, e.g. policies couldn't be attached to a specific enclave.
->mprotect() again allows enforcing permissions at map time that were checked
at enclave build time, e.g. via an LSM hook.

Deferring ->mprotect() until LSM support is added (if it ever is) would be
problematic due to SGX2.  With SGX2, userspace can extend permissions of an
enclave page (for the CPU's EPC Map entry, not the kernel's page tables)
without bouncing through the kernel.  Without ->mprotect () enforcement.
userspace could do EADD(RW) -> mprotect(RWX) -> EMODPE(X) to gain W+X.  We
want to disallow such a flow now, i.e. force userspace to do EADD(RW,X), so
that the hypothetical LSM hook would have all information at EADD(), i.e.
would be aware of the EXEC permission, without creating divergent behavior
based on whether or not an LSM is active.
