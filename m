Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3E9C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 14:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3145D20776
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 14:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgJEO3b (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:29:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:39367 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgJEO3a (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 10:29:30 -0400
IronPort-SDR: jmdeDNHVuudZ4/xIAmvdBr7do6spfC1DDOCZOXDCg/07RDNnZEzth86K+SYoeiz1YWdsSR340k
 bBpecW1Z/E3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="160971080"
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="160971080"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 07:23:56 -0700
IronPort-SDR: yKL8oPIdfoBU5LgqtWJBu0jJETZLDfiPWCkk/ZGVcL2gkse/q6Tp62Nt9Socah90hhyzFT2Vb7
 JchGdLGq/zVQ==
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="525934117"
Received: from gtudori-mobl.ger.corp.intel.com (HELO localhost) ([10.249.33.131])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 07:23:47 -0700
Date:   Mon, 5 Oct 2020 17:23:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201005142345.GA6232@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com>
 <20201005084554.GA3403@infradead.org>
 <20201005114250.GB181338@linux.intel.com>
 <20201005115030.GA682263@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201005115030.GA682263@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 01:50:30PM +0200, Greg KH wrote:
> On Mon, Oct 05, 2020 at 02:42:50PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Oct 05, 2020 at 09:45:54AM +0100, Christoph Hellwig wrote:
> > > On Sat, Oct 03, 2020 at 04:39:25PM +0200, Greg KH wrote:
> > > > > @@ -0,0 +1,173 @@
> > > > > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> > > > 
> > > > You use gpl-only header files in this file, so how in the world can it
> > > > be bsd-3 licensed?
> > > > 
> > > > Please get your legal department to agree with this, after you explain
> > > > to them how you are mixing gpl2-only code in with this file.
> > > > 
> > > > > +// Copyright(c) 2016-18 Intel Corporation.
> > > > 
> > > > Dates are hard to get right :(
> > > 
> > > As is comment formatting apparently.  Don't use // comments for anything
> > > but the SPDX header, please.
> > 
> > I'll bring some context to this.
> > 
> > When I moved into using SPDX, I took the example from places where I saw
> > also the copyright using "//". That's the reason for the choice.
> > 
> > I.e.
> > 
> > $ git grep "// Copyright" | wc -l
> > 2123
> > 
> > I don't care, which one to use, just wondering is it done in the wrong
> > way in all these sites?
> 
> Probably, but I know at least one subsystem requires their headers to be
> in this manner.  There's no accounting for taste :)

This discussion is a bit confusing [*], so I'll just ask from Git:

➜  linux-sgx (master) ✔ git --no-pager grep "\/\/ Copyright" arch/x86
arch/x86/kernel/cpu/sgx/driver.c:// Copyright(c) 2016-20 Intel Corporation.
arch/x86/kernel/cpu/sgx/encl.c:// Copyright(c) 2016-20 Intel Corporation.
arch/x86/kernel/cpu/sgx/ioctl.c:// Copyright(c) 2016-20 Intel Corporation.
arch/x86/kernel/cpu/sgx/main.c:// Copyright(c) 2016-20 Intel Corporation.

OK, now I think I know what to do :-)

> thanks,
> 
> greg k-h

[*] One thing I've been wondering for a long time is that, why new code
should have the copyright platters in the first place? I get it for
pre-Git era but now there is a cryptographic log of authority.

Copyright platters, remarking the authors to the header and
MODULE_AUTHOR() macro are the three things that I just do not get in the
modern times.

/Jarkko
