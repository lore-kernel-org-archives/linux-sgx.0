Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B48C4363D
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 00:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9618D206F0
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 00:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgJGAYM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Oct 2020 20:24:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:55216 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgJGAYM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Oct 2020 20:24:12 -0400
IronPort-SDR: CHD6U3cPDX8wG8uYttm4VanHDDB8phXR/ijV9867je9IctJWYxmfXHFMuc4LNywoQWPp6LZZ4C
 cAYyPVKp7+TA==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="144151835"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="144151835"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 17:24:11 -0700
IronPort-SDR: bOAvkYbslB+MgYLitLBi35IwGiJ1F8dCfaMJWlBxeya4sAlaRL1IPSPxpAZE8m3BibUWzh7XvM
 Dxb8wSzdSYEQ==
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="342595610"
Received: from thijsmet-mobl.ger.corp.intel.com (HELO localhost) ([10.249.34.36])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 17:24:05 -0700
Date:   Wed, 7 Oct 2020 03:23:57 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20201007002357.GB139112@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
 <20201006025703.GG15803@linux.intel.com>
 <20201006213927.GA117517@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006213927.GA117517@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 07, 2020 at 12:39:27AM +0300, Jarkko Sakkinen wrote:
> On Mon, Oct 05, 2020 at 07:57:05PM -0700, Sean Christopherson wrote:
> > On Sat, Oct 03, 2020 at 07:50:56AM +0300, Jarkko Sakkinen wrote:
> > > +	__u16 exception_vector;
> > > +	__u16 exception_error_code;
> > > +	__u64 exception_addr;
> > > +	__u8  reserved[24];
> > 
> > I also think it's a waste of space to bother with multiple reserved fields.
> > 24 bytes isn't so much that it guarantees we'll never run into problems in
> > the future.  But I care far less about this than I do about exit_reason.
> 
> For me the real problem is that there has not been "no brainer" basis
> for any size, so a one cache line worth of data is just something that
> makes sense, because would neither make much sense to have less.
> 
> I'll throw an argument to have it a bit bigger amount of reserved space
> for future use.
> 
> First, there is always some amount of unknown unknowns when it comes to
> run-time structures, given the evolution of microarchitectures. So yes,
> some more "state" might be needed in the future.
> 
> Secondly, this is a bigger problem for the vDSO than it is for ioctl's
> because we can have only one. With ioctl's, in the absolute worst case,
> we can have a second version of the same ioctl.
> 
> At least 256 bytes would be probably a good number, if we want to
> increase it. The reserved space zero validation that I implemented to
> this version probably does not add much to the overhead anyway.
> 
> I'm not sure why care about one struct field more than making sure that
> the run-time structure can stand time.

So what I could do is to grow the reserved area and based on my response
explain this in the changelog message but I need to make sure that I got
the reasoning right behind the size.

/Jarkko
