Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EA9C4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 21:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA20523A82
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 21:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgIXV6Z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 17:58:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:46027 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgIXV6Z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 17:58:25 -0400
IronPort-SDR: a2u74Y+AetCqB2LUqrv99fQwSvr3qsOo1g6PEdKPg8FhcSSS/xTjprhKqM5oWAOMhw4CQOJZ0L
 V+OtZ7GU6C3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="222951771"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="222951771"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 14:58:24 -0700
IronPort-SDR: bbCSE4/R5ayvoWbafEt20soFZkpybG7fXU9p/ubQc1UiSKUuDr3enPuYHx8dSLInapesEHv0rP
 nGlckWlwbUrg==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="487139590"
Received: from yshmidtx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.63.233])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 14:58:17 -0700
Date:   Fri, 25 Sep 2020 00:58:15 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
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
Message-ID: <20200924215815.GB119995@linux.intel.com>
References: <20200921124946.GF6038@linux.intel.com>
 <20200921165758.GA24156@linux.intel.com>
 <20200921210736.GB58176@linux.intel.com>
 <20200921211849.GA25403@linux.intel.com>
 <20200922052957.GA97272@linux.intel.com>
 <20200922053515.GA97687@linux.intel.com>
 <20200922164301.GB30874@linux.intel.com>
 <20200923135056.GD5160@linux.intel.com>
 <op.0rgp5h0hwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200924192853.GA18826@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924192853.GA18826@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 12:28:54PM -0700, Sean Christopherson wrote:
> On Thu, Sep 24, 2020 at 02:11:37PM -0500, Haitao Huang wrote:
> > On Wed, 23 Sep 2020 08:50:56 -0500, Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >I'll categorically deny noexec in the next patch set version.
> > >
> > >/Jarkko
> > 
> > There are use cases supported currently in which enclave binary is received
> > via IPC/RPC and held in buffers before EADD. Denying noexec altogether would
> > break those, right?
> 
> No.  noexec only applies to file-backed VMAs, what you're describing is loading
> an enclave from an anon VMA, which will still have VM_MAYEXEC.
> 
> I believe you're thinking of SELinux's EXECMEM, which is required to execute
> from anonymous memory, and which we talked about (more than once) applying to
> SGX enclaves.
> 
> That being said, I still dislike the idea of requiring VM_MAYEXEC, it's a hack
> that doesn't really buy us much, if anything.

I think it makes sense as long as it is not half-way there solution.

Either require it for the full binary or not at all. I'm fine with
either.

/Jarkko
