Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A797FC41604
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 17:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CFCB2168B
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 17:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgJGRNh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Oct 2020 13:13:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:1539 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgJGRNg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Oct 2020 13:13:36 -0400
IronPort-SDR: zDcwdFoQJAPj/U/Zq6r1lPvtKAHcAONP+xi5hrEcEvq1xv34m77Yr1vieXApWY38YfZSk/jdbL
 vMbf5iuqN15w==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="229180102"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="229180102"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:13:36 -0700
IronPort-SDR: uq+ehLW7EhgsAAI5A6AXPSZWsdHzpY6vAGGpcTrWPJrkmq71vHLWKgGp73StACevklOxkf3S63
 0t5zw16LCKxg==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="528059100"
Received: from dumser-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.51.100])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:13:22 -0700
Date:   Wed, 7 Oct 2020 20:13:18 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20201007171318.GC3885@linux.intel.com>
References: <20201006151532.GA17610@linux.intel.com>
 <20201006172819.GA114208@linux.intel.com>
 <20201006232129.GB28981@linux.intel.com>
 <20201007002236.GA139112@linux.intel.com>
 <20201007011738.GE28981@linux.intel.com>
 <20201007031402.GA143690@linux.intel.com>
 <20201007043418.GG28981@linux.intel.com>
 <20201007073923.GA3632@linux.intel.com>
 <20201007152545.GB758@linux.intel.com>
 <20201007170818.GB3885@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007170818.GB3885@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 07, 2020 at 08:08:32PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 07, 2020 at 08:25:45AM -0700, Sean Christopherson wrote:
> > On Wed, Oct 07, 2020 at 10:39:23AM +0300, Jarkko Sakkinen wrote:
> > > On Tue, Oct 06, 2020 at 09:34:19PM -0700, Sean Christopherson wrote:
> > > > > Even if that was in place, you'd need to separate normal and interrupt.
> > > > > Tristate is useless here. 
> > > > 
> > > > Huh?  You mean like adding SGX_INTERRUPT_EXIT and SGX_EXCEPTION_EXIT?
> > > 
> > > OK, so I'll throw something.
> > > 
> > > 1. "normal" is either exception from either EENTER or ERESUME,
> > >    or just EEXIT.
> > > 2. "interrupt" is something where you want to tailor AEP path.
> > 
> > Manipulating the behavior of the vDSO, as in #2, would be done via an input
> > flag.  It may be related to the exit reason, e.g. the flag may also opt-in to
> > a new exit reason, but that has no bearing on whether or not a dedicated exit
> > reason is valuable.
> 
> The fact is that AEP path is not actual right now.
> 
> I'm not even interested to go further on discussing about feature that
> does not exist. Perhaps if/when it exist it turns out that we want a
> variable lets say 'exit_reason' to present something in that context.
> 
> I'm neither against that or for it because it is all speculative.
> 
> > > > I'm not arguing that any of the above is even remotely likely.  I just don't
> > > > understand why we'd want an API that at best requires heuristics in userspace
> > > > to determine why the enclave stopped running, and at worst will saddle us with
> > > > an ugly mess in the future.  All to save 4 bytes that no one cares about (they
> > > > literally cost nothing), and a single MOV in a flow that is hundreds, if not
> > > > thousands, of cycles.
> > > 
> > > I don't care as much as saving bytes as defining API, which has zero
> > > ambiguous state variables.
> > 
> > How is exit_reason ambiguous?
> 
> I rather pick the word redundant:
> 
> 1. 'leaf' exist anyway.
> 2. It can represent all the state we need right now.
> 3. It does not block anything.,
> 
> I care deeply about wasting 4 bytes in a fixed size struct for
> absolutely nothing.

And I do care about what to pick for the struct size. My remarks on
that are lost somewhere in this thread. I absoutely do not have any
interest whether 'exit_reason' in some future situation is useful
or not.

/Jarkko
