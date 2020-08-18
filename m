Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC9FC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 17:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93DFB20674
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 17:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgHRRcA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 13:32:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:48139 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgHRRb7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 13:31:59 -0400
IronPort-SDR: ipxHmS1dcao0JKereJL0sCCb6GZD0neptKqj4jQJkxaugi4Svsds+WIhhQhL90uKS0CIKo+znR
 fotTsUmKRpmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="152590414"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="152590414"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 10:31:56 -0700
IronPort-SDR: hIdP3roBdX1abU7H+B8sSPLDVGrWxHYyDyATrzt+A+HpIvnAZZoEMzex/AOe3MRDR3jEb5lAtb
 dvP3CrVnRzIQ==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="441301041"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 10:31:56 -0700
Date:   Tue, 18 Aug 2020 10:31:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>, linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
Message-ID: <20200818173154.GH15390@linux.intel.com>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com>
 <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 18, 2020 at 10:15:49AM -0700, Andy Lutomirski wrote:
> On Mon, Aug 17, 2020 at 9:24 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Allow userspace to exit the vDSO on interrupts that are acknowledged
> > while the enclave is active.  This allows the user's runtime to switch
> > contexts at opportune times without additional overhead, e.g. when using
> > an M:N threading model (where M user threads run N TCSs, with N > M).
> 
> This is IMO rather odd.  We don't support this type of notification on
> interrupts for normal user code.  The fact user code can detect
> interrupts during enclave execution is IMO an oddity of SGX, and I
> have asked Intel to consider replacing the AEX mechanism with
> something more transparent to user mode.  If this ever happens, this
> mechanism is toast.
> 
> Even without architecture changes, building a *reliable* M:N threading
> mechanism on top of this will be difficult or impossible, as there is
> no particular guarantee that a thread will get timing interrupts at
> all or that these interrupts will get lucky and hit enclave code, thus
> triggering an AEX.  We certainly don't, and probably never will,
> support any corresponding feature for non-enclave code.
> 
> So this seems like an odd, and possibly unsupportable, feature to add.

I 100% agree that allowing the user to act on interrupts is weird/fragile.
I'll happily kill this off if there's an "official" NAK, but I wanted to
force the issue so that we're not stuck in limbo wondering whether or not
this should be supported.
