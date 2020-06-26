Return-Path: <SRS0=bCPb=AH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D2AC433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 13:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F49D2088E
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 13:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgFZNk2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 Jun 2020 09:40:28 -0400
Received: from mga04.intel.com ([192.55.52.120]:12509 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgFZNk2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 26 Jun 2020 09:40:28 -0400
IronPort-SDR: 7L5zhCV7TIxwWJp6K/utLTqbcwV0DIarwO/TvlLqCHeEbUPlID4X0+ZONks1id+dZ9jir9c69a
 EBGpSWTEb97w==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="142829052"
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="142829052"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 06:40:27 -0700
IronPort-SDR: 5aTYDJxytPvzzUBUDivWwJJcsPilqbm4B5+OPCXJvz1IrKvdCTC7bffLq59rKoQVbmk1UyXJjx
 ylq2M3rRMEEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="264216341"
Received: from cgheban-mobl.ger.corp.intel.com (HELO localhost) ([10.249.40.199])
  by fmsmga007.fm.intel.com with ESMTP; 26 Jun 2020 06:40:13 -0700
Date:   Fri, 26 Jun 2020 16:40:11 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200626134011.GA390691@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200625172319.GJ20319@zn.tnic>
 <20200625202148.GB15394@linux.intel.com>
 <20200625202520.GQ20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625202520.GQ20319@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 10:25:39PM +0200, Borislav Petkov wrote:
> On Thu, Jun 25, 2020 at 11:21:48PM +0300, Jarkko Sakkinen wrote:
> > Would be probably easier to review also this way because the commit kind
> > of rationalizes why things exist.
> > 
> > What do you think?
> 
> Sounds like a plan but you can do this for the next version - no need to
> do it now. I'll try to review this way, per ioctl as I said in my mail
> to Sean.

OK, sure I won't rush with a new version :-)

The code has been reworked so many times that it is somewhat easy to
make such split and I think it is one measure that an implementation is
somewhat sound when parts of functionality build up cleanly on top of
each other.

/Jarkko
