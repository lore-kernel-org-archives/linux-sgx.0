Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C08C4363D
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 05:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0DC423A9F
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 05:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgIVFfZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 01:35:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:56330 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgIVFfZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 01:35:25 -0400
IronPort-SDR: J6zIK6hg7euPGvSrTbFIryUw0OQXT0oojQr7HJuxzjYdYA2xApMleTYBcdwxjHZUXIEfrSgx7F
 gdJhjUT9vzLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="245375678"
X-IronPort-AV: E=Sophos;i="5.77,289,1596524400"; 
   d="scan'208";a="245375678"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 22:35:24 -0700
IronPort-SDR: IjY1VHA7Mdgzde0do2ORSGHmGVo2ohZ1JRxey/zoMcwFSBrtHYawzvuYSM4lFdjoJmMWwQhD11
 zTSA1Lu+wg6g==
X-IronPort-AV: E=Sophos;i="5.77,289,1596524400"; 
   d="scan'208";a="485807667"
Received: from krodolf-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.49.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 22:35:17 -0700
Date:   Tue, 22 Sep 2020 08:35:15 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Message-ID: <20200922053515.GA97687@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-11-jarkko.sakkinen@linux.intel.com>
 <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
 <20200918235337.GA21189@sjchrist-ice>
 <20200921124946.GF6038@linux.intel.com>
 <20200921165758.GA24156@linux.intel.com>
 <20200921210736.GB58176@linux.intel.com>
 <20200921211849.GA25403@linux.intel.com>
 <20200922052957.GA97272@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922052957.GA97272@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 08:30:06AM +0300, Jarkko Sakkinen wrote:
> On Mon, Sep 21, 2020 at 02:18:49PM -0700, Sean Christopherson wrote:
> > On Tue, Sep 22, 2020 at 12:07:36AM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Sep 21, 2020 at 09:57:58AM -0700, Sean Christopherson wrote:
> > > > On Mon, Sep 21, 2020 at 03:49:46PM +0300, Jarkko Sakkinen wrote:
> > > > > On Fri, Sep 18, 2020 at 04:53:37PM -0700, Sean Christopherson wrote:
> > > > > > a noexec filesystem by loading code into an enclave, and to give the kernel the
> > > > > > option of adding enclave specific LSM policies in the future.
> > > > > > 
> > > > > > The source file (if one exists) for the enclave is long gone when the enclave
> > > > > > is actually mmap()'d and mprotect()'d.  To enforce noexec, the requested
> > > > > > permissions for a given page are snapshotted when the page is added to the
> > > > > > enclave, i.e. when the enclave is built.  Enclave pages that will be executable
> > > > > > must originate from an a MAYEXEC VMA, e.g. the source page can't come from a
> > > > > > noexec file system.
> > > > > 
> > > > > noexec check is done in __sgx_encl_add_page(), not in this callback.
> > > > > sgx_vma_mprotect() calls sgx_encl_may_map(), which iterates the
> > > > > addresses, checks that permissions are not surpassed and there are
> > > > > no holes.
> > > > 
> > > > Yes, that's what I said.
> > > 
> > > sgx_encl_add_page() will remove such page. The callback does not
> > > interact with this process as such pages never get to the enclave.
> > 
> > I think we're in violent agreement, mostly.
> > 
> > Userspace can add the page without EXEC permissions in the EPCM, and thus
> > avoid the noexec/VM_MAYEXEC check.  The enclave can then do EMODPE to gain
> > EXEC permissions in the EPMC.  Without the ->mprotect() hook, we wouldn't
> > be able to detect/prevent such shenanigans.
> 
> Right, the VM_MAYEXEC in the code is nested under VM_EXEC check.
> 
> I'm only wondering why not block noexec completely with any permissions,
> i.e. why not just have unconditional VM_MAYEXEC check?

I.e. why not this:

static int __sgx_encl_add_page(struct sgx_encl *encl,
			       struct sgx_encl_page *encl_page,
			       struct sgx_epc_page *epc_page,
			       struct sgx_secinfo *secinfo, unsigned long src)
{
	struct sgx_pageinfo pginfo;
	struct vm_area_struct *vma;
	struct page *src_page;
	int ret;

	vma = find_vma(current->mm, src);
	if (!vma)
		return -EFAULT;

	if (!(vma->vm_flags & VM_MAYEXEC))
		return -EACCES;

I'm not seeing the reason for "partial support" for noexec partitions.

If there is a good reason, fine, let's just then document it.

/Jarkko
