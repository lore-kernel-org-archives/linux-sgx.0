Return-Path: <SRS0=Tkjg=R4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D56EC10F03
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Mar 2019 18:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40ABD2087C
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Mar 2019 18:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfCYSDw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:03:52 -0400
Received: from mga18.intel.com ([134.134.136.126]:57186 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbfCYSDw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 25 Mar 2019 14:03:52 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Mar 2019 11:03:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,269,1549958400"; 
   d="scan'208";a="137308080"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga007.fm.intel.com with ESMTP; 25 Mar 2019 11:03:49 -0700
Date:   Mon, 25 Mar 2019 11:03:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Message-ID: <20190325180349.GF31069@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
 <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 24, 2019 at 01:59:48AM -0700, Xing, Cedric wrote:
> As said in my previous email, this vDSO API isn't even compliant to
> x86_64 ABI and is absolutely NOT for average developers. Instead,
> host/enclave communications are expected to be handled by SDKs and
> those developers will be very aware of the limitations of their targeted
> environments, and will need the freedom to deploy optimal solutions. 

This statement epitomizes the difference in philosophies between Intel's
SGX SDK and much of the Linux community.  The SDK, from edger8r to its
stack stitching, believes that it should dumb things down for the so
called "average" developer, even if doing so significantly increases the
complexity of the implementation.  Linux generally favors the opposite
approach, preferring simplicitly in its implementations even if it means
setting a higher bar for the "average" developer/user.

That's not to say that that Linux doesn't have its fair share of complex
code or dumbed down interfaces, far from it.  But generally speaking,
there is an emphasis on making the code itself approachable that I don't
see in Intel's SDK.

> I understand your intention to advocate the programming model that you
> believe is "right". But there are 7 billion people on this planet and
> the "right" thing for you could be "wrong" for others, especially in
> future usages/situations that can't be foreseen today.

IMO modifying SSA.U_R{B,SP} from within the enclave is akin to modifying
VMCS fields from the guest, which is technically possible on processors
that don't support VMCS caching, but I digress...

The above statements aren't intended to fan the flames or send us down
a rat hole of philosophical arguments.  My intent is to point out that
I think we're at an impasse due to philosophical differences, i.e. no
amount of arguing will convince me that mucking with the untrusted stack
is anything short of insanity, and vice versa I doubt that Andy, I or
anyone else will convince you and the SDK team that forcing the SDK to
use an alternative form of enclave communication is a good thing.

> Software is stacked, with the lower layers being more generic and higher
> layers being more specific. This vDSO API is sitting at the bottom of
> the stack, therefore shall be as generic as possible. A better approach
> to advocate your idea is to wrap it (i.e. to implement it using the more
> generic vDSO API as a

It's not more generic, just different, e.g. uses %rbp instead of %rsp as
the anchor.  Or am I missing something?  

> subroutine) in a library for the public to choose (and you can imagine
> others bearing different ideas will do the same). Then good ideas will
> stand out!

I'd rather support two disparate vDSO implementations than implement the
barebones ABI as a wrapper to something heavier.  E.g. I really don't want
to have to wade through a bunch of conditionals and stack accesses, (or
save/restore code if you're talking about making it compliant with the
x86_64 ABI) when I inevitably break something during kernel development.

Given all above, and that everyone involved wants to see SGX get accepted
into mainline sooner rather than later, I propose the following:

  - Keep the barebones __vdso_sgx_enter_enclave() as is
  - Explicitly state in the SGX documentation that userspace does *not*
    have to use the vDSO, e.g. can enter enclaves directly and use signals
  - Submit a patch to add second vDSO function to support the Intel SDK
    use case (from Cedric or anyone from the SDK team)

I fully realize that the above approach saddles Cedric and the SDK team
with the extra task of justifying the need for two vDSO interfaces, and
likely reduces the probability of their proposal being accepted.  But, we
don't *force* the SDK to be rewritten, and we gain a vDSO interface that
many people want and is acceptable to the maintainers (unless I've
horribly misread Andy's position).
