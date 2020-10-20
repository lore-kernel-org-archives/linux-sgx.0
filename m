Return-Path: <SRS0=ABwn=D3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26391C4363A
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Oct 2020 16:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D72D422242
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Oct 2020 16:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387850AbgJTQkJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 20 Oct 2020 12:40:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:24589 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387765AbgJTQkJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 20 Oct 2020 12:40:09 -0400
IronPort-SDR: Zskibe4fzMQ5nMuv8p/SVRcW8tfYMGz6vw/Xu8VQs8zwEL4jGFb19JCbZwsp/fPH712I69/VuB
 auq9vQ8twTYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="167330795"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="167330795"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 09:40:04 -0700
IronPort-SDR: MoYFv3g53SAR0EFIb6i0dukRHdLLl8fsDnFqcj06Q4tcaNv6xZzgBKy/8/bgaBTFdgv7YwWv4O
 QAE+1UeOOkxg==
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="522439848"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 09:40:02 -0700
Date:   Tue, 20 Oct 2020 09:40:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
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
Message-ID: <20201020163959.GB28909@linux.intel.com>
References: <b737fcab-bfde-90e1-1101-82d646a6f5b7@intel.com>
 <20200925000052.GA20333@linux.intel.com>
 <32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com>
 <20200925194304.GE31528@linux.intel.com>
 <230ce6da-7820-976f-f036-a261841d626f@intel.com>
 <20200928005347.GB6704@linux.intel.com>
 <6eca8490-d27d-25b8-da7c-df4f9a802e87@intel.com>
 <20201018084920.GA19255@wind.enjellic.com>
 <20201019213105.GE23072@linux.intel.com>
 <20201020100118.GA6957@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020100118.GA6957@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 20, 2020 at 05:01:18AM -0500, Dr. Greg wrote:
> On Mon, Oct 19, 2020 at 02:31:05PM -0700, Sean Christopherson wrote:
> 
> Good morning, I hope the day is starting well for everyone.
> 
> > On Sun, Oct 18, 2020 at 03:49:20AM -0500, Dr. Greg wrote:
> > > Is this even a relevant control if we cede the notion of dynamically
> > > loadable enclave code, which is the objective of SGX2 hardware, which
> > > will in all likelihood be the only relevant hardware implementation in
> > > the future?
> 
> > Yes, it's still relevant.  Giving the thumbs up to dynamically
> > loadable code is not a purely binary decision, e.g. a user/admin can
> > allow RW->RX transitions but still disallow full RWX permissions.
> 
> With respect to the security issue at hand, the only relevant issue
> would seem to be if a page had write permissions at one time in its
> trajectory to having execute permisions, isn't this correct?

No.  RW->RX has different properties than RWX.  E.g. an enclave that
dynamically loads code is not the same thing as an enclave that allows
simultaneously writing and executing a page.

> The next paragraph of my reply wasn't included in your reply, but I
> did state that the mprotect hook would be relevant if its purpose was
> to disallow this permission trajectory and in the process disable
> enclave dynamic code loading and execution.
> 
> So to assist everyone in understanding this issue and the security
> implications involved, is the ultimate purpose of the mprotect hook to
> disable dynamic code loading?

No, it's to provide line of sight to enforcing granular LSM checks on enclave
pages.  Jumping back to the RWX thing, as a defense in depth measure, a policy
owner could set an SELinux policy to never allow RWX, even for enclaves that
dynamically load code.

Whether or not having per-page granluarity on enclave permission checks is
valuable/interesting is debatable, e.g. it's why LSM integration is notably
absent from the this series.  But, adding the ->mprotect() hook is relatively
cheap and can always be removed if it's deemed unnecessary in the long run.
The reverse is not true; omitting ->mprotect() commits the kernel to an ABI
that is either ugly and potentially painful (require all enclaves to declare
full RWX permissions), or flat out prevents adding granular LSM support in
the future (do nothing).
