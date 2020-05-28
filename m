Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD13FC433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 05:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EA332089D
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 05:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgE1Ff0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 May 2020 01:35:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:27657 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgE1FfY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 May 2020 01:35:24 -0400
IronPort-SDR: FHXnK9Maj7ZNZj53iIigx+O+2NCN+ULZ3KGQ4ARvyKs0B60rytQek2lSH64nh2cUcq5Q4yQl3T
 LA1jz4OWjssA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 22:35:24 -0700
IronPort-SDR: 2SdZPj0yQJCpDgubaEXU7UpditVC8ZiB2VgwMVvDrrBNNM3qQfr4Hc8v+7E2YIyPA5DxAwDcQp
 tqsYYv4V1sbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="468995652"
Received: from dmescala-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.59.102])
  by fmsmga005.fm.intel.com with ESMTP; 27 May 2020 22:35:16 -0700
Date:   Thu, 28 May 2020 08:35:15 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 07/20] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200528053515.GA64796@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-8-jarkko.sakkinen@linux.intel.com>
 <20200525092304.GD25636@zn.tnic>
 <20200527035613.GH31696@linux.intel.com>
 <20200528052532.GA63435@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528052532.GA63435@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 28, 2020 at 08:25:43AM +0300, Jarkko Sakkinen wrote:
> On Tue, May 26, 2020 at 08:56:14PM -0700, Sean Christopherson wrote:
> > On Mon, May 25, 2020 at 11:23:04AM +0200, Borislav Petkov wrote:
> > > On Fri, May 15, 2020 at 03:43:57AM +0300, Jarkko Sakkinen wrote:
> > > > +struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> > > > +int sgx_nr_epc_sections;
> > > 
> > > We have become very averse against global stuff. What is going to use
> > > those, only sgx code I assume...?
> > 
> > Yes, only SGX code.  The reclaim/swap code needs access to the sections,
> > and that code is in a different file, reclaim.c.  I don't have a super
> > strong objection to sucking reclaim.c into main.c, but I'm somewhat
> > indifferent on code organization as a whole.  Jarkko likely has a stronger
> > opinion.
> 
> I'll change it.
> 
> It's not quite as easy as just "sucking the file in". All the commits
> that touch the file need to be reworked:
> 
> $ git --no-pager log --format="%H %s" arch/x86/kernel/cpu/sgx/reclaim.c
> 5aeca6dabf767e9350ee3188ba25ceb21f3162b4 x86/sgx: Add a page reclaimer
> de9b1088959f36ffdaf43a49bfea1c7f9f81cac7 x86/sgx: Linux Enclave Driver
> 08d8fcb74fe268059ee58fcc2a0833b244e1f22a x86/sgx: Enumerate and track EPC sections

Not that I haven't done this a lot last few years. A proven approach
is to do it in two "git rebase -i mainline/master" sweeps:

1. For each commit, remove reclaim.c entry from the Makefile and import
   reclaim.c contents to main.c.
2. For each commit, delete reclaim.c.

I've tried quite a few different angles and this what I've converged
into. Very hard to hit messy into messy merge conflicts.

/Jarkko
