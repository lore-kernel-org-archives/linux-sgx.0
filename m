Return-Path: <SRS0=YsX3=DN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDC0C4363D
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 21:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A19208B6
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 21:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgJFVjm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Oct 2020 17:39:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:34353 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgJFVjm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Oct 2020 17:39:42 -0400
IronPort-SDR: 9XGqDjiqtrUYV0KlU8DWkVAEVJftzxGa0kKjO44Bi2//ljugVD6ra7UKMfPqYwz4f1OuC/zaTK
 HjsX4ahYA5ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="249417694"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="249417694"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 14:39:42 -0700
IronPort-SDR: xwAgZuFlMjuMIPVTGKSiVBZcuPmai61VqTFeIzNfv7GhMjKrM6kvpW5vO3nPTAS5Olg7duMjw0
 0/uopQuHPqsw==
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="527608885"
Received: from thijsmet-mobl.ger.corp.intel.com (HELO localhost) ([10.249.34.36])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 14:39:35 -0700
Date:   Wed, 7 Oct 2020 00:39:27 +0300
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
Message-ID: <20201006213927.GA117517@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
 <20201006025703.GG15803@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006025703.GG15803@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 07:57:05PM -0700, Sean Christopherson wrote:
> On Sat, Oct 03, 2020 at 07:50:56AM +0300, Jarkko Sakkinen wrote:
> > +	__u16 exception_vector;
> > +	__u16 exception_error_code;
> > +	__u64 exception_addr;
> > +	__u8  reserved[24];
> 
> I also think it's a waste of space to bother with multiple reserved fields.
> 24 bytes isn't so much that it guarantees we'll never run into problems in
> the future.  But I care far less about this than I do about exit_reason.

For me the real problem is that there has not been "no brainer" basis
for any size, so a one cache line worth of data is just something that
makes sense, because would neither make much sense to have less.

I'll throw an argument to have it a bit bigger amount of reserved space
for future use.

First, there is always some amount of unknown unknowns when it comes to
run-time structures, given the evolution of microarchitectures. So yes,
some more "state" might be needed in the future.

Secondly, this is a bigger problem for the vDSO than it is for ioctl's
because we can have only one. With ioctl's, in the absolute worst case,
we can have a second version of the same ioctl.

At least 256 bytes would be probably a good number, if we want to
increase it. The reserved space zero validation that I implemented to
this version probably does not add much to the overhead anyway.

I'm not sure why care about one struct field more than making sure that
the run-time structure can stand time.

/Jarkko
