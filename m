Return-Path: <SRS0=squH=AO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED17C433DF
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 02:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 450C3206B6
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jul 2020 02:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGCCnU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jul 2020 22:43:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:52639 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgGCCnT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Jul 2020 22:43:19 -0400
IronPort-SDR: DnTypM+rf095QYwgEEy1RksUZGcUQdgWdVnHM6g5h97Z6n1OLucRgvemkJIpgvI58ahLd00plj
 GfsAycXJSVsw==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="145214498"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="145214498"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 19:43:19 -0700
IronPort-SDR: sh4ii63JUXfIPRRYi0OODWiCMF/EwEvinzpkvw5G3VxEDELE9JNnC9U4X/apVWNFjvKjH2jWTu
 yNoq55+mXJKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="282152331"
Received: from skochetx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.55.66])
  by orsmga006.jf.intel.com with ESMTP; 02 Jul 2020 19:43:07 -0700
Date:   Fri, 3 Jul 2020 05:43:06 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 12/21] x86/sgx: Allow a limited use of
 ATTRIBUTE.PROVISIONKEY for attestation
Message-ID: <20200703024306.GC306897@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com>
 <20200629160242.GB32176@zn.tnic>
 <20200629220400.GI12312@linux.intel.com>
 <20200630084956.GB1093@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630084956.GB1093@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 30, 2020 at 10:49:56AM +0200, Borislav Petkov wrote:
> On Mon, Jun 29, 2020 at 03:04:00PM -0700, Sean Christopherson wrote:
> > > I don't see this acronym resolved anywhere in the whole patchset.
> > 
> > Quoting Enclave.
> 
> Yah, pls add it somewhere.
> 
> > /dev/sgx/provision is root-only by default, the expectation is that the admin
> > will configure the system to grant only specific enclaves access to the
> > PROVISION_KEY.
> 
> Uuh, I don't like "the expectation is" - the reality happens to turn
> differently, more often than not.
> 
> > In this series, access is fairly binary, i.e. there's no additional kernel
> > infrastructure to help userspace make per-enclave decisions.  There have been
> > more than a few proposals on how to extend the kernel to help provide better
> > granularity, e.g. LSM hooks, but it was generally agreed to punt that stuff
> > to post-upstreaming to keep things "simple" once we went far enough down
> > various paths to ensure we weren't painting ourselves into a corner.
> 
> So this all sounds to me like we should not upstream /dev/sgx/provision
> now but delay it until the infrastructure for that has been made more
> concrete. We can always add it then. Changing it after the fact -
> if we have to and for whatever reason - would be a lot harder for a
> user-visible interface which someone has started using already.
> 
> So I'd leave  that out from the initial patchset.

I'm trying to understand what is meant by "more concrete". Attestation
is needed for most enclave applications.

If this patch is dropped, should we also allow PROVISION_KEY attribute
to all enclaves?  Dropping this patch and keeping that check in the
driver patch is not very coherent behaviour.

/Jarkko
