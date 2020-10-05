Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A23C4363D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 22:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1554520674
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 22:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgJEWBI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 18:01:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:8334 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgJEWBH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 18:01:07 -0400
IronPort-SDR: RMqQ/BZdLE058YVrae7Qlm7RRDExHxpVymqOD45PobyantZ9DaiVWdyVCmIYrEfdGFK+Itvcv4
 d2SjohwcbjaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="151920993"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="151920993"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP; 05 Oct 2020 14:50:19 -0700
IronPort-SDR: HGCM3TQcZ1XEA8IhISPY2vUnO9KKPYUFa/u1fqRdeaX/m6BqApXMSlxLg6x24yzftKgVANW8gr
 YTsx0OH0JTAQ==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="526895646"
Received: from gtudori-mobl.ger.corp.intel.com (HELO localhost) ([10.252.34.57])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 13:02:32 -0700
Date:   Mon, 5 Oct 2020 23:02:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>, x86@kernel.org,
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
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201005200228.GA43617@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com>
 <20201005084554.GA3403@infradead.org>
 <20201005114250.GB181338@linux.intel.com>
 <20201005115030.GA682263@kroah.com>
 <20201005142345.GA6232@linux.intel.com>
 <20201005150244.GA2288878@kroah.com>
 <4f66422c-a7ac-2962-c836-eb2ad06a11ce@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f66422c-a7ac-2962-c836-eb2ad06a11ce@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 09:40:52AM -0700, Dave Hansen wrote:
> On 10/5/20 8:02 AM, Greg KH wrote:
> > On Mon, Oct 05, 2020 at 05:23:45PM +0300, Jarkko Sakkinen wrote:
> >> [*] One thing I've been wondering for a long time is that, why new code
> >> should have the copyright platters in the first place? I get it for
> >> pre-Git era but now there is a cryptographic log of authority.
> > Go talk to your corporate lawyers about this, it is one of the most
> > common cargo-cult patterns around :)
> 
> For this patch, though, it seems like we should just update the dates
> instead of removing them.

Already done. I updated them yesterday as:

  Copyright(c) 2016-20 Intel Corporation.

Changing from '//' to '/* ... */' is not yet.

> If I look at the last 1000 "^+.*Copyright" lines added to the kernel,
> 997 of them have a year.  So, weird or not, it's a pretty standard
> convention.  We'd need a slightly more broad conversation before we
> decide to nix these dates.
> 
> Pure speculation: Copyright protection, at least in the US, is not
> forever.  I _think_ it's 75 years or something.  That protection starts
> when the work is created and is independent of when it gets merged into
> Linux.  So, if we did something weird like merge a driver written 10
> years ago, it would only be protected for 65 more years after we merge
> it.  In other words, git history _might_ be irrelevant for copyright
> protection.

/Jarkko
