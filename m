Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208D2C0044D
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 23:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0DBC205ED
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 23:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732989AbgCPX7f (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 19:59:35 -0400
Received: from mga06.intel.com ([134.134.136.31]:48081 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732932AbgCPX7f (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 19:59:35 -0400
IronPort-SDR: rzKtaOE/4Ri3zXuy263VksSdMeBJ7wjvonGcL1F1CV5OHOJxe8PWrHXFrIK8CWZnTSkkO+L0HX
 nOI9CzZdDlLQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 16:59:34 -0700
IronPort-SDR: EXC5OOzw7kiXij0nmleAvE4HV7gl1QOatOdI+iOuUlgq374R5zeDr8XW1LmjOeNWMBJmjRY+II
 7ydyTJgBvJ/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,562,1574150400"; 
   d="scan'208";a="233334574"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 16 Mar 2020 16:59:34 -0700
Date:   Mon, 16 Mar 2020 16:59:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200316235934.GM24267@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com>
 <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <94ce05323c4de721c4a6347223885f2ad9f541af.camel@linux.intel.com>
 <CAOASepM1pp1emPwSdFcaRkZfFm6sNmwPCJH+iFMiaJpFjU0VxQ@mail.gmail.com>
 <5dc2ec4bc9433f9beae824759f411c32b45d4b74.camel@linux.intel.com>
 <20200316225322.GJ24267@linux.intel.com>
 <fa773504-4cc1-5cbd-c018-890f7a5d3152@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa773504-4cc1-5cbd-c018-890f7a5d3152@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 16, 2020 at 04:50:26PM -0700, Xing, Cedric wrote:
> On 3/16/2020 3:53 PM, Sean Christopherson wrote:
> >On Mon, Mar 16, 2020 at 11:38:24PM +0200, Jarkko Sakkinen wrote:
> >>>My suggestions explicitly maintained robustness, and in fact increased
> >>>it. If you think we've lost capability, please speak with specificity
> >>>rather than in vague generalities. Under my suggestions we can:
> >>>1. call the vDSO from C
> >>>2. pass context to the handler
> >>>3. have additional stack manipulation options in the handler
> >>>
> >>>The cost for this is a net 2 additional instructions. No existing
> >>>capability is lost.
> >>
> >>My vague generality in this case is just that the whole design
> >>approach so far has been to minimize the amount of wrapping to
> >>EENTER.
> >
> >Yes and no.   If we wanted to minimize the amount of wrapping around the
> >vDSO's ENCLU then we wouldn't have the exit handler shenanigans in the
> >first place.  The whole process has been about balancing the wants of each
> >use case against the overall quality of the API and code.
> >
> The design of this vDSO API was NOT to minimize wrapping, but to allow
> maximal flexibility. More specifically, we strove not to restrict how info
> was exchanged between the enclave and its host process. After all, calling
> convention is compiler specific - i.e. the enclave could be built by a
> different compiler (e.g. MSVC) that doesn't share the same list of CSRs as
> the host process. Therefore, the API has been implemented to pass through
> virtually all registers except those used by EENTER itself. Similarly, all
> registers are passed back from enclave to the caller (or the exit handler)
> except those used by EEXIT. %rbp is an exception because the vDSO API has to
> anchor the stack, using either %rsp or %rbp. We picked %rbp to allow the
> enclave to allocate space on the stack.

And unless I'm missing something, using %rcx to pass @leaf would still
satisfy the above, correct?  Ditto for saving/restoring %rbx.

I.e. a runtime that's designed to work with enclave's using a different
calling convention wouldn't be able to take advantage of being able to call
the vDSO from C, but neither would it take on any meaningful burden. 
