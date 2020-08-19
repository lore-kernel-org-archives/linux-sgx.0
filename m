Return-Path: <SRS0=I8pg=B5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB27C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 20:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 307542078D
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 20:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHSUzj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Aug 2020 16:55:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:28146 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSUzi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Aug 2020 16:55:38 -0400
IronPort-SDR: 1NxtZjDHVXNHt01K4DtupMNYD2+odPqqu3ZtIpDQalGl3M/5iLpNF1viwrIlaiAQqE/0FM9l1I
 gPjt1a/9N0WQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="134716239"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="134716239"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 13:55:38 -0700
IronPort-SDR: VlV/9OPSacazBenJZ5fFS2W24H6ukpLvH9zw/nrm8Fj6arYybrI++k4obJcKv+uyw/SNn/Bn0f
 I/91wrw8YsEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="497879070"
Received: from abojanow-mobl4.ger.corp.intel.com (HELO localhost) ([10.252.52.107])
  by fmsmga005.fm.intel.com with ESMTP; 19 Aug 2020 13:55:32 -0700
Date:   Wed, 19 Aug 2020 23:55:29 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 23/24] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200819205529.GA9224@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-24-jarkko.sakkinen@linux.intel.com>
 <20200728213511.GB13081@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728213511.GB13081@duo.ucw.cz>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 28, 2020 at 11:35:11PM +0200, Pavel Machek wrote:
> Hi!
> 
> > +CPUs starting from Icelake use Total Memory Encryption (TME) in the place of
> > +MEE. TME throws away the Merkle tree, which means losing integrity and
> > +anti-replay protection but also enables variable size memory pools for EPC.
> > +Using this attack for benefit would require an interposer on the system bus.
> 
> It is not exactly clear what "this attack" means.
> 
> (And it would be cool to explain against what SGX is protecting. I
> thought it was malicious RAM, but apparently not on Icelake+).

Icelake has the same capabilities against software attacks as
generations before that given the same CPU access control.

A custom interposer on a bus could use replay for the data coming out of
the CPU package. In pre-Icelake (i.e. MEE), this is prevented with a
Merkle tree.

However, DMA is still blocked by the PRMRR to the EPC memory even on
Icelake (SDM section 41.10), which adds some cost to do so (e.g. a
malicous peripheral).

Memory is of course encrypted in both architectures.

Agreed that the current paragraph looks confusing. I'll refine it based
on what I just wrote. I want to make it as transparent as possible but
it cannot be achieved without appropriate feedback.

> 
> > +Backing storage
> > +===============
> > +
> > +Backing storage is shared and not accounted. It is implemented as a private
> > +shmem file. Providing a backing storage in some form from user space is not
> > +possible - accounting would go to invalid state as reclaimed pages would get
> > +accounted to the processes of which behalf the kernel happened to be acting on.
> 
> "of which behalf" -- I can't parse that?

Executing in a process context.

> 
> > +Access control
> > +==============
> > +
> > +`mmap()` permissions are capped by the enclave permissions. A direct
> > +consequence of this is that all the pages for an address range must be added
> > +before `mmap()` can be applied. Effectively an enclave page with minimum
> > +permission in the address range sets the permission cap for the mapping
>    ~~~~~~~~~~
>     permissions?

Thanks, I'll fix that one.

> 									Pavel

Sorry for the late response. I came last week back from vacation and
have been purging the piled up stacks of email (looking at your domain
I have to add that I was in Brno, Czech).

/Jarkko
