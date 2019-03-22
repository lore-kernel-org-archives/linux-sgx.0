Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1072AC43381
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 21:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAAB6218D3
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 21:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfCVV7F (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 17:59:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:13513 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbfCVV7F (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 17:59:05 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 14:59:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="144434603"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga002.jf.intel.com with ESMTP; 22 Mar 2019 14:59:03 -0700
Date:   Fri, 22 Mar 2019 14:59:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Message-ID: <20190322215903.GE12666@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 20, 2019 at 01:38:04PM -0700, Xing, Cedric wrote:
> > > By requiring preservation of RSP at both AEX and EEXIT, this precludes
> > > the possibility of using the untrusted stack as temporary storage by
> > > enclaves. While that looks reasonable at first glance, I'm afraid it
> > > isn't the case in reality. The untrusted stack is inarguably the most
> > > convenient way for data exchange between an enclave and its enclosing
> > > process,
> > 
> > I vehemently disagree with "inarguably".  IMO, passing data via
> > registers is much more convenient.
> 
> Which is the most convenient approach is always dependent on data size and/or even how the data is produced/consumed. It's kind of a spectrum and we're just talking in the sense of probability. You are right that "inarguably" is arguable if the buffer is small enough to fit in registers, and the producer/consumer also has access to registers.
> 
> > 
> > Even if you qualify your assertion with "data of arbitrary size unknown
> > at build time", I still disagree.  Using the untrusted stack allows for
> > trickery when a debugger is involved, other than that I see no
> > advantages over allocating virtual memory and handing the pointer to the
> > enclave at launch time.  Sure, it requires a few more lines of code to
> > setup, but it's literally ~20 LoC out of thousands required to sign,
> > build and launch an enclave, but it doesn't require playing games with
> > the stack.
> 
> I'm NOT ruling out your approach.
> 
> And like you said, the untrusted stack enables certain trickery that helps
> debugging and also simplifies enclaves (even just a little). Then why are
> you trying to rule that out? Because of 9 LOC in vDSO?

Although its just 9 LOC, consider its impact on someone who is looking at
the kernel's SGX support for the first time.  Questions they may have when
looking at the vDSO code/documentation:

  - What's an exit handler?
  - Why is an exit handler optional?  Don't I always want to handle exits?
  - What value should my exit handler return?
  - What should my exit handler do if it detects an error?
  - Why would I want to preserve %rbp and not %rsp?
  - Isn't it insecure to use the untrusted stack in my enclave?

AFAIK, the only reason to preserve %rbp instead of %rsp, i.e. support an
"exit handler" callback, is to be able to implement an o-call scheme using
the untrusted stack to pass data.  Every idea I came up with for using the
callback, e.g. logging, handling stack corruptiong, testing hooks, etc...
was at worst no more difficult to implement when using a barebones vDSO.

So, given the choice between a) documenting and maintaining all the baggage
that comes with the exit handler and b) saying "go use signals", I chose
option b.
