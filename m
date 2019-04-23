Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67599C10F03
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 18:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3205F208E4
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 18:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfDWS7j (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Apr 2019 14:59:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:50226 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfDWS7i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Apr 2019 14:59:38 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Apr 2019 11:59:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,386,1549958400"; 
   d="scan'208";a="138176113"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga006.jf.intel.com with ESMTP; 23 Apr 2019 11:59:38 -0700
Date:   Tue, 23 Apr 2019 11:59:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Cedric Xing <cedric.xing@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave <dave.hansen@intel.com>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge <serge.ayoun@intel.com>,
        Shay <shay.katz-zamir@intel.com>,
        Haitao <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kai <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai <kai.huang@intel.com>, David Rientjes <rientjes@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [RFC PATCH v1 3/3] selftests/x86: Augment SGX selftest to test
 new __vdso_sgx_enter_enclave() and its callback interface
Message-ID: <20190423185937.GD10720@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <cover.1555965327.git.cedric.xing@intel.com>
 <f82e81c9cae31634684964d3fc4e9637e7565c69.1555965327.git.cedric.xing@intel.com>
 <CALCETrWpMxoX00SfnCgYdNbT5JmnzHNJ+73NmUjebBEjk7DuJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWpMxoX00SfnCgYdNbT5JmnzHNJ+73NmUjebBEjk7DuJA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 06:29:06PM -0700, Andy Lutomirski wrote:
> What's not tested here is running this code with EFLAGS.TF set and
> making sure that it unwinds correctly.  Also, Jarkko, unless I missed
> something, the vDSO extable code likely has a bug.  If you run the
> instruction right before ENCLU with EFLAGS.TF set, then do_debug()
> will eat the SIGTRAP and skip to the exception handler.  Similarly, if
> you put an instruction breakpoint on ENCLU, it'll get skipped.  Or is
> the code actually correct and am I just remembering wrong?

The code is indeed broken, and I don't see a sane way to make it not
broken other than to never do vDSO fixup on #DB or #BP.  But that's
probably the right thing to do anyways since an attached debugger is
likely the intended recipient the 99.9999999% of the time.

The crux of the matter is that it's impossible to identify whether or
not a #DB/#BP originated from within an enclave, e.g. an INT3 in an
enclave will look identical to an INT3 at the AEP.  Even if hardware
provided a magic flag, #DB still has scenarios where the intended
recipient is ambiguous, e.g. data breakpoint encountered in the enclave
but on an address outside of the enclave, breakpoint encountered in the
enclave and a code breakpoint on the AEP, etc...
