Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BB9C4363C
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 19:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37D8E2193E
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 19:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgIUT5n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 15:57:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:18715 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbgIUT5n (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 15:57:43 -0400
IronPort-SDR: mtolsfzPmYFynLZTWVcerj3IcBfGEHhTSCio/5o9+nQLaBV8aBo8iGN2j57bSvb25PxncOqZ7D
 WpjM2y9nx9Ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="139954878"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="139954878"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 12:57:41 -0700
IronPort-SDR: kdjKeZYtMnqjd8V7xbFRTUzDMjrFCPrN4d/eQ8GWvE/sB6CZg6mYP9x6WTUQMDItv0x105YCmt
 B8PwFy1Xpu1w==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="485647450"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 12:57:40 -0700
Date:   Mon, 21 Sep 2020 12:57:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200921195738.GB25005@linux.intel.com>
References: <20200917160206.GF8530@linux.intel.com>
 <op.0q3pw0stwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200918020940.GA14678@sjchrist-ice>
 <20200918122029.GA27028@linux.intel.com>
 <20200918123932.GB27028@linux.intel.com>
 <20200919000918.GB21189@sjchrist-ice>
 <20200921114104.GB6038@linux.intel.com>
 <20200921164647.GC23989@linux.intel.com>
 <20200921184948.GA49586@linux.intel.com>
 <20200921194419.GA56547@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921194419.GA56547@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 10:44:19PM +0300, Jarkko Sakkinen wrote:
> On Mon, Sep 21, 2020 at 09:49:48PM +0300, Jarkko Sakkinen wrote:
> > To have understandable semantics you have to map error codes to
> > conditions rather than opcodes. -EIO means loss of enclave in the event
> > of EPC gone invalid. Enclave is already lost, that is the reason why we
> > deinitialize the kernel data structures.
> > 
> > EADD must have a different error code because nothing is actually lost
> > but the failure conditions are triggered outside. -EFAULT would be
> > probably the most reasonable choice for that.
> 
> Now that I did all the changes discussed and then I remember why EADD
> and EEXTEND had a common error code, and common behaviour. Obviously EADD
> can also fail because of EPC reset because it depends on a valid SECS
> page.
> 
> If we cannot distinct from EADD caused by EPC loss and EADD caused by
> problems with the source, it should have the same error code, and also
> the enclave should be deinitialized, whenver this happens.

Hmm, on SGX2 hardware the kernel can precisely and accurately identify loss
of EPC, or at least "problem with the EPCM", as such a condition will be a
page fault with PFEC.SGX=1.

But getting that info back to the ENCLS invocation would require adding a
new exception fixup handler in order to "return" the error code.  Given that
this is the only case where that level of precision makes a difference, I
think it's ok to just kill the enclave on any EADD failure.  Practically
speaking I highly doubt the overzealous killing will impact userspace, I
would imagine any SGX runtime would treat -EFAULT as fatal anyways.

Side topic, this does invalidate my argument for not killing the enclave on
EADD failure.  If EADD fails due to loss of EPC, it's theoretically possible
userspace could get stuck in an infinite loop if it does a naive retry on
-EIO or whatever.

> So I would just revert to v38 behaviour, keeping of course the whole
> check more visible in sgx_ioc_enclave_add_pages(), and just refine
> the documentation better describe the whole situation.
> 
> /Jarkko
