Return-Path: <SRS0=YjYT=DA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED9BC4727F
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 13:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8DD620B1F
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 13:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIWNvF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Sep 2020 09:51:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:62998 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgIWNvF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Sep 2020 09:51:05 -0400
IronPort-SDR: lSAHiCfFNzhPKvM8qnnn6LOXfxv7bQ0UHiCZ5IFy+63d4Ab/hL30TpJ9OXHWK19Dr2nQ9MT7DP
 qQKWlWca3Mdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="222463449"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="222463449"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 06:51:04 -0700
IronPort-SDR: yyNGo+n6ctyRaFxB91JG+y8VaBIUUeE4ZFEi3f24Rip0ALlmEn95aL6vGuzTzKadwpxjdssfQ6
 c0Ei3m90a9EA==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="511654204"
Received: from ichiojdo-mobl.ger.corp.intel.com (HELO localhost) ([10.252.51.82])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 06:50:58 -0700
Date:   Wed, 23 Sep 2020 16:50:56 +0300
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
Message-ID: <20200923135056.GD5160@linux.intel.com>
References: <20200915112842.897265-11-jarkko.sakkinen@linux.intel.com>
 <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
 <20200918235337.GA21189@sjchrist-ice>
 <20200921124946.GF6038@linux.intel.com>
 <20200921165758.GA24156@linux.intel.com>
 <20200921210736.GB58176@linux.intel.com>
 <20200921211849.GA25403@linux.intel.com>
 <20200922052957.GA97272@linux.intel.com>
 <20200922053515.GA97687@linux.intel.com>
 <20200922164301.GB30874@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922164301.GB30874@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 09:43:02AM -0700, Sean Christopherson wrote:
> On Tue, Sep 22, 2020 at 08:35:15AM +0300, Jarkko Sakkinen wrote:
> > On Tue, Sep 22, 2020 at 08:30:06AM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Sep 21, 2020 at 02:18:49PM -0700, Sean Christopherson wrote:
> > > > Userspace can add the page without EXEC permissions in the EPCM, and thus
> > > > avoid the noexec/VM_MAYEXEC check.  The enclave can then do EMODPE to gain
> > > > EXEC permissions in the EPMC.  Without the ->mprotect() hook, we wouldn't
> > > > be able to detect/prevent such shenanigans.
> > > 
> > > Right, the VM_MAYEXEC in the code is nested under VM_EXEC check.
> > > 
> > > I'm only wondering why not block noexec completely with any permissions,
> > > i.e. why not just have unconditional VM_MAYEXEC check?
> > 
> > I.e. why not this:
> > 
> > static int __sgx_encl_add_page(struct sgx_encl *encl,
> > 			       struct sgx_encl_page *encl_page,
> > 			       struct sgx_epc_page *epc_page,
> > 			       struct sgx_secinfo *secinfo, unsigned long src)
> > {
> > 	struct sgx_pageinfo pginfo;
> > 	struct vm_area_struct *vma;
> > 	struct page *src_page;
> > 	int ret;
> > 
> > 	vma = find_vma(current->mm, src);
> > 	if (!vma)
> > 		return -EFAULT;
> > 
> > 	if (!(vma->vm_flags & VM_MAYEXEC))
> > 		return -EACCES;
> > 
> > I'm not seeing the reason for "partial support" for noexec partitions.
> > 
> > If there is a good reason, fine, let's just then document it.
> 
> There are scenarios I can contrive, e.g. loading an enclave from a noexec
> filesystem without having to copy the entire enclave to anon memory, or
> loading a data payload from a noexec FS.
> 
> They're definitely contrived scenarios, but given that we also want the
> ->mprotect() hook/behavior for potential LSM interaction, supporting said
> contrived scenarios costs is "free".

For me this has caused months of confusion and misunderstanding of this
feature. I only recently realized that "oh, right, we invented this".

They are contrived scenarios enough that they should be considered when
the workloads hit.

Either we fully support noexec or not at all. Any "partial" thing is a
two edged sword: it can bring some robustness with the price of
complexity and possible unknown uknown scenarios where they might become
API issue.

I rather think later on how to extend API in some way to enable such
contrivid scenarios rather than worrying about how this could be abused.

The whole SGX is complex beast already so lets not add any extra when
there is no a hard requirement to do so.

I'll categorically deny noexec in the next patch set version.

/Jarkko
