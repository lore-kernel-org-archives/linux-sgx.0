Return-Path: <SRS0=niAy=DQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9263CC43457
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Oct 2020 06:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4503022254
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Oct 2020 06:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgJIGoe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Oct 2020 02:44:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:42448 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgJIGoe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Oct 2020 02:44:34 -0400
IronPort-SDR: LE39SZeEM9U2OF07+jBN2Wq50RkfaouRxNbVBjBHxR511NrWaI3H2dRmojc9BB3ZmJIkuiAYMM
 NZgDc9+OMkbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="161987900"
X-IronPort-AV: E=Sophos;i="5.77,354,1596524400"; 
   d="scan'208";a="161987900"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 23:44:33 -0700
IronPort-SDR: nWBjKdL7QJVZTuBJO2CmcW40pcRcMkvlGVs5Nlm1P5gbFESmwMNOsL4oeVSGlwMwz5dwRHeEns
 ARpK4H9O1A7A==
X-IronPort-AV: E=Sophos;i="5.77,354,1596524400"; 
   d="scan'208";a="298346639"
Received: from rgordani-mobl.ger.corp.intel.com (HELO localhost) ([10.249.34.105])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 23:44:17 -0700
Date:   Fri, 9 Oct 2020 09:44:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20201009064414.GA2744@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com>
 <20201004143246.GA3561@linux.intel.com>
 <20201005094246.GB151835@kroah.com>
 <20201005124221.GA191854@linux.intel.com>
 <op.0r4p1bn7wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20201007192655.GA104072@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007192655.GA104072@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 07, 2020 at 09:26:55PM +0200, Greg KH wrote:
> On Wed, Oct 07, 2020 at 01:09:01PM -0500, Haitao Huang wrote:
> > > > > There is a patch that adds "sgx/provision".
> > > > 
> > > > What number in this series?
> > > 
> > > It's 15/24.
> > > 
> > 
> > Don't know if this is critical. I'd prefer to keep them as is. Directory
> > seems natural to me and makes sense to add more under the same dir in case
> > there are more to come.
> 
> Why is this so special that you need a subdirectory for a single driver
> with a mere 2 device nodes?  Do any other misc drivers have a new
> subdirectory in /dev/ for them?

Absolutely nothing as far as I'm concerned. Should have done that
already at the time when I switched to misc based on your feedback. I
was acting too reactive I guess. For sure I'll rename.

I also looked at encl->refcount with time. Instead of just "moving the
garbage up to the correct waste pit", I'll address that one by
refactoring it out and making the reclaimer thread to do the reaper's
job.

> thanks,
> 
> greg k-h

/Jarkko
