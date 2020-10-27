Return-Path: <SRS0=uhim=EC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E3CC5DF9D
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 00:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C02252080A
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 00:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409655AbgJ0AoV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:44:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:46229 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502186AbgJ0Akw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Oct 2020 20:40:52 -0400
IronPort-SDR: cGpjSswb0eCKVeqfg0FtFmABXxq8+3f6yrSNERdiXOPp46DlYSG3uGKrj4cnlLU8126Wnz0Vwh
 OTXFxlIhV5vg==
X-IronPort-AV: E=McAfee;i="6000,8403,9786"; a="164509022"
X-IronPort-AV: E=Sophos;i="5.77,421,1596524400"; 
   d="scan'208";a="164509022"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 17:40:51 -0700
IronPort-SDR: os461CjYNM3H4l2jv7ewAZ4j2EOy4Rs+7Bp43uIB9IyeLcIxtvzxY2ip6+5KItGClBh6ZQbLuR
 E4LNYcB7UQGw==
X-IronPort-AV: E=Sophos;i="5.77,421,1596524400"; 
   d="scan'208";a="322739919"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 17:40:50 -0700
Date:   Mon, 26 Oct 2020 17:40:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <20201027004048.GC28122@linux.intel.com>
References: <20201026105128.GA30004@wind.enjellic.com>
 <4B39703F-280C-4AED-B4BB-047BD216B792@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B39703F-280C-4AED-B4BB-047BD216B792@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 26, 2020 at 03:59:35PM -0700, Andy Lutomirski wrote:
> > On Oct 26, 2020, at 3:51 AM, Dr. Greg <greg@enjellic.com> wrote:
> > The open question in all of this is that the EDMM paper, as well as
> > the SDM, indicate the effects of an ENCLU[EMODPE] are immediate inside
> > of a running enclave.  I'm assuming that this does NOT mean that once
> > a context of execution is running in enclave mode it would be capable
> > of evading standard page protections but the 'immediate' is somewhat
> > disquieting and probably deserves clarification, despite Dave Hansen's
> > adament concerns about discussing the instruction... :-)
> 
> If EMODPE writes an entry into the TLB that violates PTE permissions, then we
> have a real problem. I would be very surprised if this were to be the case.

EMODPE only affects the EPCM, it doesn't magically change the PTEs or insert
into the TLB.  The "immediate" wording in the whitepaper is differentiating it
from EMODPR and EMODT, where the modifications only take effect after they have
been verified by the enclave via EACCEPT.
