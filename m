Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6701C4363C
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 21:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB4EB23A60
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 21:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgIUVSy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 17:18:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:33250 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgIUVSy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 17:18:54 -0400
IronPort-SDR: bjrnNogAio+NRWilHCrlFZ9kuCNkedN9rSsKjEQQgqjiz14r9jkEh0oJ4SQ72cPfF85QQHUG0J
 A9abKjWeGufQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="224626366"
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="224626366"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 14:18:50 -0700
IronPort-SDR: gpMzqasrgDOlunN7o47es6wodaUU1K4jOZ0/VcEWxyI9wLagCpb8B7ZqSYTDs5MMLS+wr/u2HK
 f9Tpb58uu1Nw==
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="485669996"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 14:18:50 -0700
Date:   Mon, 21 Sep 2020 14:18:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20200921211849.GA25403@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-11-jarkko.sakkinen@linux.intel.com>
 <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
 <20200918235337.GA21189@sjchrist-ice>
 <20200921124946.GF6038@linux.intel.com>
 <20200921165758.GA24156@linux.intel.com>
 <20200921210736.GB58176@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921210736.GB58176@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 12:07:36AM +0300, Jarkko Sakkinen wrote:
> On Mon, Sep 21, 2020 at 09:57:58AM -0700, Sean Christopherson wrote:
> > On Mon, Sep 21, 2020 at 03:49:46PM +0300, Jarkko Sakkinen wrote:
> > > On Fri, Sep 18, 2020 at 04:53:37PM -0700, Sean Christopherson wrote:
> > > > a noexec filesystem by loading code into an enclave, and to give the kernel the
> > > > option of adding enclave specific LSM policies in the future.
> > > > 
> > > > The source file (if one exists) for the enclave is long gone when the enclave
> > > > is actually mmap()'d and mprotect()'d.  To enforce noexec, the requested
> > > > permissions for a given page are snapshotted when the page is added to the
> > > > enclave, i.e. when the enclave is built.  Enclave pages that will be executable
> > > > must originate from an a MAYEXEC VMA, e.g. the source page can't come from a
> > > > noexec file system.
> > > 
> > > noexec check is done in __sgx_encl_add_page(), not in this callback.
> > > sgx_vma_mprotect() calls sgx_encl_may_map(), which iterates the
> > > addresses, checks that permissions are not surpassed and there are
> > > no holes.
> > 
> > Yes, that's what I said.
> 
> sgx_encl_add_page() will remove such page. The callback does not
> interact with this process as such pages never get to the enclave.

I think we're in violent agreement, mostly.

Userspace can add the page without EXEC permissions in the EPCM, and thus
avoid the noexec/VM_MAYEXEC check.  The enclave can then do EMODPE to gain
EXEC permissions in the EPMC.  Without the ->mprotect() hook, we wouldn't
be able to detect/prevent such shenanigans.

> > I would copy-paste the part of the response that was snipped...
> 
> I do agree with the main conclusions but it contains also things that I
> do not see relating that much, like noexec partitions.

As above, this does directly related to noexec/VM_MAYEXEC.

> It goes too far in detail what will LSM's end up doing. I absolutely do not
> want to forecast too far how LSM hooks would work.

That's fine, I was responding to Andy's question, not intending to write a
changelog.
 
> Since we do not have ioctl's for EMODPE and such, I see EMODPE as the
> only reason for doing this right now. Otherwise, we are in trouble with
> any possible LSM callbacks. For any sort of access control decision,
> things decided must stick.

Yes, again, violent agreement :-).

> I would add something like this to the commit message largely based on
> your text:
> 
> "SGX stores the permissions for each page when they are first added, and
> will implement this callback to check that mmap() or mprotect() does not
> surpass these permissions in the requested address range.
> 
> This is done to prevent using EMODPE upgrading permissions of a page
> after mmap() or mprotect() has been done, which would prevent any sort
> of LSM callbacks to be implemented later on because the access control
> decision could deprecate."
